<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/08/2021
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnnDocumento.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodDocumento		= Trim(Request.Form("txtCodigo"))
	strTitulo	 		= Trim(Request.Form("txtTitulo"))
	strDescricao 		= REPLACE(Trim(Request.Form("txtTexto")),"'","")
	
	strCampos	 		= Trim(Request.Form("campos"))
	
	situacao 			= Trim(Request.Form("cmbSituacao"))
	strPosicaoFinanceira= Trim(Request.Form("posicaofinanceira"))
	if strPosicaoFinanceira = "" THEN strPosicaoFinanceira = "N"
	strSituacaoAluno	= Trim(Request.Form("situacaoaluno"))
	intCodDepartamento	= Trim(Request.Form("cmbDepartamento"))
	if intCodDepartamento = "" then intCodDepartamento = "0"
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_DOCUMENTO(Titulo, Documento, cod_Departamento, situacaoAluno, posicaoFinanceira, Campos, situacao)"
		sql = sql & " Values ("
		sql = sql & "'" & strTitulo & "',"
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intCodDepartamento & ","
		sql = sql & "'" & strSituacaoAluno & "',"
		sql = sql & "'" & strPosicaoFinanceira & "',"
		sql = sql & "'" & strCampos & "',"
		sql = sql & "'" & situacao & "')"
		cnn.execute sql
		GravarLog left(sql,5000)

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_DOCUMENTO Set"
		sql = sql & " Titulo = '" & strTitulo & "',"
		sql = sql & " Documento = '" & strDescricao & "',"
		sql = sql & " situacao = '" & situacao & "',"
		sql = sql & " posicaoFinanceira = '" & strPosicaoFinanceira & "',"
		sql = sql & " situacaoAluno = '" & strSituacaoAluno & "',"
		sql = sql & " cod_Departamento = " & intCodDepartamento & ","
		sql = sql & " Campos = '" & strCampos & "'"
		sql = sql & " where codigo = " & intCodDocumento
		cnn.execute sql
		GravarLog left(sql,5000)
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_DOCUMENTO "
		sql = sql & " where codigo = " & intCodDocumento
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'sca_criar_documento.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location = 'Documento_cad.asp';
		</script>
		<%
	end if
%>