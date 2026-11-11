<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Categoria de Medicos
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 			= Trim(Request.QueryString("acao"))
	intCodEmpresa	= session("codEmpresa")	
	intCodCategoria = Trim(Request.Form("txtCodCategoria"))
	strCategoria 	= replace(Trim(Request.Form("txtCategoria")),"'", " ") 
	
	' Dados do Usuario
	strUsuario_incl   = session("strNomeUsuario")
	strData_hora_incl = formatadataBD(date) & " " & time 
	strUsuario_altr   =	session("strNomeUsuario")
	strData_hora_altr = formatadataBD(date) & " " & time 
		
	if acao="I" then
		
		strMensagem = "Categoria salva com sucesso..."
		
		sql = "Insert Into SIT_CategoriaMedica (CodEmpresa, Descricao," 
		sql = sql & "Usuario, DataIncl, UsuarioAlt, DataAlt)"          
		sql = sql & " Values ("

		sql = sql & "'" & intCodEmpresa & "',"
		sql = sql & "'" & strCategoria & "',"
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	elseif acao="A" then
		
		strMensagem = "Categoria Alterado com sucesso..."
		
		sql = "Update SIT_CategoriaMedica Set"
		sql = sql & " Descricao = '" & strCategoria & "',"
		sql = sql & " UsuarioAlt = '" & strUsuario_incl  & "',"
		sql = sql & " DataAlt = '" & strData_hora_incl  & "'"
		sql = sql & " Where Codigo = " & intCodCategoria
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		
		
	else
		strMensagem = "Categoria Excluido com sucesso..."
		
		sql = "Delete from SIT_Medicos "
		sql = sql & " Where CodCategoria = " & intCodCategoria
		cnn.execute sql
		
		sql = "Delete from SIT_CategoriaMedica "
		sql = sql & " Where Codigo = " & intCodCategoria
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
			window.location='CategoriaMedica_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>