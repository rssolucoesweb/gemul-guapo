<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro Rota a Empresa
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	
	strSiglaSistema  	= ReplaceRequest(Trim(Request.Form("txtSiglaSistema")))
	strDescSistema 		= ReplaceRequest(Trim(Request.Form("txtDescSistema")))
	strMensSistema 		= ReplaceRequest(Trim(Request.Form("txtMensagem")))
	intCodModulo		= Trim(Request.Form("cmbModulo"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	
	if acao="I" then
		
		strMensagem = "Registro Incluído com sucesso"
	
		sql = "Insert Into SEG_SISTEMAS_INFORMATICA(Sist_Sigl, Sist_Desc, Sist_info_Mensagem, "
		sql = sql & "  Sist_Stat, Mod_Cod)"
		sql = sql & " Values ("
		sql = sql & "'" & strSiglaSistema & "',"
		sql = sql & "'" & strDescSistema & "',"
		sql = sql & "'" & strMensSistema & "',"
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "" & intCodModulo & ")"

	elseif acao="A" then
	
		sql = "update SEG_SISTEMAS_INFORMATICA set"
		sql = sql & " Sist_Desc = '" & strDescSistema & "',"
		sql = sql & " Sist_info_Mensagem = '" & strMensSistema & "',"
		sql = sql & " Sist_Stat = '" & strSituacao & "',"
		sql = sql & " Mod_Cod = " & intCodModulo & ""
		sql = sql & " where Sist_Sigl = '" & strSiglaSistema & "'"
			
	elseif acao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso"
	
		sql = " Delete From SEG_SISTEMAS_INFORMATICA"
		
		sql = sql & " where Sist_Sigl = '" & strSiglaSistema & "'"
			
	end if

	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
  		    window.location = 'RotaEmpresa_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>