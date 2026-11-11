<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Modulos
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	strSiglaSistema 	= Trim(Request("cmbSistemas"))

	strSiglaModulo		= Trim(Request.Form("txtSiglaModulo"))
	strDescModulo		= Trim(Request.Form("txtDescModulo")) 
	strMensModulo		= Trim(Request.Form("txtMensagem"))
	strSituacao			= Trim(Request.Form("cmdSituacao"))
	strURL 				= Trim(Request.Form("txtURL"))

	if acao="I" then
		
		strMensagem = "Registro Incluído com sucesso"

		sql = "Insert Into SEG_MODULOS_SISTEMA(Modu_Sist_Sigl,  Modu_Sigl , Modu_Desc, Modu_Info_Mensagem, Modu_Stat, Modu_URL)"
		sql = sql & " Values ("
		sql = sql & "'" & strSiglaSistema & "',"
		sql = sql & "'" & strSiglaModulo & "',"
		sql = sql & "'" & strDescModulo & "',"
		sql = sql & "'" & strMensModulo & "',"
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strURL & "')"
		
	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso!"
		
		sql = "update SEG_MODULOS_SISTEMA set"
		sql = sql & " Modu_Desc = '" & strDescModulo & "',"
		sql = sql & " Modu_Info_Mensagem = '" & strMensModulo & "',"
		sql = sql & " Modu_Stat = '" & strSituacao & "',"
		sql = sql & " Modu_URL = '" & strURL & "'"
		sql = sql & " Where Modu_Sist_Sigl = '" & strSiglaSistema & "'"
		sql = sql & " and Modu_Sigl = '" & strSiglaModulo & "'"
	
	elseif acao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso"
		
		sql = "Delete From SEG_MODULOS_SISTEMA"
		sql = sql & " where Modu_Sist_Sigl = '" & strSiglaSistema & "'"
		sql = sql & " and Modu_Sigl = '" & strSiglaModulo & "'"
	
	end if
	
	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
  		    window.location = 'modulos_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>