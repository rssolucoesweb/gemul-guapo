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
'
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strSemestre 			= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strSituacaoAluno	= Trim(Request.Form("cmbSituacaoAluno"))
	intCodAluno			= Trim(Request.Form("chkAluno"))
	strDatafastamento	= formatadataBD(Trim(Request("txtDatafastamento")))
	strDataMatricula	= formatadataBD(Trim(Request("txtDatamatricula")))


	if intCodAluno = "" then
		%>
		<script>
			alert("ATENÇÃO: \n\nDeve ser selecionado os alunos para troca de situação.");
			window.history.back();
		</script>
		<%	
		response.End()
	end if	

	if Session("NivelPermissao") <> "A" then
		if Session("strChecarFinanceiro") = "S" then
			sql = "select Desc_SituacaoAluno "
			sql = sql & " from SCA_SITUACAOALUNO"
			sql = sql & " where cod_empresa = "&intCodEmp
			sql = sql & " and cod_situacaoAluno = "&strSituacaoAluno
			rs.open sql, cnn
			if not rs.eof then
				if trim(ucase(rs("Desc_SituacaoAluno"))) = "ATIVO" then
					rs.close
					%>
					<script>
						alert("ATENÇÃO: \n\nO Aluno não pode ser ATIVADO por esse cadastro, somente será ativado pelo financeiro.");
						window.history.back();
					</script>
					<%	
					response.End()
				end if
			end if
			rs.close
		end if
	end if
	'REGRA PARA SITUACAO ATUAL DO ALUNO
	sql = "select REPLACE(REPLACE(Desc_SituacaoAluno,'É','E'),'Í','I') AS Desc_SituacaoAluno "
	sql = sql & " FROM SCA_SITUACAOALUNO"
	sql = sql & " where Cod_SituacaoAluno = " & strSituacaoAluno
	sql = sql & " AND COD_EMPRESA = " & intCodEmp
	rs.open sql, cnn
	if not RS.EOF then
		strDescSituacao = trim(ucase(rs("Desc_SituacaoAluno")))
	end if
	rs.close
	if isnull(strDescSituacao) then strDescSituacao = ""
	'if trim(ucase(strDescSituacao)) = "PRE-MATRICULA" then
		%>
		<!--script>
			alert("ATENÇÃO: Esse aluno não poderá trocar a situação para PRÉ-MATRÍCULA.\nAlteração para PRÉ-MATRÍCULA só é permitida na renovação/matrícula.");
			window.history.back();
		</script -->
		<%
	'	response.End()
	'end if		
	

	IF TRIM(strDescSituacao) = "ATIVO" AND strDataMatricula = "" THEN 
		%>
		<script>
			alert("A data da matrícula não será alterada.");
		</script>
		<%
	END IF
	
	cnn.begintrans
	
	vetAluno = split(intCodAluno,",")
	for i=0 to ubound(vetAluno)
		intCodAluno			= vetAluno(i)

		'busca turma do aluno
		sql = "select top 1 AT.COD_TURMA, T.Cod_GradeCurricular"
		sql = sql & " from SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo"
		sql = sql & " where AT.COD_EMPRESA = " &  intCodEmp
		sql = sql & " and AT.COD_ALUNO = " &  intCodAluno
		sql = sql & " and AT.ANO_LETIVO = " &  strAnoLetivo
		'sql = sql & " and AT.SEMESTRE IN (" &  strSemestre & ")"
		sql = sql & " order by codigo desc "
		rs.open sql, cnn
		if not rs.eof then
			strCodTurma = rs("cod_Turma")
		end if
		rs.close
	
		if 	strCodTurma = "" then strCodTurma = "0"
		' Consulto o Nome da Turma
		if strCodTurma <> "0" then
			
			sql = "select COD_SEMESTRE from SCA_TURMA"
			sql = sql & " Where Cod_Empresa = " & intCodEmp
			sql = sql & " And Cod_Turma = " & strCodTurma
			rs.open sql, cnn
			if rs.eof = false then
				strSemestre = RS("COD_SEMESTRE")
			end if
			rs.close
			
			' atualiza semestre na aluno turma
			sql = " update SCA_ALUNO_TURMA set SEMESTRE = " & strSemestre
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			sql = sql & " and 	Cod_Aluno = " & intCodAluno
			cnn.execute sql
			GravarLog sql	
				
		else
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: O Aluno ainda não alocado para o período letivo, verifique!");
				window.history.back();
			</script>
			<%
			response.end
		end if

		if trim(strDescSituacao) <> "ATIVO" then    '' Atualizar vagas matrícula informatizada
			sql = "SELECT S.Desc_SituacaoAluno "
			sql = sql & " FROM SCA_ALUNO A"
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
			sql = sql & " Where A.COD_EMPRESA = " & intCodEmp
			sql = sql & " And 	A.codigo = " & intCodAluno
			rsAux.open sql, cnn
			if rsAux.eof = false then
				strAntigaDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
			end if
			rsAux.close	
			
			if trim(strDescSituacao) <> trim(strAntigaDescSituacaoAluno) then
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
					sql = sql & " Where Cod_Empresa = " & intCodEmp
					sql = sql & " And cod_aluno = " & intCodAluno
					cnn.execute sql
					GravarLog sql
				
				end if

			end if
		end if	

		if trim(strDescSituacao) = "ATIVO" then    '' Atualizar vagas matrícula informatizada
			sql = "SELECT S.Desc_SituacaoAluno "
			sql = sql & " FROM SCA_ALUNO A"
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
			sql = sql & " Where A.COD_EMPRESA = " & intCodEmp
			sql = sql & " And 	A.codigo = " & intCodAluno
			rsAux.open sql, cnn
			if rsAux.eof = false then
				strAntigaDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
			end if
			rsAux.close	
			
			if trim(strDescSituacao) <> trim(strAntigaDescSituacaoAluno) then
				'atualiza vagas
				sql = "update SCA_TURMA "
				sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1 "
				sql = sql & " where COD_EMPRESA = " & intCodEmp
				sql = sql & " and 	Cod_Turma = " & strCodTurma
				cnn.execute sql
				GravarLog sql
				
				' So vai entrar se for abadia grupo 7
				if Session("CodGrupo") = 7 then 
				
					sql = "Delete from MAT_inscricao"
					sql = sql & " Where Cod_Empresa = " & intCodEmp
					sql = sql & " And cod_aluno = " & intCodAluno
					cnn.execute sql
					GravarLog sql
				
				end if
	
			end if
		end if	

	
		' atualiza situação aluno
		sql = " update SCA_ALUNO set COD_SITUACAOALUNO = " & strSituacaoAluno
		IF TRIM(strDescSituacao) <> "ATIVO" AND strDatafastamento = "" THEN 
			strDatafastamento 	= FORMATADATABD(DATE)
			strDataMatricula 	= ""
		END IF
	
		IF TRIM(strDescSituacao) = "ATIVO" THEN 
			strDatafastamento 	= ""
		END IF
	
		if trim(strDatafastamento) <> "" then
			sql = sql & ",DATAFASTAMENTO = '" & strDatafastamento & "'"
		else
			sql = sql & ",DATAFASTAMENTO = null"
		end if
	
		if trim(strDataMatricula) <> "" then
			sql = sql & ",DATAMATRICULA = '" & strDataMatricula & "'"
		end if
		sql = sql & " Where codigo = " & intCodAluno
		sql = sql & " and	cod_empresa = " & intCodEmp
		cnn.execute sql
		GravarLog sql	
	
		'Verifico se existe histórico de situações para o aluno
		sql = "SELECT COD_ALUNO FROM SCA_SITUACAO_ACADEMICA_ALUNO"
		sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
		sql = sql & " AND COD_ALUNO = " & intCodAluno
		sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
		sql = sql & " AND SEMESTRE = " & strSemestre
		rs.open sql, cnn
		if rs.eof = false then
		   existeSituacao = "OK"
		else
		   existeSituacao = "NO"
		end if
		rs.close	
	
		if existeSituacao = "OK" then
			'ATUALIZO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
			sql = "UPDATE SCA_SITUACAO_ACADEMICA_ALUNO "
			sql = sql & " SET COD_SITUACAOALUNO = " & strSituacaoAluno & ", DATA_SITUACAO = '" & FORMATADATABD(DATE) & "'"
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	COD_ALUNO = " & intCodAluno
			sql = sql & " and 	ANO_LETIVO = " & strAnoLetivo
			sql = sql & " and 	SEMESTRE = " & strSemestre
			cnn.execute sql
			GravarLog sql
		else   
			'INSERINDO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
			sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & strSituacaoAluno & "," 
			sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			GravarLog sql
		end if	
		
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
	
		'Gera Ocorrencia Automatica do tipo Protesto
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
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
		strOcorrencia		= "Alteração da situação do aluno"
		%>
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%	
	next
	
	strMensagem = "Situação do Aluno foi Atualizado com sucesso..."
			
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ControleSituacaoAluno_cad.asp';
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