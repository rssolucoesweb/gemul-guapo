<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 05/07/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Processo
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
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
	intCodAssunto		= Trim(Request.Form("cmbAssunto"))
	intCodModalidade	= Trim(Request.Form("cmbModalidade"))
	strNumero			= Trim(Request.Form("txtNumero"))
	strObjeto 			= Trim(Request.Form("txtObjeto"))
	strData 			= formatadataBD(Trim(Request.Form("txtData")))
	strSituacao	 		= Trim(Request.Form("cmbSituacao"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Processo Salvo com sucesso..."
		
		sql = "Insert Into SCC_processo(CodEmpresa, codAssunto, codModalidade, Numero, objeto, dataCadastro, Situacao, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & intCodAssunto & ","
		sql = sql & "" & intCodModalidade & ","
		sql = sql & "'" & strNumero & "',"
		sql = sql & "'" & strObjeto & "',"
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strSituacao & "',"

		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	elseif acao="A" then
		
		strMensagem = "Processo Alterado com sucesso..."
		
		sql = "Update SCC_processo Set"
		sql = sql & " codAssunto = " & intCodAssunto & ","
		sql = sql & " codModalidade = " & intCodModalidade & ","
		sql = sql & " Numero = '" & strNumero & "',"
		sql = sql & " objeto = '" & strObjeto & "',"
		sql = sql & " dataCadastro = '" & strData & "',"
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
		
	else
		strMensagem = "Processo Excluido com sucesso..."
		
		sql = "Delete from SCC_processo "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
	
	end if
	
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Processo_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>