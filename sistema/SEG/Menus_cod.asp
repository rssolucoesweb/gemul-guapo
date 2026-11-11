<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Menus
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
	intCodMenu			= Trim(Request("txtCodMenu"))
	strSiglaSistema 	= Trim(Request("cmbSistemas"))
	strSiglaModulo		= Trim(Request("cmbModulosSistema"))
	strDescMenu			= Trim(Request("txtDescMenu"))
	intOrdemMenu 		= Trim(Request("txtOrdemMenu"))
	strSituacao 		= Trim(Request("cmbSituacao"))

	if acao="I" then
		
		strMensagem = "Registro Incluído com sucesso"
		
		sql = "SELECT max(Menu_Codg) as NovoCodMenu From SEG_MENUS_SISTEMA"  
		rs.open sql,cnn

		if rs.eof = false then
			if isnull(rs("NovoCodMenu")) = false then
				intCodMenu = cint(rs("NovoCodMenu")) + 1
			else
				intCodMenu = 1
			end if
		else
			intCodMenu = 1
		end if		
		rs.close			

		sql = "Insert Into SEG_MENUS_SISTEMA(Menu_Sist_Sigl,  Menu_Modu_Sigl , Menu_Codg, Menu_Desc, Menu_Numr_Posicao, Situacao)"
		sql = sql & " Values ("
		sql = sql & "'" & strSiglaSistema & "',"
		sql = sql & "'" & strSiglaModulo & "',"
		sql = sql & "" & intCodMenu & ","
		sql = sql & "'" & strDescMenu & "',"
		sql = sql & "" & intOrdemMenu & ","
		sql = sql & "'" & strSituacao & "')"
				
	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso!"

		sql = " Update SEG_MENUS_SISTEMA set"
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " Menu_Desc = '" & strDescMenu & "',"
		sql = sql & " Menu_Numr_Posicao = " & intOrdemMenu & ""
		sql = sql & " Where Menu_Sist_Sigl = '" & strSiglaSistema & "'"
		sql = sql & " And Menu_Modu_Sigl = '" & strSiglaModulo & "'"
		sql = sql & " And Menu_Codg = " & intCodMenu
			
			
	elseif acao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso"
		
		sql = "Delete From SEG_MENUS_SISTEMA"
		sql = sql & " Where Menu_Sist_Sigl = '" & strSiglaSistema & "'"
		sql = sql & " And Menu_Modu_Sigl = '" & strSiglaModulo & "'"
		sql = sql & " And Menu_Codg = " & intCodMenu
	
	end if

	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
  		    window.location = 'Menus_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>