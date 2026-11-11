<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--
	::	IMOB
	::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: incluir devolucao
	::	Data Atualizacao..: 
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmpresa				= session("codEmpresa")	
	intCodRequisicao 			= Trim(Request("req"))
	strSituacao					= 3 'autorizado

	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if intCodRequisicao<>"" then
		strMensagem = "Solicitação devolvida com sucesso."
		sql = "update est_requisicao set codSituacao = 1, usuario_autorizacao = null,data_autorizacao = null"
		sql = sql & " Where Codigo = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		'incluir movimentação
		strSituacaoAndamento = "Solicitação devolvida ao solicitante"
		%><!--#include file="../includes/inc_andamento_requisicao.asp"--><%		
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='devolverRequisicao_con.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>