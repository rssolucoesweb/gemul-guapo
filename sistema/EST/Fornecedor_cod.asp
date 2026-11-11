<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 05/07/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de fornecedor
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
	strTipoPessoa 		= Trim(Request.Form("cmbTipoPessoa"))
	strNumero	 		= Trim(Request.Form("txtNumero"))
	strRazaoSocialNome	= Trim(Request.Form("txtRazaoSocialNome"))
	strEndereco	 		= Trim(Request.Form("txtEndereco"))
	strTelefone	 		= Trim(Request.Form("txtTelefone"))
	strResponsavel	 	= Trim(Request.Form("txtResponsavel"))
	intCodSecao			= Trim(Request.Form("cmbSecaoProduto"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Fornecedor Salvo com sucesso..."
		
		sql = "Insert Into EST_fornecedor(CodEmpresa, cod_secao, TipoPessoa, Numero, RazaoSocialNome, Endereco, Telefone, Responsavel, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & intCodSecao & ","
		sql = sql & "'" & strTipoPessoa & "',"
		sql = sql & "'" & strNumero & "',"
		sql = sql & "'" & strRazaoSocialNome & "',"
		sql = sql & "'" & strEndereco & "',"
		sql = sql & "'" & strTelefone & "',"
		sql = sql & "'" & strResponsavel & "',"
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	elseif acao="A" then
		
		strMensagem = "Fornecedor Alterado com sucesso..."
		
		sql = "Update EST_fornecedor Set"
		sql = sql & " TipoPessoa = '" & strTipoPessoa & "',"
		sql = sql & " cod_secao = " & intCodSecao & ","
		sql = sql & " Numero = '" & strNumero & "',"
		sql = sql & " RazaoSocialNome = '" & strRazaoSocialNome & "',"
		sql = sql & " Endereco = '" & strEndereco & "',"
		sql = sql & " Telefone = '" & strTelefone & "',"
		sql = sql & " Responsavel = '" & strResponsavel & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
		
	else
		strMensagem = "Fornecedor Excluida com sucesso..."
		
		sql = "Delete from EST_fornecedor "
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
			window.location='fornecedor_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>