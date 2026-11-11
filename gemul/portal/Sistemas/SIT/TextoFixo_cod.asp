<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 20/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Texto Fixo
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")
	intCodigo			= Trim(Request.Form("txtCodigo"))
	intCodTipoTexto		= Trim(Request("cmbTipoTexto"))
	strTexto			= replace(Request.Form("txtTexto"),"'","")
	
	' Dados do Usuario
	strUsuario_incl    	= session("strNomeUsuario")
	strData_hora_incl 	= formatadataBD(date) & " " & time 
	strUsuario_altr   	= session("strNomeUsuario")
	strData_hora_altr 	=formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Texto Salva com sucesso..."
		
		sql = "Insert Into SIT_TextoFixo(CodEmpresa, CodTipoTexto, Texto, "
		sql = sql & " UsuarioIncl, DataIncl, UsuarioAlt, DataAlt)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & intCodTipoTexto & "',"
		sql = sql & "'" & strTexto & "',"
			
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	elseif acao="A" then
		
		strMensagem = "Texto Alterada com sucesso..."
		
		sql = "Update SIT_TextoFixo Set"
		sql = sql & " CodTipoTexto = " & intCodTipoTexto & ","
		sql = sql & " Texto = '" & strTexto & "',"
		sql = sql & " UsuarioAlt = '" & strUsuario_incl  & "',"
		sql = sql & " DataAlt = '" & strData_hora_incl  & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		
	else
	
		strMensagem = "Texto Excluido com sucesso..."
		sql = "Delete from SIT_TextoFixo "
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
			window.location='TextoFixo_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>