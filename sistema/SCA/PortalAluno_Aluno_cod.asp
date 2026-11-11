<!--
	::	Data de Criação...: 08/09/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Alterar Aluno
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../includes/inc_cnnGedu.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/cripto.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	strLogin 			= Trim(Request("txtLogin"))
	strEmail		 	= Trim(Request("txtEmail"))
	
	' Criptografa Senha
	if strSenha <> "" then 
		strSenha = FormatCripto(strSenha,True)
	end if 
	
	if acao ="A" then
		
		strMensagem = "Dados Alterado com sucesso..."
	
		sql = " Update SCA_ALUNO Set email = '" & strEmail & "'"
		sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa")
		sql = sql & " And CODIGO = " & Session("CodAluno")

	end if
	
	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='principal.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>