<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true
server.ScriptTimeout = 5000
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: historico escolar
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%

	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strTipoAtualizacao	= Trim(Request.Form("cmbTipoAtualizacao"))
	strSituacaoAluno	= Trim(Request.Form("cmbSituacaoAluno"))
	vetAluno			= split(Trim(Request.form("chkAluno")),",")

	'carregando variavel
	strCodTurma 		= Trim(Request.Form("cmbTurma"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	strSemestre 		= Trim(Request.Form("cmbSemestre"))
	if strSemestre = "" then 	strSemestre  = session("strSemestre")
	if strCodTurma = "" then strCodTurma = "0"

	' Consulto o Nome da Turma
	if strCodTurma <> "0" then
		sql = "select COD_SEMESTRE, DesvincularCriterioAvaliacao from SCA_TURMA"
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And Cod_Turma = " & strCodTurma
		rs.open sql, cnn,3,3
		if rs.eof = false then
			strSemestre = RS("COD_SEMESTRE")
			strDesvincularCriterioAvaliacao = rs("DesvincularCriterioAvaliacao")
		end if
		rs.close	
	end if
	
	'Busca o codigo da situação de ativação
	sql = " SELECT COD_SITUACAOALUNO FROM SCA_SITUACAOALUNO"
	sql = sql & " WHERE COD_EMPRESA = " & intCodEmp 
	sql = sql & " AND DESC_SITUACAOALUNO='ATIVO' "
	rs.open sql, cnn, 3, 3
	if not rs.EOF then	
	   intCodSituacaoAtivo = rs("COD_SITUACAOALUNO")
	else
	   %>
		<script>
			alert("ATENÇÃO! Situação ATIVO não cadastrada. Verifique!");
			window.location='AtualizaHistorico_cad.asp';
		</script>
		<%
        response.end
	end if
	rs.close
	
	sql = " select "
	sql = sql & " 	razaosocial as escola,"
	sql = sql & " 	municipio as cidade,"
	sql = sql & " 	uf"
	sql = sql & " from seg_empresa"
	sql = sql & " where codigo = " & intCodEmp
	rs.open sql, cnn, 3, 3
	if not rs.eof then
		strCidade = rs("cidade")
		strEscola = rs("escola")
		strUF = rs("uf")
	end if
	rs.close
	
	sql = "select CODIGO from SCF_UF"
	sql = sql & " where sigla = '" & strUF & "'"
	rs.open sql, cnn, 3, 3
	if not rs.eof then
		strUF = rs("CODIGO")
	end if
	rs.close		

	intRegistrosAtualizados = 0
	intRegistrosNaoAtualizados = 0


	for i=0 to uBound(vetAluno)	
	
		intCodAluno = vetAluno(i)
		vetAux1 = null

		strMatricula 		= ""
		sql = "Select matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & intCodEmp
		sql = sql & " and codigo = " & intCodAluno
		rsAux1.open sql, cnn
		if rsAux1.eof = false then
			strMatricula 		= Trim(rsAux1("Matricula"))
		end if
		rsAux1.close	

		'busca informações para atualizar o historico
		sql = "select distinct m.ano_letivo, m.semestre, c.descricao as curso, p.descricao as periodo, p.cod_curso, p.cod_periodo"
		sql = sql & " from sca_notas_faltas m"
		sql = sql & " inner join sca_periodo p	   on p.cod_periodo = m.cod_periodo and p.cod_empresa = m.cod_empresa"
		sql = sql & " inner join sca_curso c	   on c.Cod_Curso = p.Cod_Curso and c.cod_empresa = p.cod_empresa"
		sql = sql & " where	m.cod_aluno = " & intCodAluno
		sql = sql & " and	m.ano_letivo = " & strAnoLetivo
		sql = sql & " and	m.cod_empresa = " & intCodEmp
		sql = sql & " and	m.semestre in (" & strSemestre & ")"
		rsAux1.open sql, cnn, 3, 3
		if not rsAux1.eof then
			vetAux1 = rsAux1.getRows
		end if
		rsAux1.close
			
		if isArray(vetAux1) then
		
			for j=0 to ubound(vetAux1,2)
	
				strCurso  		= vetAux1(2,j) 'rsAux1("curso")
				strSerie  		= vetAux1(3,j) 'rsAux1("periodo")
				strSemestre 	= vetAux1(1,j) 'rsAux1("semestre")
				intCodCurso		= vetAux1(4,j) 'Trim(rsAux1("cod_curso"))
				intCodPeriodo	= vetAux1(5,j) 'Trim(rsAux1("cod_periodo"))

				codHistoricoEscolarAnterior = ""
				sql = "SELECT codigo"
				sql = sql & " FROM SCA_HISTORICO_ESCOLAR"
				SQL = SQL & " WHERE cod_aluno = " & intCodAluno
				SQL = SQL & " AND cod_empresa = " & intCodEmp
				SQL = SQL & " AND ano_letivo = " & strAnoLetivo
				SQL = SQL & " AND semestre in (" & strSemestre & ")"
				SQL = SQL & " AND cod_periodo = " & intCodPeriodo
				rs.open sql, cnn
				if not rs.eof then
					codHistoricoEscolarAnterior = rs("codigo")
				end if
				rs.close

				if codHistoricoEscolarAnterior <> "" then
		
					sql = "SELECT cod_historico_escolar"
					sql = sql & " FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA"
					SQL = SQL & " WHERE cod_historico_escolar = " & codHistoricoEscolarAnterior
					SQL = SQL & " AND cod_periodo = " & intCodPeriodo
					SQL = SQL & " AND situacao = 'AC' "
					SQL = SQL & " AND situacao = 'AP' "
					SQL = SQL & " AND situacao = 'RP' "
					rs.open sql, cnn, 3, 3
					if not rs.eof then
					   ZerarPeriodoHistorico = "N"
					else
					   ZerarPeriodoHistorico = "S"
					end if      
				    rs.close
					
					'LIMPA HISTORICO
					if ZerarPeriodoHistorico = "S" then
						sql = "DELETE"
						sql = sql & " FROM SCA_HISTORICO_ESCOLAR"
						SQL = SQL & " WHERE cod_aluno = " & intCodAluno
						SQL = SQL & " AND cod_empresa = " & intCodEmp
						SQL = SQL & " AND ano_letivo = " & strAnoLetivo
						SQL = SQL & " AND semestre in (" & strSemestre & ")"
						SQL = SQL & " AND cod_periodo = " & intCodPeriodo
						SQL = SQL & " AND codigo = " & codHistoricoEscolarAnterior
						cnn.execute SQL
						GravarLog sql	
					
						'LIMPA HISTORICO DISCIPLINA
						sql = "DELETE"
						sql = sql & " FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA"
						SQL = SQL & " WHERE cod_historico_escolar = " & codHistoricoEscolarAnterior
						SQL = SQL & " AND cod_periodo = " & intCodPeriodo
						cnn.execute SQL
						GravarLog sql
					end if	
						
				end if

				SQL = "SET NoCount ON "
				SQL = SQL & "INSERT INTO SCA_HISTORICO_ESCOLAR (cod_aluno, cod_empresa, ano_letivo, semestre, escola, cidade, uf, "
				SQL = SQL & "curso, serie, cod_curso, cod_periodo, observacao) VALUES ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodEmp & ","
				SQL = SQL & "" & strAnoLetivo & ","
				SQL = SQL & "" & strSemestre & ","
				SQL = SQL & "'" & strEscola & "',"
				if strCidade = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & strCidade & "',"
				end if
				if strUf= "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "" & strUf & ","
				end if
				if strCurso = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & strCurso & "',"
				end if
				if strSerie = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & strSerie & "',"
				end if
				if intCodCurso = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "" & intCodCurso & ","
				end if
				if intCodPeriodo = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & intCodPeriodo & "',"
				end if
				SQL = SQL & " null) ;SELECT @@IDENTITY " 'Observação
				Set rs = cnn.Execute(sql)
				codHistoricoEscolar = rs(0)
				rs.close

				'busca no cadastro de notas e insere no historico	
				sql = "SET NoCount ON "
				sql = sql & "INSERT SCA_HISTORICO_ESCOLAR_DISCIPLINA SELECT "
				sql = sql & codHistoricoEscolar & ","
				sql = sql & " n.ano_letivo,"
				sql = sql & intCodCurso & ","
				sql = sql & " n.cod_periodo,"
				sql = sql & " n.semestre,"
				sql = sql & " n.cod_disciplina,"
				sql = sql & " ad.cod_turma_remanejamento,"
				sql = sql & " ad.cod_gradecurriculardisciplina,"
				sql = sql & " n.nota01,"
				sql = sql & " n.falta01,"
				sql = sql & " n.nota02,"
				sql = sql & " n.falta02,"
				sql = sql & " n.nota03,"
				sql = sql & " n.falta03,"
				sql = sql & " n.nota04,"
				sql = sql & " n.falta04,"
				sql = sql & " n.nota05,"
				sql = sql & " n.falta05,"
				sql = sql & " n.nota06,"
				sql = sql & " n.falta06,"
				sql = sql & " n.nota07,"
				sql = sql & " n.falta07,"
				sql = sql & " n.nota08,"
				sql = sql & " n.falta08,"
				sql = sql & " n.nota09,"
				sql = sql & " n.falta09,"
				sql = sql & " n.nota10,"
				sql = sql & " n.falta10,"
				sql = sql & " n.nota11,"
				sql = sql & " n.falta11,"
				sql = sql & " n.nota12,"
				sql = sql & " n.falta12,"
				sql = sql & " n.nota13,"
				sql = sql & " n.falta13,"
				sql = sql & " n.nota14,"
				sql = sql & " n.falta14,"
				sql = sql & " n.nota15,"
				sql = sql & " n.falta15,"
				sql = sql & " round(n.media,1) as media,"
				sql = sql & " isnull(gd.Ch_Anual,0) as CH,"
				IF strTipoAtualizacao = "A" THEN 
					sql = sql & "'CR' as situacao,"
				ELSE
					if strDesvincularCriterioAvaliacao = "S" then
						sql = sql & "'AP' as situacao,"
					else
						sql = sql & "n.situacao,"
					end if	
				END IF
				SQL = SQL & " null,"
				sql = sql & "'S' as MostraNota"
				sql = sql & " from	sca_notas_faltas n"
				sql = sql & " inner	join sca_aluno_disciplina ad on ad.cod_aluno = n.cod_aluno and ad.cod_empresa = n.cod_empresa and ad.codigo = n.cod_aluno_disciplina"
				sql = sql & " inner	join SCA_GRADECURRICULARDISCIPLINA gd on gd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA and ad.cod_empresa = n.cod_empresa "
				sql = sql & " where	ad.cod_aluno = " & intCodAluno
				sql = sql & " and	ad.cod_empresa = " & intCodEmp	
				SQL = SQL & " and   n.cod_periodo = " & intCodPeriodo
				sql = sql & "; SELECT @@ROWCOUNT"
				Set rs = cnn.Execute(sql)
				intRegistrosAfetados = rs(0)
		        rs.close		
				if isnull(intRegistrosAfetados) then intRegistrosAfetados = 0

				'rsAux1.movenext
		    next
		else	
    	   'rsAux1.close
		   cnn.rollbackTrans
		   %>
			<script>
				alert("ATENÇÃO! Não existe registro de Notas e Faltas para Atualização para a matricula n. <%=strMatricula%>. Verifique!");
				window.location='AtualizaHistorico_cad.asp';
			</script>
			<%
            response.end
		end if
		
		if intRegistrosAfetados > 0 then
						
			'REMOVE OS LANCAMENTO DO CADASTRO DE NOTAS
			if strTipoAtualizacao = "F" then

				' APAGANDO OS LANÇAMENTOS DIÁRIOS DE FALTAS
				'sql = "DELETE " 
				'sql = sql & " FROM 	SCA_FALTAS_DIARIA "
				'sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
				'sql = sql & " AND 	COD_ALUNO = " & intCodAluno
				'cnn.execute sql
				'GravarLog sql	

				' APAGANDO OS LANÇAMENTOS DE NOTAS 
				sql = " DELETE " 
				sql = sql & " FROM 	SCA_NOTAS_FALTAS "
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				cnn.execute sql
				GravarLog sql	

				' APAGANDO OS LANÇAMENTOS DE NOTAS - Verificando resíduo
				sql = " DELETE FROM SCA_NOTAS_FALTAS "
				sql = sql & " WHERE cod_aluno_disciplina IN(SELECT CODIGO FROM sca_aluno_disciplina WHERE COD_ALUNO = " & intCodAluno & ")"
				cnn.execute sql
				GravarLog sql	

				' APAGANDO A GADE DO ALUNO
				sql = " DELETE " 
				sql = sql & " FROM 	sca_aluno_disciplina "
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				cnn.execute sql
				GravarLog sql
				
			end if
			
			strAtualizacao = "Atualização Curricular"
			
			if trim(strTipoAtualizacao) = "F" then
				strAtualizacao = "Fechamento Semestral"

                strTrocaSituacao = false
				sql = " SELECT "
				sql = sql & " A.CODIGO, "
				sql = sql & " A.NOMEALUNO, "
				sql = sql & " A.MATRICULA, "
				sql = sql & " SA.DESC_SITUACAOALUNO "
				sql = sql & " FROM SCA_ALUNO A "
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
				sql = sql & " WHERE A.COD_EMPRESA = " & intCodEmp
				sql = sql & " AND A.CODIGO = " & intCodAluno
				sql = sql & " AND SA.Desc_SituacaoAluno = 'ATIVO' "
				rs1.open sql, cnn,3,3
				if rs1.eof = false then
				  	strTrocaSituacao = true
				end if
				rs1.close	

				' atualiza situação aluno
				sql = " update SCA_ALUNO set "
				if strTrocaSituacao = true then
				   sql = sql & "COD_SITUACAOALUNO = " & strSituacaoAluno & ","
				end if   
				strDatafastamento 	= FORMATADATABD(DATE)
				if trim(strDatafastamento) <> "" then
					sql = sql & "DATAFASTAMENTO = '" & strDatafastamento & "'"
				else
					sql = sql & "DATAFASTAMENTO = null"
				end if
				sql = sql & " Where codigo = " & intCodAluno
				sql = sql & " and	cod_empresa = " & intCodEmp
				cnn.execute sql
				GravarLog sql		
			
				'GRAVA NO CONTROLE SITUACAO ALUNO
				sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & intCodEmp & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "" & strSituacaoAluno & "," 
				sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
				cnn.execute sql
				GravarLog sql	
				
				
				'--------------------------------------------------------------------------------------------------------
				if strTrocaSituacao = true then    '' Atualizar vagas matrícula informatizada
					
					'atualiza vagas
					sql = "update SCA_TURMA "
					sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-1 "
					sql = sql & " where COD_EMPRESA = " & intCodEmp
					sql = sql & " and 	Cod_Turma = " & strCodTurma
					cnn.execute sql
					GravarLog sql	
					
					' Só para Aparecida
					if Session("CodGrupo") = 7 then 
					
						sql = "Delete from MAT_inscricao"
						sql = sql & " Where cod_aluno = " & intCodAluno
						cnn.execute sql
						GravarLog sql
					
					end if
		
				end if
			end if
			
			
			
			'Gera Ocorrencia Automatica de troca de situação
			'parametros:
			'	intCodEmp
			'	intCodDepartamento
			'	intCodAluno
			'	intCodTaxa
			'	intCodBebitoAluno
			'	strDataOcorrencia
			'	strDataValidade
			'	strOcorrencia
			'	strUsuarioIncl
		
			intCodEmp			= intCodEmp
			intCodDepartamento	= Session("CodDeptoUsuario")
			intCodAluno			= intCodAluno
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			strOcorrencia		= "Atualização do Histórico Escolar do tipo: " & strAtualizacao & "."
			%>
			<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%
			intRegistrosAtualizados = intRegistrosAtualizados + 1
		else
			intRegistrosNaoAtualizados = intRegistrosNaoAtualizados + 1
		end if

		if trim(strTipoAtualizacao) = "F" then
		    strAtualizado=false
		    sql = "select COD_TURMA from SCA_CONTROLE_FECHAMENTO"
			sql = sql & " Where COD_ALUNO = " & intCodAluno
			sql = sql & " And Cod_Turma = " & strCodTurma
			rs1.open sql, cnn,3,3
			if rs1.eof = false then
				  strAtualizado = true
			end if
			rs1.close	

		    if strAtualizado = false then
				sql = "insert into SCA_CONTROLE_FECHAMENTO (COD_TURMA, COD_ALUNO) VALUES ("
				sql = sql & "" & strCodTurma & "," 
				sql = sql & "" & intCodAluno & ")" 
				cnn.execute sql
				GravarLog sql
			end if			
         end if		
	next
    
	strMsnTpA = ""
	if trim(strTipoAtualizacao) = "F" then
		strMsnTpA = "de Fechamento"
	elseif trim(strTipoAtualizacao) = "A" then
		strMsnTpA = "Curriculares"
	end if
	
	strMensagem = "Resumo de Atualizações " & strMsnTpA & ":\n\n - Histórico atualizado com sucesso: " & intRegistrosAtualizados
	if intRegistrosNaoAtualizados >0 then
		strMensagem = strMensagem & "\n - Histórico não atualizado: " & intRegistrosNaoAtualizados
	end if
				
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans

		if trim(strTipoAtualizacao) = "F" then
	
			'APAGANDO OS MATERIAIS DE AULAS POSTADOS NA TURMA	
			sql = " SELECT Codigo, NomeArquivo"
			sql = sql & " FROM SCA_MaterialAluno"
			sql = sql & " where cod_empresa = " & intCodEmp	
			sql = sql & " And CodTurma = " & strCodTurma
			rs.open sql, cnn
			if rs.eof = false then
			
				while not rs.eof
				
					strNomeArquivo	= rs("NomeArquivo")
					intCodigo		= rs("Codigo")
						
					'Exclui PDF
					PastaImagemComum = Server.MapPath("../../MaterialAluno") & "/" & intCodEmp & "\" & strNomeArquivo
					
					Set objFSO = CreateObject("Scripting.FileSystemObject")
					
					' Apaga o Arquivo do servidor
					IF objFSO.FileExists(PastaImagemComum) = True THEN objFSO.DeleteFile PastaImagemComum, True
					
					sql = "Delete from SCA_MaterialAluno "
					sql = sql & " where cod_empresa = " & intCodEmp
					sql = sql & " And Codigo = " & intCodigo
					cnn.execute sql
	
					rs.movenext
				wend
				
			end if
			rs.close
		end if			
 		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='atualizaHistorico_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>