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

	intCodEmpresa 		= Session("CodEmpresa")
	intCodEmp			= intCodEmpresa
	strCodigo							= Trim(Request("txtCodigo"))
	strCodigoGradeCurricularDisciplina	= Trim(Request("txtCodigoGradeCurricularDisciplina"))
	strCodDisciplinaOutrasAnterior	= Trim(Request("txtCodDisciplinaOutrasAnterior"))
	intCodFicha	= Trim(Request("txtCodigoFicha"))
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	
	strEscola 			= Trim(Request.Form("txtEscola"))
	strCidade 			= Trim(Request.Form("txtCidade"))
	strUfResidencia		= Trim(Request.Form("cmbUFResidencia"))
	
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	
	strAnoHistorico		= strAnoLetivo
	strSemestreHistorico= intSemestre
	
    intCodDisciplina        = request("cmbDisciplina")
	intCodDisciplinaOutras	= Trim(Request.Form("cmbDisciplinaOutras"))
	strDisciplinaNova		= Trim(Request.Form("txtDisciplinaNova"))
    strCH			        = request("txtCH")
	strNota					= replace(replace(Trim(Request.Form("txtNota")),".",""),",",".")
	strConceito				= Trim(Request.Form("txtConceito"))
	strSituacaoPromocao		= Trim(Request.Form("cmbSituacaoPromocao"))

	intCodAluno			= Trim(Request.Form("txtCodAluno"))
	strMatricula		= Trim(Request.Form("txtMatricula"))

	'DADOS DO HISTORICO 
	strEscola			= Trim(Request.Form("txtEscola"))
	strCidade			= Trim(Request.Form("txtCidade"))
	strUfResidencia		= Trim(Request.Form("cmbUFResidencia"))
	acao				= "I"
	
	sql = "select top 1 p.Cod_Curso, A.MATRICULA, A.CODIGO, A.NOMEALUNO, G.AnoReferencia, G.SemestreReferencia"
	sql = sql & " from SCA_ALUNO_TURMA AT"
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AT.COD_ALUNO"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular AND G.COD_EMPRESA = T.COD_EMPRESA"
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_periodo = G.Cod_periodo AND G.COD_EMPRESA = T.COD_EMPRESA"
	sql = sql & " Where AT.COD_EMPRESA = " & Session("CodEmpresa")	
	sql = sql & " and A.codigo = " & strCodAluno
	sql = sql & " and G.Situacao = 'A'"
	sql = sql & " order by AT.CODIGO desc"
	rs.open sql, cnn
	if rs.eof = false then
		strMatricula 			= TRIM(rs("Matricula"))
		strNomealuno 			= TRIM(rs("Nomealuno"))
		strCodAluno	 			= TRIM(rs("Codigo"))
		intCodCurso	 			= TRIM(rs("cod_curso"))
		strAnoLetivoGrade 		= Trim(rs("AnoReferencia"))
		intSemestreGrade 		= Trim(rs("SemestreReferencia"))
		strDesabilitaImprimir 	= ""
		strMostraBotaoAtualizarHistorico = "S"
	end if
	rs.close

	sql = "SELECT SCA_GRADECURRICULAR.Cod_GRADECURRICULAR, SCA_GRADECURRICULAR.AnoReferencia, SCA_GRADECURRICULAR.SemestreReferencia, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.COD_FICHA_EQUIVALENCIA, "
	sql = sql & " SCA_GRADECURRICULAR.Cod_AGRUPAMENTO, SCA_CURSO.COD_CURSO, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Cod_GradeCurricularDisciplina,"
	sql = sql & " SCA_CURSO.DESCRICAO, SCA_PERIODO.cod_periodo, SCA_PERIODO.Descricao as PERIODO, SCA_FICHA_EQUIVALENCIA.Escola ,SCA_FICHA_EQUIVALENCIA.Cidade ,SCA_FICHA_EQUIVALENCIA.UF ,"
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.DESC_Disciplina, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.nota,SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Cod_SituacaoPromocao, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.ch,"
	sql = sql & " SCA_GRAU.DESC_GRAU, SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina,"
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Anual, SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR_EQUIVALENTE, SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULARDISCIPLINA_EQUIVALENTE, SCA_GRADECURRICULARDISCIPLINA.COD_DISCIPLINA_EQUIVALENTE,"
	sql = sql & " SCA_FICHA_EQUIVALENCIA_DISCIPLINA.ano_letivo, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.semestre,SCA_FICHA_EQUIVALENCIA_DISCIPLINA.ch as Ch_Anual_origem, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Nota, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Conceito, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.codigo as codEquivDisc, "
	sql = sql & " SCA_FICHA_EQUIVALENCIA_DISCIPLINA.cod_situacaopromocao as situacao, SCA_DisciplinaOutrasInstituicoes.Desc_Disciplina AS Desc_Disciplina_origem, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.cod_ficha_equivalencia  as codFicha, SCA_FICHA_EQUIVALENCIA.Cod_Aluno"
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa INNER JOIN SCA_GRAU ON SCA_GRAU.Cod_Grau = SCA_CURSO.Cod_Grau and SCA_GRAU.cod_empresa = SCA_CURSO.cod_empresa INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	sql = sql & " INNER JOIN SCA_FICHA_EQUIVALENCIA_DISCIPLINA ON SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Cod_GradeCurricularDisciplina = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
	sql = sql & " INNER JOIN SCA_FICHA_EQUIVALENCIA ON SCA_FICHA_EQUIVALENCIA.CODIGO = SCA_FICHA_EQUIVALENCIA_DISCIPLINA.cod_ficha_equivalencia"
	sql = sql & " INNER JOIN SCA_DisciplinaOutrasInstituicoes ON SCA_DisciplinaOutrasInstituicoes.cod_Disciplina = SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Cod_DisciplinaOutrasInstituicoes"
	sql = sql & " WHERE		SCA_CURSO.Cod_Curso = " & intCodCurso
	sql = sql & " AND		SCA_GRADECURRICULAR.situacao = 'A'"
	sql = sql & " AND 		(SCA_FICHA_EQUIVALENCIA.Cod_Aluno IS NULL OR SCA_FICHA_EQUIVALENCIA.Cod_Aluno = "&strCodAluno&")  "
	sql = sql & " ORDER BY SCA_PERIODO.SEQUENCIA, SCA_DISCIPLINA.DESC_Disciplina "
	rs.open sql, cnn, 3, 3
	if rs.eof = false then
		while not rs.eof
			intCodFicha	= rs("COD_FICHA_EQUIVALENCIA")
			strAnoHistorico = rs("ano_letivo")
			strSemestreHistorico = rs("semestre")
			strEscola=rs("escola")
			strCidade=rs("cidade")
			strUfResidencia=rs("uf")
			strNota=rs("nota")
			strCH=rs("CH")
			strSituacaoPromocao=rs("Cod_SituacaoPromocao")
			
			strCodigoGradeCurricularDisciplina = rs("Cod_GradeCurricularDisciplina")
			if ucase(trim(acao)) = "I" then
				acao = "A"
				
				codHistoricoEscolar = 0
				SQL = "select  ISNULL(Cod_historicoEscolar,0) AS Cod_historicoEscolar "
				SQL = SQL & " from SCA_FICHA_EQUIVALENCIA"
				sql = sql & " where codigo = " & intCodFicha
				SQL = SQL & " and cod_empresa = " & intCodEmpresa
				rsAux.open sql, cnn, 3, 3
				if NOT rsAux.eof then	
					codHistoricoEscolar = rsAux("Cod_historicoEscolar")
				end if   		
				rsAux.close
		
				'busca o nome da serie
				SQL = "	select p.cod_periodo, p.Descricao as periodo, c.cod_curso, c.Descricao as curso, gd.cod_disciplina"
				SQL = SQL & " from SCA_GRADECURRICULARDISCIPLINA gd"
				SQL = SQL & " inner join SCA_GRADECURRICULAR g on g.cod_gradeCurricular = gd.cod_gradeCurricular"
				SQL = SQL & " inner join SCA_PERIODO p on p.cod_periodo = g.cod_periodo and p.cod_empresa = g.cod_empresa"
				SQL = SQL & " inner join SCA_CURSO c on c.cod_curso = p.cod_curso and c.cod_empresa = g.cod_empresa"
				SQL = SQL & " where gd.cod_gradeCurricularDisciplina = " & strCodigoGradeCurricularDisciplina
				rsAux.open sql, cnn, 3, 3
				if NOT rsAux.eof then	
					strCurso=rsaux("curso")
					strSerie=rsaux("periodo")
					intCodCurso=rsaux("cod_curso")
					intCodPeriodo=rsaux("cod_periodo")
					intCodDisciplinaGrade=rsaux("cod_disciplina")
				end if   		
				rsAux.close
		
				if codHistoricoEscolar = 0 then
					SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR (cod_aluno, cod_empresa, ano_letivo, semestre, escola, cidade, uf, "
					SQL = SQL & "curso, serie, cod_curso, cod_periodo, observacao ) VALUES ("
					SQL = SQL & "" & intCodAluno & ","
					SQL = SQL & "" & intCodEmp & ","
					SQL = SQL & "" & strAnoHistorico & ","
					SQL = SQL & "" & strSemestreHistorico & ","
					SQL = SQL & "'" & strEscola & "',"
					if strCidade = "" then
						SQL = SQL & "null,"
					else
						SQL = SQL & "'" & strCidade & "',"
					end if
					if strUfResidencia = "" then
						SQL = SQL & "null,"
					else
						SQL = SQL & "" & strUfResidencia & ","
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
						SQL = SQL & "'" & intCodCurso & "',"
					end if
					if intCodPeriodo = "" then
						SQL = SQL & "null,"
					else
						SQL = SQL & "'" & intCodPeriodo & "',"
					end if
					if strObservacao = "" then
						SQL = SQL & "null)"
					else
						SQL = SQL & "'" & strObservacao & "')"
					end if
					cnn.execute SQL
					GravarLog sql	
					
					sql="SELECT MAX(CODIGO) AS codhist"
					sql=sql & " FROM SCA_HISTORICO_ESCOLAR"
					SQL = SQL & " WHERE cod_aluno = " & intCodAluno
					SQL = SQL & " AND cod_empresa = " & intCodEmp
					SQL = SQL & " AND ano_letivo = " & strAnoHistorico
					SQL = SQL & " AND semestre = " & strSemestreHistorico
					SQL = SQL & " AND serie = '" & strSerie & "'"
					rsAux.open sql, cnn, 3, 3
					codHistoricoEscolar = rsAux("codhist")
					rsAux.close
				
					SQL = "update SCA_FICHA_EQUIVALENCIA set "
					SQL = SQL & " cod_historicoEscolar = " & codHistoricoEscolar
					sql = sql & " where codigo = " & intCodFicha
					cnn.Execute(sql)
				end if
				
				if intCodDisciplinaGrade <> "0" then
					'inserindo HISTORICO DISCIPLINA
					IF intCodPeriodo <> "" THEN
						SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_DISCIPLINA (cod_historico_escolar, ano_letivo, cod_periodo, "
						SQL = SQL & " cod_curso, cod_turma, semestre, cod_disciplina, cod_gradecurriculardisciplina,"
						SQL = SQL & " media, carga_horaria, situacao) "
						SQL = SQL & "VALUES ("
		
						SQL = SQL & "" & codHistoricoEscolar & ","
						SQL = SQL & "" & strAnoHistorico & ","
						SQL = SQL & "" & intCodPeriodo & ","
						SQL = SQL & "" & intCodCurso & ","
						if intCodTurmaHistorico = "0" OR intCodTurmaHistorico = ""  then
							SQL = SQL & "null,"
						else
							SQL = SQL & "" & intCodTurmaHistorico & ","
						end if
						SQL = SQL & "" & strSemestreHistorico & ","
						SQL = SQL & "" & intCodDisciplinaGrade & ","
						SQL = SQL & "" & strCodigoGradeCurricularDisciplina & ","
						if strNota = "" then
							SQL = SQL & "null,"
						else
							SQL = SQL & "" & strNota & ","
						end if
						if strCH = "" then
							SQL = SQL & "null,"
						else
							SQL = SQL & "" & strCH & ","
						end if
						SQL = SQL & "'" & strSituacaoPromocao & "')"
						cnn.execute SQL
						GravarLog sql	
					END IF		
				end if			
		
				strMensagem = "Historico atualizado com sucesso..."
			elseif ucase(trim(acao)) = "A" then
				
				SQL = "	select codigo"
				SQL = SQL & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA"
				SQL = SQL & " where cod_historico_escolar = " & codHistoricoEscolar
				SQL = SQL & " and cod_disciplina = " & intCodDisciplinaGrade
				SQL = SQL & " and cod_periodo = " & intCodPeriodo
				SQL = SQL & " and ano_letivo = '" & strAnoHistorico & "'"
				SQL = SQL & " and semestre = '" & strSemestreHistorico & "'"
				rsAux.open sql, cnn, 3, 3
				if NOT rsAux.eof then	
					codHistoricoEscolarDisciplina=rsaux("codigo")
				end if   		
				rsAux.close
				
				'VERFICAR SE E ALTERACAO OU INCLUSAO'
				if codHistoricoEscolarDisciplina = "" then
					if intCodDisciplinaGrade <> "0" then
			
						'inserindo HISTORICO DISCIPLINA
						SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_DISCIPLINA (cod_historico_escolar, ano_letivo, cod_periodo, cod_curso, cod_turma, semestre, cod_disciplina, "
						SQL = SQL & "media, carga_horaria, situacao, mostraNota) VALUES ("
						SQL = SQL & "" & codHistoricoEscolar & ","
						SQL = SQL & "" & strAnoHistorico & ","
						SQL = SQL & "" & intCodPeriodo & ","
						SQL = SQL & "" & intCodCurso & ","
						if intCodTurmaHistorico = "0" OR intCodTurmaHistorico = ""  then
							SQL = SQL & "null,"
						else
							SQL = SQL & "" & intCodTurmaHistorico & ","
						end if
						SQL = SQL & "" & strSemestreHistorico & ","
						SQL = SQL & "" & intCodDisciplinaGrade & ","
						if strNota = "" then
							SQL = SQL & " null,"
						else
							SQL = SQL & "" & strNota & ","
						end if
						if strCH = "" then
							SQL = SQL & " null,"
						else
							SQL = SQL & "" & strCH & ","
						end if
						if strSituacaoPromocao = "0" then strSituacaoPromocao = ""
						SQL = SQL & "'" & strSituacaoPromocao & "','" & strMostraNota & "')"
						cnn.execute SQL
						GravarLog sql			
					end if
				else
			
					if intCodDisciplinaGrade <> "0" then
			
						'inserindo HISTORICO DISCIPLINA
						SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET"
						SQL = SQL & " ano_letivo=" & strAnoHistorico & ","
						SQL = SQL & " cod_periodo=" & intCodPeriodo & ","
						SQL = SQL & " cod_curso=" & intCodCurso & ","
						if intCodTurmaHistorico = "0" OR intCodTurmaHistorico = ""  then
							SQL = SQL & " cod_turma=null,"
						else
							SQL = SQL & " cod_turma=" & intCodTurmaHistorico & ","
						end if
						SQL = SQL & " cod_disciplina=" & intCodDisciplinaGrade & ","
						if strNota = "" then
							SQL = SQL & " media=null,"
						else
							SQL = SQL & " media=" & strNota & ","
						end if
						if strCH = "" then
							SQL = SQL & " carga_horaria=null,"
						else
							SQL = SQL & " carga_horaria=" & strCH & ","
						end if
						SQL = SQL & " situacao = '" & strSituacaoPromocao & "',"
						SQL = SQL & " mostraNota='" & strMostraNota & "'"
						SQL = SQL & " where codigo = " & codHistoricoEscolarDisciplina
						cnn.execute SQL
						GravarLog sql					
					end if		
				end if	
				
			end if
			rs.movenext
		wend
		rs.close
	end if
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ParecerCurricular_cad.asp?txtCodAluno=<%=intCodAluno%>';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>