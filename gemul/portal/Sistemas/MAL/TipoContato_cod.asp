<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 24/09/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Tipo Contato.
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
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	
	if acao="I" then
		
		strMensagem = "Tipo Contato Salvo com sucesso..."
		
		sql = "Insert Into MAL_TipoContato(Descricao) "
		sql = sql & " Values ("
		sql = sql & "'" & strDescricao & "')"

	elseif acao="A" then
		
		strMensagem = "Tipo Contato Alterado com sucesso..."
		
		sql = "Update MAL_TipoContato Set"
		sql = sql & " Descricao = '" & strDescricao & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		
	else
		strMensagem = "Tipo Contato Excluido com sucesso..."
		
		sql = "Delete from MAL_TipoContato "
		sql = sql & " Where Codigo = " & intCodigo
	
	end if
	
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TipoContato_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>