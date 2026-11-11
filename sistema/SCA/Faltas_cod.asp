<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas e media
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	strPaginaRetorno	= Trim(Request.Form("txtPaginaRetorno"))
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))
	strData		 		= formatadataBD(Trim(Request("txtData")))

	intSemestre 		= Trim(Request.Form("txtSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	
	strGravarOnde = "NOTA"
	msnHistorico  = ""
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
			strGravarOnde = "HISTORICO"
		    strMensagem = "Registro salvo com sucesso no Histórico..."
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
			strGravarOnde = "HISTORICO"
			strMensagem = "Registro salvo com sucesso no Histórico..."
	   end if	   
	end if

	if strPaginaRetorno = "FALTAS" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
	elseif strPaginaRetorno = "FALTASPROF" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaProfessorHorario"))
	end if
	
	intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodTipoNota 		= Trim(Request.Form("chkTipoNota"))
	intCodTurma 		= Trim(Request.Form("cmbTurma"))
	intCodTurno 		= Trim(Request.Form("cmbTurno"))
	strAlunos 			= Trim(Request.Form("chkAluno"))
	strPosicao			= Trim(Request.Form("txtPosicao"))

	IF TRIM(strGravarOnde) = "NOTA" THEN
	   strMensagem = "Registro salvo com sucesso..."
	'busca os dados dos lancamentos de notas
		intQtdeLancamento		= request.form("qtdeAluno")
		for i=1 to intQtdeLancamento
			strCodAluno			= request.form("txtCodAluno_"&i)
			strFalta 			= request.form("txtFalta_"&i)
			strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
			strCodNota 			= request.form("txtCodAlunoNota_"&i)
			if isnull(strCodNota) or trim(strCodNota) = "" then
				'incluir
				if trim(strFalta) <> "" then
	
					SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
					SQL = SQL & " WHERE cod_empresa="&intCodEmp
					SQL = SQL & " AND cod_aluno="&strCodAluno
					SQL = SQL & " AND cod_aluno_disciplina="&strAlunoDisciplina
					SQL = SQL & " AND cod_periodo="&intCodPeriodo
					SQL = SQL & " AND ano_letivo="&strAnoLetivo
					SQL = SQL & " AND semestre="&intSemestre
					SQL = SQL & " AND cod_disciplina="&intCodDisciplina
					SQL = SQL & " AND data='"&formatadataBD(strData) & "'"
					rs.open sql, cnn
					if rs.eof then
						bolNotasfaltas = true
						strCodNota = ""
						SQL = "SELECT cod_aluno, codigo FROM SCA_NOTAS_FALTAS "
						SQL = SQL & " WHERE cod_empresa="&intCodEmp
						SQL = SQL & " AND cod_aluno="&strCodAluno
						SQL = SQL & " AND cod_aluno_disciplina="&strAlunoDisciplina
						SQL = SQL & " AND cod_periodo="&intCodPeriodo
						SQL = SQL & " AND ano_letivo="&strAnoLetivo
						SQL = SQL & " AND semestre="&intSemestre
						SQL = SQL & " AND cod_disciplina="&intCodDisciplina
						rsAux.open sql, cnn
						if not rsAux.eof then
							bolNotasfaltas = false
							strCodNota = rsAux("codigo")
						end if
						rsAux.close

						if bolNotasfaltas then
							SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
							SQL = SQL & "ano_letivo, semestre, cod_disciplina, falta"&strPosicao&") VALUES ("
							SQL = SQL & "" & intCodEmp & ","
							SQL = SQL & "" & strCodAluno & ","
							SQL = SQL & "" & strAlunoDisciplina & ","
							SQL = SQL & "" & intCodPeriodo & ","
							SQL = SQL & "" & strAnoLetivo & ","
							SQL = SQL & "" & intSemestre & ","
							SQL = SQL & "" & intCodDisciplina & ","
							SQL = SQL & "" & strFalta & ")"
							cnn.execute SQL
							GravarLog sql
						else
							
							'alterar falta
							SQL = "UPDATE SCA_NOTAS_FALTAS SET "
							SQL = SQL & "falta"&strPosicao&"= 0"
							SQL = SQL & " where codigo = " & strCodNota
							SQL = SQL & " and falta"&strPosicao&" is null"
							cnn.execute SQL

							'alterar falta
							SQL = "UPDATE SCA_NOTAS_FALTAS SET "
							SQL = SQL & "falta"&strPosicao&"= falta"&strPosicao&"+" & strFalta & ""
							SQL = SQL & " where codigo = " & strCodNota
							cnn.execute SQL
							GravarLog sql						
						end if
												
						SQL = "INSERT INTO SCA_FALTAS_DIARIA (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
						SQL = SQL & "ano_letivo, semestre, cod_disciplina, data, falta, sequencia) VALUES ("
						SQL = SQL & "" & intCodEmp & ","
						SQL = SQL & "" & strCodAluno & ","
						SQL = SQL & "" & strAlunoDisciplina & ","
						SQL = SQL & "" & intCodPeriodo & ","
						SQL = SQL & "" & strAnoLetivo & ","
						SQL = SQL & "" & intSemestre & ","
						SQL = SQL & "" & intCodDisciplina & ","
						SQL = SQL & "" & "'"&formatadataBD(strData) & "',"
						SQL = SQL & "" & strFalta & ","
						SQL = SQL & "0)"
						cnn.execute SQL
						GravarLog sql
					end if
					RS.CLOSE

				end if
			else
				if strFalta<>"" then
					SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
					SQL = SQL & " WHERE cod_empresa="&intCodEmp
					SQL = SQL & " AND cod_aluno="&strCodAluno
					SQL = SQL & " AND cod_aluno_disciplina="&strAlunoDisciplina
					SQL = SQL & " AND cod_periodo="&intCodPeriodo
					SQL = SQL & " AND ano_letivo="&strAnoLetivo
					SQL = SQL & " AND semestre="&intSemestre
					SQL = SQL & " AND cod_disciplina="&intCodDisciplina
					SQL = SQL & " AND data='"&formatadataBD(strData) & "'"
					rs.open sql, cnn
					if rs.eof then
						
						SQL = "INSERT INTO SCA_FALTAS_DIARIA (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
						SQL = SQL & "ano_letivo, semestre, cod_disciplina, data, falta, sequencia) VALUES ("
						SQL = SQL & "" & intCodEmp & ","
						SQL = SQL & "" & strCodAluno & ","
						SQL = SQL & "" & strAlunoDisciplina & ","
						SQL = SQL & "" & intCodPeriodo & ","
						SQL = SQL & "" & strAnoLetivo & ","
						SQL = SQL & "" & intSemestre & ","
						SQL = SQL & "" & intCodDisciplina & ","
						SQL = SQL & "'"&formatadataBD(strData) & "',"
						SQL = SQL & "" & strFalta & ","
						SQL = SQL & "0)"
						cnn.execute SQL
						GravarLog sql
	
						'alterar falta
						SQL = "UPDATE SCA_NOTAS_FALTAS SET "
						SQL = SQL & "falta"&strPosicao&"= 0"
						SQL = SQL & " where codigo = " & strCodNota
						SQL = SQL & " and falta"&strPosicao&" is null"
						cnn.execute SQL
						
						SQL = "UPDATE SCA_NOTAS_FALTAS SET "
						SQL = SQL & "falta"&strPosicao&"= falta"&strPosicao&"+" & strFalta & ""
						SQL = SQL & " where codigo = " & strCodNota
						cnn.execute SQL
						GravarLog sql					
	
					end if
					RS.CLOSE
				end if				

			end if
			
		next
	ELSEIF TRIM(strGravarOnde) = "HISTORICO" THEN
	'busca os dados dos lancamentos de historico
		intQtdeLancamento		= request.form("qtdeAluno")
		for i=1 to intQtdeLancamento
			strCodHistoricoDisciplina		= request.form("txtCodHistoricoDisciplina_"&i)
			strCodAluno			= request.form("txtCodAluno_"&i)
			strFalta 			= request.form("txtFalta_"&i)
			strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
			strCodNota 			= request.form("txtCodAlunoNota_"&i)
			'alterar nota
			if strFalta<>"" then
				'alterar falta
				SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
				SQL = SQL & " falta"&strPosicao&"= 0"
				SQL = SQL & " where codigo = " & strCodHistoricoDisciplina
				SQL = SQL & " and falta"&strPosicao&" is null"
				cnn.execute SQL
			
				SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
				SQL = SQL & " falta"&strPosicao&"=falta"&strPosicao&"+" & strFalta & ""
				SQL = SQL & " where codigo = " & strCodHistoricoDisciplina
				cnn.execute SQL
				GravarLog sql
				
				SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
				SQL = SQL & " WHERE cod_empresa="&intCodEmp
				SQL = SQL & " AND cod_aluno="&strCodAluno
				SQL = SQL & " AND cod_periodo="&intCodPeriodo
				SQL = SQL & " AND ano_letivo="&strAnoLetivo
				SQL = SQL & " AND semestre="&intSemestre
				SQL = SQL & " AND cod_disciplina="&intCodDisciplina
				SQL = SQL & " AND data='"&formatadataBD(strData) & "'"
				rs.open sql, cnn
				if rs.eof then
					SQL = "INSERT INTO SCA_FALTAS_DIARIA (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
					SQL = SQL & "ano_letivo, semestre, cod_disciplina, data, falta, sequencia) VALUES ("
					SQL = SQL & "" & intCodEmp & ","
					SQL = SQL & "" & strCodAluno & ","
					SQL = SQL & "0,"
					SQL = SQL & "" & intCodPeriodo & ","
					SQL = SQL & "" & strAnoLetivo & ","
					SQL = SQL & "" & intSemestre & ","
					SQL = SQL & "" & intCodDisciplina & ","
					SQL = SQL & "" & "'"&formatadataBD(strData) & "',"
					SQL = SQL & "" & strFalta & ","
					SQL = SQL & "0)"
					cnn.execute SQL
					GravarLog sql
				end if
				RS.CLOSE
			end if
		next
	END IF

	if strPaginaRetorno = "FALTAS" then
		strParametro = "Faltas_cad.asp?cmbPeriodo="&intCodPeriodo
		strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
		strParametro = strParametro & "&cmbSemestre="&intSemestre
		strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
		strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
		strParametro = strParametro & "&cmbTurma="&intCodTurma
		strParametro = strParametro & "&chkAluno="&strAlunos
		strParametro = strParametro & "&cmbTurno="&intCodTurno
		strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
		strParametro = strParametro & "&cmbCurso="&intCodCurso	
		strParametro = strParametro & "&txtData="&formatadataAP(strData)
	elseif strPaginaRetorno = "FALTASPROF" then
		strParametro = "FaltasProf_cad.asp?cmbPeriodo="&intCodPeriodo
		strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
		strParametro = strParametro & "&cmbSemestre="&intSemestre
		strParametro = strParametro & "&cmbDisciplinaProfessorHorario="&intCodDisciplina
		strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplina
		strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
		strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
		strParametro = strParametro & "&chkAluno="&strAlunos
		strParametro = strParametro & "&cmbTurno="&intCodTurno
		strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
		strParametro = strParametro & "&cmbCurso="&intCodCurso	
		strParametro = strParametro & "&txtData="&formatadataAP(strData)
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("<%=strMensagem%>");
			window.navigate("<%=strParametro%>");
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>