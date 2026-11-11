<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Convenios
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao				 = Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strNome  			= Trim(Request.Form("txtNome"))
	strEndereco 		= Trim(Request.Form("txtEndereco"))
	strTelefone 		= Trim(Request.Form("txtTelefone"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	
	' Dados do Usuario
	strUsuario_incl   = session("strNomeUsuario")
	strData_hora_incl = formatadataBD(date) & " " & time 
	strUsuario_altr   =	session("strNomeUsuario")
	strData_hora_altr = formatadataBD(date) & " " & time 
		
	if acao="I" then
		
		strMensagem = "Convênio salvo com sucesso..."
		
		sql = "Insert Into SIT_Convenios ( CodEmpresa, Nome, Endereco, Telefone, Descricao, "
		sql = sql & " Usuario, DataIncl, UsuarioAlt, DataAlt)" 
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strNome & "',"
		sql = sql & "'" & strEndereco & "',"
		sql = sql & "'" & strTelefone & "',"
		sql = sql & "'" & strDescricao & "',"
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
			
	elseif acao="A" then
		
		strMensagem = "Convênio Alterado com sucesso..."
		
		sql = "Update SIT_Convenios Set"
		sql = sql & " Nome = '" & strNome & "',"
		sql = sql & " Endereco = '" & strEndereco & "',"
		sql = sql & " Telefone = '" & strTelefone & "',"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " UsuarioAlt = '" & strUsuario_incl  & "',"
		sql = sql & " DataAlt = '" & strData_hora_incl  & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
	
	else
		strMensagem = "Convênio Excluido com sucesso..."
		
		sql = "Delete from SIT_Convenios "
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
			window.location='Convenios_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>