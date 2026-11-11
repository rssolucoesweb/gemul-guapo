<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
	intCodEmp						= Session("CodEmpresa")
	intCodGrade						= Trim(Request.Form("txtCodGrade"))
	intCodCurricularDisciplina		= Trim(Request.Form("txtCodCurricularDisciplina"))
	strChSemanal					= Trim(Request.Form("txtChSemanal"))
	strChMensal						= Trim(Request.Form("txtChMensal"))
	strChAnual						= Trim(Request.Form("txtChAnual"))
	strChPratica					= Trim(Request.Form("txtChPratica"))
	strChTeorica					= Trim(Request.Form("txtChTeorica"))
	strOmitirCriterio				= Trim(Request.Form("cmbOmitirCriterio"))
	
	if strChPratica = "" then strChPratica = "0"
	if strChTeorica = "" then strChTeorica = "0"
	
	if acao="A" then
		
		strMensagem = "Disciplina Alterada com sucesso..."
		
		sql = "Update SCA_GRADECURRICULARDISCIPLINA Set"
		
		if strChSemanal = "" then
			sql = sql & " Ch_Semanal = null,"
		else
			sql = sql & " Ch_Semanal = " & strChSemanal & ","
		end if
		
		if strChMensal = "" then
			sql = sql & " Ch_Mensal = null,"
		else
			sql = sql & " Ch_Mensal = " & strChMensal & ","
		end if
		
		if strChAnual = "" then
			sql = sql & " Ch_Anual = null,"
		else
			sql = sql & " Ch_Anual = " & strChAnual & ","
		end if

		if strChPratica = "" then
			sql = sql & " Ch_Pratica = null,"
		else
			sql = sql & " Ch_Pratica = " & strChPratica & ","
		end if
		
		if strChTeorica = "" then
			sql = sql & " Ch_Teorica = null,"
		else
			sql = sql & " Ch_Teorica = " & strChTeorica & ","
		end if

		if strOmitirCriterio = "" then
			sql = sql & " Omitir_Criterio = null,"
		else
			sql = sql & " Omitir_Criterio = '" & strOmitirCriterio & "'"
		end if
		
		sql = sql & " WHERE COD_GRADECURRICULAR = " & intCodGrade
		sql = sql & " And Cod_GradeCurricularDisciplina = " & intCodCurricularDisciplina
		
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.opener.frm.submit();
			window.location="sca_matriz_curricular_disciplina.asp?CodGrade=<%=intCodGrade%>&GradeCurricularDisciplina=<%=intCodCurricularDisciplina%>";
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