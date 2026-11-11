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

	intCodigo	 	= Session("CodGrupo")
	layout 			= Trim(Request.Form("txtLayout"))

	
	sql = "Update seg_grupo Set"
	sql = sql & " cor_layout = '" & layout & "'"
	sql = sql & " where codigo = " & intCodigo
	cnn.execute sql
	GravarLog sql

	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		session("css_layout_novo") = layout
		%>
		<script>
			window.location='seg_cor_layout.asp';
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