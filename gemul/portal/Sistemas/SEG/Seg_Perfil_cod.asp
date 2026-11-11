<!--
	::	IMOB
	::	Data de Criação...: 12/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Inclusão de perfil (pagina de gravar)
	::	Desenvolvedores...: 
	::	Data Atualizacao..: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	strAcao 			= request.QueryString("acao")
	
	intCodPerfil		= request.Form("txtCodigo")
	strDescricao 		= ReplaceRequest(request.Form("txtDescricao"))
	intCodTipoAcesso	= request.form("cmbCodTipoAcesso")
	intCodEmpresa		= request.form("cmbCodEmpresa")
	
	' Dados do Usuario	
	strUsuario_incl 		= session("strUsuario")
	strData_hora_incl 	= formataDataBd(date) & " " & time
	strUsuario_altr 		= session("strUsuario")
	strData_hora_altr		= formataDataBd(date) & " " & time

	'on error resume next
	cnn.begintrans

	if strAcao = "I" then
		
		strMensagem = session("strMensagemInclusao")	
		
		'insere item no menu
		sql = "Insert Into SEG_perfil (descricao, codigo_SEG_tipo_acesso, codEmpresa, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)" 
		sql = sql & " Values ("
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intCodTipoAcesso & ","
		sql = sql & "" & intCodEmpresa & ","
		
		' Usuario do Sistema
		if strUsuario_incl <> "" then
			sql = sql & "'" & strUsuario_incl & "',"
		else
			sql = sql & "null,"
		end if
		
		if strData_hora_incl <> "" then
			sql = sql & "'" & strData_hora_incl & "',"
		else
			sql = sql & "null,"
		end if
		
		'Campos nulos para campo Usuario Alteracao e data Alteracao
		sql = sql & "" & "null, null" & ")"
		

		cnn.execute sql
	elseif strAcao = "A" then
		
		strMensagem = session("strMensagemAlteracao")
		
		'altera item no menu
		sql = "update SEG_perfil set "
		sql = sql & " descricao = '" & strDescricao & "', "
		sql = sql & " codigo_SEG_tipo_acesso = " & intCodTipoAcesso & ", "
		sql = sql & " codEmpresa = " & intCodEmpresa & ", "
		if strUsuario_incl <> "" then
			sql = sql & "usuario_altr = '" & strUsuario_incl & "',"
		else
			sql = sql & "usuario_altr = null,"
		end if		
		if strData_hora_incl <> "" then
			sql = sql & "data_hora_altr = '" & strData_hora_incl & "'"
		else
			sql = sql & "data_hora_altr = null"
		end if
		sql = sql & " where codigo = " & intCodPerfil
		cnn.execute sql		
	elseif strAcao = "E" then
		
		strMensagem = session("strMensagemExclusao")
		
		' Exclui os dados referente ao menu
		sql = " DELETE FROM SEG_perfil"
		sql = sql & " Where codigo = " & intCodPerfil
		cnn.execute sql		
	 
	end if

	if err.number = 0 then
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Seg_perfil_cad.asp?acao=<%=strAcao%>&codMenu=<%=intCodMenu%>';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans 
		response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description
	end if
%>