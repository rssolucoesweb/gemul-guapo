<!--
	::	IMOB
	::	Data de Criação...: 16/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Inclusão de perfil do menu (pagina de gravar)
	::	Desenvolvedores...: 
	::	Data Atualizacao..: 
-->
<%
'as paginas do menu administrativo não vão validar o ano letivo
bolPaginaAnoLetivo 	= "N"
'as paginas do menu administrativo não vão validar a unidade de ensino
strValidaUnidadeEnsino = "N"
%>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	strAcao 			= request.QueryString("acao")
	intCodPerfil		= request.Form("cmbCodPerfilMenu")
	intCodEmpresa		= session("codEmpresa")
	vetCodMenu 			= split(request.Form("chkMenu"),",")

	' Dados do Usuario	
	strUsuario_incl 	= session("strUsuario")
	strData_hora_incl 	= formataDataBd(date) & " " & time
	strUsuario_altr 	= session("strUsuario")
	strData_hora_altr	= formataDataBd(date) & " " & time

	'on error resume next
	cnn.begintrans
	
	if trim(strAcao) = "I" then
		strMensagem = session("strMensagemInclusao")	
		
		'insere item para inicial o menu
		sql = "Insert Into SEG_perfil_menu (codigo_SEG_perfil, codigo_SEG_menu, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)" 
		sql = sql & " Values ("
		sql = sql & "" & intCodPerfil & ","
		sql = sql & "1,"'menu inicial
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
		
		'inclusão de menu por perfil
		for i=0 to ubound(vetCodMenu)
			
			'insere item no menu na tabela de perfil
			sql = "Insert Into SEG_perfil_menu (codigo_SEG_perfil, codigo_SEG_menu, "
			sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)" 
			sql = sql & " Values ("
			sql = sql & "" & intCodPerfil & ","
			sql = sql & "" & vetCodMenu(i) & ","
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
	
		next
	elseif trim(strAcao) = "A" then
		strMensagem = session("strMensagemAlteracao")
		' Exclui os dados referente ao menu
		sql = " DELETE FROM SEG_perfil_menu"
		sql = sql & " Where codigo_SEG_perfil = " & intCodPerfil
		cnn.execute sql	
		
		'insere item para inicial o menu
		sql = "Insert Into SEG_perfil_menu (codigo_SEG_perfil, codigo_SEG_menu, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)" 
		sql = sql & " Values ("
		sql = sql & "" & intCodPerfil & ","
		sql = sql & "1,"'menu inicial
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
		
		'inclusão de menu por perfil
		for i=0 to ubound(vetCodMenu)
			
			'insere item no menu na tabela de perfil
			sql = "Insert Into SEG_perfil_menu (codigo_SEG_perfil, codigo_SEG_menu, "
			sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)" 
			sql = sql & " Values ("
			sql = sql & "" & intCodPerfil & ","
			sql = sql & "" & vetCodMenu(i) & ","
	
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
	
		next		
	elseif strAcao = "E" then
		
		strMensagem = session("strMensagemExclusao")
		
		' Exclui os dados referente ao menu
		sql = " DELETE FROM SEG_perfil_menu"
		sql = sql & " Where codigo_SEG_perfil = " & intCodPerfil
		cnn.execute sql		
	 
	end if

	if err.number = 0 then
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Seg_perfilMenuEmpresa_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans 
		response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='modulos/academico/Seg_InclusaoUsrGrupo_cad.asp'"
	end if
%>