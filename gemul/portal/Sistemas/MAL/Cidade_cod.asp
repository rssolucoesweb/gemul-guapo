<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 21/09/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Cidade.
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
    ::	Observação        : Um dia depois do meus 34 anos, essa idade ralando igual um doido.
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
	strUF		 		= Trim(Request.Form("txtUF"))
	
	if acao="I" then
		
		strMensagem = "Ciadde Salva com sucesso..."
		
		sql = "Insert Into MAL_Cidade(Descricao, UF) "
		sql = sql & " Values ("
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strUF & "')"
		

	elseif acao="A" then
		
		strMensagem = "Ciadde Alterada com sucesso..."
		
		sql = "Update MAL_Cidade Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " UF = '" & strUF & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		
	else
		strMensagem = "Ciadde Excluida com sucesso..."
		
		sql = "Delete from MAL_Cidade "
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
			window.location='Cidade_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>