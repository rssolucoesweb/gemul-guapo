	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Empresa
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno		= "Grupo_cad.asp"
	
	strAcao 			= Request.QueryString("acao")
	intCodigo	  		= ReplaceRequest(Trim(Request.Form("txtCodigo")))
	strDescricao  		= ReplaceRequest(Trim(Request.Form("txtDescricao")))
	strSituacao  		= ReplaceRequest(Trim(Request.Form("cmbSituacao")))

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Registro Incluído com sucesso"

		sql = " Insert into SEG_GRUPO (descricao, Situacao)" 
		sql = sql & " VALUES ("
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strSituacao & "')"
		
		
	elseif strAcao = "A"then
	
		strMensagem = "Registro Alterado com sucesso!"

		sql = "Update SEG_GRUPO set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " Where codigo = " & intCodigo
			
	elseif strAcao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso"
		sql = "Delete From SEG_GRUPO"
		sql = sql & " Where codigo = " & intCodigo
	
	end if

	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=paginaRetorno%>';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		if err.number = -2147217900 then
			%>
			<script>
				alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
				window.history.back();
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
			</script>
			<%
		end  if 	
	end if
%>