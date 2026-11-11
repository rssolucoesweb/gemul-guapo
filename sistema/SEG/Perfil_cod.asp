<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Perfil
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
	intCodPerfil		= Trim(Request.Form("txtCodPerfil"))
	strDescPerfil 		= ReplaceRequest(Trim(Request.Form("txtDescPerfil")))
	strPublicar 		= Trim(Request.Form("cmbPublicar"))

	if acao="I" then
		
		strMensagem = "Registro Incluído com sucesso"
		
		strMensagem = "Registro Cadastrado com sucesso!"
	  	sql = "SELECT max(Perf_Codg) as NovoCodPerfil From SEG_PERFIS_SISTEMA"  
		rs.open sql,cnn
			
		if rs.eof = false then
			if isnull(rs("NovoCodPerfil")) = false then
				intCodPerfil = cint(rs("NovoCodPerfil")) + 1
			else
				intCodPerfil = 1
			end if
		else
			intCodPerfil = 1
		end if
		rs.close			
		
		sql = "Insert Into SEG_PERFIS_SISTEMA(Perf_Codg, Perf_Sist_Sigl, Perf_Desc, Publicar)"
		sql = sql & " Values ("
		sql = sql & "" & intCodPerfil & ","
		sql = sql & "'" & strSiglaSistema & "',"
		sql = sql & "'" & strDescPerfil & "',"
		sql = sql & "'" & strPublicar & "')"
		
		
	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso!"
		
		sql = "Update SEG_PERFIS_SISTEMA set"
		sql = sql & " Perf_Desc = '" & strDescPerfil & "',"
		sql = sql & " Publicar = '" & strPublicar & "'"
		sql = sql & " Where Perf_Codg = " & intCodPerfil
			
	elseif acao = "E"then 
			
		strMensagem = "Pefil Excluido com sucesso"
		
		sql = "Delete From SEG_PERFIS_ITENS_SISTEMA"
		sql = sql & " Where PITE_PERF_CODG = " & intCodPerfil
		cnn.execute sql
		
		sql = "Delete From SEG_PERFIS_SISTEMA"
		sql = sql & " Where PERF_CODG = " & intCodPerfil
		
	end if
	
	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
  		    window.location = 'Perfil_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>