<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 

response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 19/01/2021
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas 
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->

<%
	'on error resume next
	
	strPaginaRetorno	= Trim(Request.Form("txtPaginaRetorno"))
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))
	strAtivos           = trim(request("cmbativos"))
	
	intSemestre 		= Trim(Request.Form("txtSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))

	strGravarOnde = "NOTA"	
    if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
	  'GRAVANDO NO ARQUIVO DE HISTORICO
	  strGravarOnde = "HISTORICO"
	  strMensagem = "Registro salvo com sucesso no Histórico..."
    end if

	if strPaginaRetorno = "NOTA" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
	elseif strPaginaRetorno = "NOTAPROF" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaProfessorHorario"))
	end if
	
	intCodTipoNota 		= Trim(Request.Form("chkTipoNota"))

	
	
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	if strPaginaRetorno = "NOTA" then
		intCodTurma 		= Trim(Request.Form("cmbTurma"))
	elseif strPaginaRetorno = "NOTAPROF" then
		intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
	end if

	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if

	intCodTurno 		= Trim(Request.Form("cmbTurno"))
	strAlunos 			= Trim(Request.Form("chkAluno"))
	strPosicao			= Trim(Request.Form("txtPosicao"))
			
	IF TRIM(strGravarOnde) = "NOTA" THEN
	'busca os dados dos lancamentos de notas
		intQtdeLancamento = request.form("qtdeAluno")
		for i=1 to intQtdeLancamento

			strCodAluno			= request.form("txtCodAluno_"&i)
			strFalta 			= request.form("txtFalta_"&i)
			strCodNota 			= request.form("txtCodAlunoNota_"&i)
			strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
			strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")

			'alterar nota
			SQL = "UPDATE SCA_NOTAS_FALTAS SET "

			if strPercFaltas > intFrequenciaMinimaPerc then	
			   strSituacaoFinal = "RN"
			end if   

			if trim(strSituacaoFinal) = "" then
				SQL = SQL & "situacao=null, "
			else
				SQL = SQL & "situacao='" & strSituacaoFinal & "', "
			end if
			if strFalta = "" then
				SQL = SQL & "falta"&strPosicao&"=null "
			else
				SQL = SQL & "falta"&strPosicao&"=" & strFalta & ""
			end if
			SQL = SQL & " where codigo = " & strCodNota

			cnn.execute SQL
			GravarLog sql
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
			strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
			
			'altera hist disc
			SQL = "update SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
			if trim(strSituacaoFinal) = "" then
				SQL = SQL & "situacao=null, "
			else
				SQL = SQL & "situacao='" & strSituacaoFinal & "', "
			end if
			if strFalta = "" then
				SQL = SQL & "falta"&strPosicao&"=null "
			else
				SQL = SQL & "falta"&strPosicao&"=" & strFalta & ""
			end if
			SQL = SQL & " where codigo = " & strCodNota

			cnn.execute SQL
			GravarLog sql
		next
	END IF
	
	

	strParametro = "sca_ajuste_falta.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
	strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
	strParametro = strParametro & "&cmbTurma="&intCodTurma
	strParametro = strParametro & "&chkAluno="&strAlunos
	strParametro = strParametro & "&cmbTurno="&intCodTurno
	strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
	strParametro = strParametro & "&cmbCurso="&intCodCurso
	strParametro = strParametro & "&cmbativos="&strAtivos			

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("Registro de Faltas alterado com sucesso.");
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