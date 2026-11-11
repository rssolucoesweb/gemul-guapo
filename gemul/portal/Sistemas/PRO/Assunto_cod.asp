<!--
	::	pro
	::	Data de Criação...: 12/05/2013
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir assunto
	::	Data Atualizacao..: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strPrazo			= Trim(Request.Form("txtPrazo"))
	strSituacao	 		= Trim(Request.Form("cmbSituacao"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Insert Into PRO_Assunto(Cod_Empresa, Descricao, PrazoEstimado, Situacao, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strPrazo & "',"
		sql = sql & "'" & strSituacao & "',"

		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "Update PRO_Assunto Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " PrazoEstimado = '" & strPrazo & "',"
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		sql = sql & " And Cod_Empresa = " & intCodEmpresa 
		
	else
		strMensagem = "Registro excluida com sucesso..."
		
		sql = "Delete from PRO_Assunto "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_Empresa = " & intCodEmpresa 
	
	end if
	
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Assunto_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>