<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas prof
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))

	intSemestre 		= Trim(Request.Form("txtSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	if Cint(strAnoLetivo) < Cint(session("strAnoLetivo")) then
		'GRAVANDO NO ARQUIVO DE HISTORICO
		strGravarOnde = "HISTORICO"
		strMensagem = "Registro salvo com sucesso no Histórico..."
	else
		'GRAVANDO NO ARQUIVO DE NOTAS
		strGravarOnde = "NOTA"
		msnHistorico  = ""
		strMensagem = "Registro salvo com sucesso..."
	end if

	intCodDisciplina	= Trim(Request.Form("cmbDisciplinaProfessorHorario"))
	intCodTipoNota 		= Trim(Request.Form("chkTipoNota"))
	intCodTurma 		= Trim(Request.Form("cmbTurmaProfessor"))
	intCodTurno 		= Trim(Request.Form("cmbTurno"))
	strAlunos 			= Trim(Request.Form("chkAluno"))
	strPosicao			= Trim(Request.Form("txtPosicao"))

	IF TRIM(strGravarOnde) = "NOTA" THEN
	'busca os dados dos lancamentos de notas
		intQtdeLancamento		= request.form("qtdeAluno")
		for i=1 to intQtdeLancamento
			strCodAluno			= request.form("txtCodAluno_"&i)
			strNota				= replace(request.form("txtNota_"&i),",",".")
			strFalta 			= request.form("txtFalta_"&i)
			strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
			strCodNota 			= request.form("txtCodAlunoNota_"&i)
			strMediaFinal		= replace(request.form("txtMediaFinal_"&i),",",".")
			strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
			if isnull(strCodNota) or trim(strCodNota) = "" then
				'incluir
				if strNota <> "" or strFalta <> "" then
	
					SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
					SQL = SQL & "ano_letivo, semestre, cod_disciplina, nota"&strPosicao&", falta"&strPosicao&",media,situacao) VALUES ("
					SQL = SQL & "" & intCodEmp & ","
					SQL = SQL & "" & strCodAluno & ","
					SQL = SQL & "" & strAlunoDisciplina & ","
					SQL = SQL & "" & intCodPeriodo & ","
					SQL = SQL & "" & strAnoLetivo & ","
					SQL = SQL & "" & intSemestre & ","
					SQL = SQL & "" & intCodDisciplina & ","
					if strNota = "" then
						SQL = SQL & "null,"
					else
						SQL = SQL & "" & strNota & ","
					end if
					if strFalta = "" then
						SQL = SQL & "null,"
					else
						SQL = SQL & "" & strFalta & ","
					end if
					if strMediaFinal = "" then
						SQL = SQL & "null,"
					else
						SQL = SQL & "" & strMediaFinal & ","
					end if
					if strSituacaoFinal = "" then
						SQL = SQL & "null)"
					else
						SQL = SQL & "'" & strSituacaoFinal & "')"
					end if				
					
					cnn.execute SQL
					GravarLog sql
					
				end if
			else
				'alterar nota
				SQL = "UPDATE SCA_NOTAS_FALTAS SET "
				if strNota = "" then
					SQL = SQL & "nota"&strPosicao&"=null,"
				else
					SQL = SQL & "nota"&strPosicao&"=" & strNota & ","
				end if
				if strMediaFinal = "" then
					SQL = SQL & "media=null,"
				else
					SQL = SQL & "media=" & strMediaFinal & ","
				end if
				if strSituacaoFinal = "" then
					SQL = SQL & "situacao=null,"
				else
					SQL = SQL & "situacao='" & strSituacaoFinal & "',"
				end if
				if strFalta = "" then
					SQL = SQL & "falta"&strPosicao&"=null"
				else
					SQL = SQL & "falta"&strPosicao&"=" & strFalta & ""
				end if
				SQL = SQL & " where codigo = " & strCodNota
				cnn.execute SQL
				GravarLog sql
			end if
			
		next
	ELSEIF TRIM(strGravarOnde) = "HISTORICO" THEN
	'busca os dados dos lancamentos de historico
		intQtdeLancamento		= request.form("qtdeAluno")
		for i=1 to intQtdeLancamento
			strCodHistoricoDisciplina		= request.form("txtCodHistoricoDisciplina_"&i)
			strCodAluno			= request.form("txtCodAluno_"&i)
			strNota				= replace(request.form("txtNota_"&i),",",".")
			strFalta 			= request.form("txtFalta_"&i)
			strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
			strCodNota 			= request.form("txtCodAlunoNota_"&i)
			strMediaFinal		= replace(request.form("txtMediaFinal_"&i),",",".")
			strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
			'alterar nota
			SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
			if strNota = "" then
				SQL = SQL & "nota"&strPosicao&"=null,"
			else
				SQL = SQL & "nota"&strPosicao&"=" & strNota & ","
			end if
			if strMediaFinal = "" then
				SQL = SQL & "media=null,"
			else
				SQL = SQL & "media=" & strMediaFinal & ","
			end if
			if strSituacaoFinal = "" then
				SQL = SQL & "situacao=null,"
			else
				SQL = SQL & "situacao='" & strSituacaoFinal & "',"
			end if
			if strFalta = "" then
				SQL = SQL & "falta"&strPosicao&"=null"
			else
				SQL = SQL & "falta"&strPosicao&"=" & strFalta & ""
			end if
			SQL = SQL & " where codigo = " & strCodHistoricoDisciplina
			cnn.execute SQL
			GravarLog sql
		next
	END IF

	strParametro = "NotasProf_cad.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaProfessorHorario="&intCodDisciplina
	strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
	strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
	strParametro = strParametro & "&chkAluno="&strAlunos
	strParametro = strParametro & "&cmbTurno="&intCodTurno
	strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
	strParametro = strParametro & "&cmbCurso="&intCodCurso	

			
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=strParametro%>';
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