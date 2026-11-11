<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/09/2021
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnnDocumento.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strAssunto 			= Trim(Request.Form("txtAssunto"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDataAta 			= formatadataBD(Request.Form("txtDataAta"))
	strTextoAta 		= Trim(Request.Form("txtTexto"))
	
	intCodDepartamento	= Trim(Request.Form("cmbDepartamento"))
    strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestre			= Trim(Request.Form("cmbSemestre"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_ATA( Cod_empresa, Assunto, descricao, data, TextoAta, AnoLetivo, Semestre)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strAssunto & "',"
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strDataAta & "',"
		
		if 	strTextoAta = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strTextoAta & "',"
		end if
		
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ")"
		
		cnn.execute sql
		GravarLog left(sql,5000)

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_ATA Set"
		sql = sql & " Assunto = '" & strAssunto & "',"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " data = '" & strDataAta & "',"
		sql = sql & " AnoLetivo = " & strAnoLetivo & ","
		sql = sql & " Semestre = " & intSemestre & ","
		
		if 	strTextoAta = "" then
			sql = sql & "TextoAta = NULL "
		else
			sql = sql & "TextoAta = '" & strTextoAta & "'"
		end if
		
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And Codigo = " & intCodigo
		cnn.execute sql
		GravarLog left(sql,5000)
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From SCA_ATA "
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_ata_reuniao.asp';
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