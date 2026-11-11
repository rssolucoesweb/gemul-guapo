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
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../../includes/inc_Mascaras.asp"-->
<%
	strAcao 				= request.QueryString("acao")
	
	intCodPerfil			= request.Form("cmbCodPerfilMenu")
	strCPF					= Trim(Request.Form("txtCPF"))
	intCodGrupo				= Trim(Request.Form("cmbGrupo"))
	
	' Dados do Usuario	
	strUsuario_incl 		= session("strUsuario")
	strData_hora_incl 		= formataDataBd(date) & " " & time
	strUsuario_altr 		= session("strUsuario")
	strData_hora_altr		= formataDataBd(date) & " " & time

	'on error resume next
	cnn.begintrans
	
	if trim(strAcao) = "I" then
		strMensagem = session("strMensagemInclusao")	

		' usuario poderá ter um perfil por SRE
		sql = " DELETE FROM SEG_usuarios_acesso"
		sql = sql & " Where cpf_SEG_usuarios = " & formataCpfBD(strCPF)
		sql = sql & " And codigo_seg_grupo = " & intCodGrupo
		cnn.execute sql		
		
		'insere controle acesso por perfil
		sql = "Insert Into SEG_usuarios_acesso (cpf_SEG_usuarios, codigo_SEG_perfil, codigo_seg_grupo, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)" 
		sql = sql & " Values ("
		sql = sql & "" & formataCpfBD(strCPF) & ","
		sql = sql & "" & intCodPerfil & ","
		sql = sql & "" & intCodGrupo & ","
		
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
	
	elseif strAcao = "E" then
		
		strMensagem = session("strMensagemExclusao")
		
		' Exclui os dados referente ao menu
		sql = " DELETE FROM SEG_usuarios_acesso"
		sql = sql & " Where cpf_SEG_usuarios = " & formataCpfBD(strCPF)
		sql = sql & " And codigo_seg_grupo = " & intCodGrupo
		cnn.execute sql	 	
	 
	end if

	if err.number = 0 then
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Seg_ControleAcessoGrupo_cad.asp?txtCPF=<%=strCPF%>';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans 
		response.redirect "../../erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='modulos/academico/Seg_InclusaoUsrGrupo_cad.asp'"
	end if
%>