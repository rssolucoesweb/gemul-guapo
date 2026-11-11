<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	strSenhaAtual	 		= replace(Trim(Request.Form("txtSenhaAtual")),"'","")
	strSenhaNova 			= replace(Trim(Request.Form("txtSenhaNova")),"'","")
	strSenhaNovaRepetir    	= replace(Trim(Request.Form("txtSenhaNovaRepetir")),"'","")

	if acao="A" then
		'REGRA PARA INCLUSAO DE SITUACAO - ATIVO
		sql = "SELECT USUA_CODG, USUA_INFO_SENHA" 
		sql = sql & " FROM SEG_USUARIOS_SISTEMA"
		sql = sql & " where USUA_CODG='" & SESSION("UsuarioWeb") & "'"
		strSenhaChecked = "NAO"
		rs.open sql, cnn
		if not RS.EOF then
			if TRIM(rs("USUA_INFO_SENHA")) = TRIM(strSenhaAtual) then
				strSenhaChecked = "SIM"
			end if
		end if
		rs.close
		
		IF strSenhaChecked = "NAO" THEN
			%>
			<script>
				alert("ATENÇÃO: A senha atual não confere com a senha informada.");
				window.history.back();
			</script>
			<%
			response.end
		END IF
		
		strMensagem = "Senha alterada com sucesso..."
		sql = "Update SEG_USUARIOS_SISTEMA Set"
		sql = sql & " USUA_INFO_SENHA = '" & strSenhaNova & "'"
		sql = sql & " where USUA_CODG='" & SESSION("UsuarioWeb") & "'"
		sql = sql & " AND USUA_STAT='A'"
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='academico.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>