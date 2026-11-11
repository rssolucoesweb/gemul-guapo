<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Opção da Enquete
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
		
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodEnquete 		= Trim(Request.Form("txtCodEnquete"))
	intCodOpcaoEnquete 	= Trim(Request.Form("txtCodOpcaoEnquete"))
	strOpcao 			= Trim(Request.Form("txtOpcao"))
	strVotos			= 0
			
	if acao="I" then
		
		strMensagem = "Opção Enquete Salva com sucesso..."
			
		sql = "Insert Into SIT_EnqueteOpcao( CodEnquete, Opcao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEnquete & ","
		sql = sql & "'" & strOpcao & "')"
	
	elseif acao="A" then
		
		strMensagem = "Opção Enquete Alterada com sucesso..."
		
		sql = "Update SIT_EnqueteOpcao Set"
		sql = sql & " Opcao = '" & strOpcao & "'"
		sql = sql & " Where CodEnquete = " & intCodEnquete
		sql = sql & " and Codigo = " & intCodOpcaoEnquete

	else
		strMensagem = "Opção Enquete Excluida com sucesso..."
		
		sql = "Delete from SIT_EnqueteOpcao "
		sql = sql & " Where CodEnquete = " & intCodEnquete
		sql = sql & " and Codigo = " & intCodOpcaoEnquete

	end if

	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='EnqueteOpcoes_cad.asp?CodEnquete=<%=intCodEnquete%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>