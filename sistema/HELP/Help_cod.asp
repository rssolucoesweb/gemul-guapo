	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 03/08/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Help
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnnDocumento.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%

	paginaRetorno			= "Help_cad.asp"
	strAcao 				= Request.QueryString("acao")
    intCodigo				= Trim(Request.Form("txtCodigo"))
    intCodModulo 			= Trim(Request.Form("cmbModulo"))
	strTitulo 				= Trim(Request.Form("txtTitulo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strLinkTela 			= Trim(Request.Form("txtLinkTela"))
	strLinkVideo 			= Trim(Request.Form("txtLinkVideo"))
	strSituacao 			= Trim(Request.Form("cmbSituacao"))

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Registro Incluído com sucesso"
		
		sql = "SELECT max(Codigo) as Codigo From Help_Sistema"  
		rs.open sql,cnn
		
		if rs.eof = false then
			if isnull(rs("Codigo")) = false then
				intCodigo = cint(rs("Codigo")) + 1
			else
				intCodigo = 1
			end if
		else
			intCodigo = 1
		end if		
		rs.close	

		sql = " Insert into Help_Sistema (Codigo, CodModulo, Titulo, Descricao, LinkTela, LinkVideo, Situacao)" 
		sql = sql & " VALUES ("
		
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & intCodModulo & "',"
		
		if 	strTitulo 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strTitulo & "',"
		end if
		
		if 	strDescricao 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDescricao & "',"
		end if
		
		if 	strLinkTela 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strLinkTela & "',"
		end if
		
		if 	strLinkVideo 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strLinkVideo & "',"
		end if
		
		sql = sql & "'" & strSituacao & "')"
		
	elseif strAcao = "A"then
	
		strMensagem = "Registro Alterado com sucesso!"

		sql = "Update Help_Sistema set"
		sql = sql & " CodModulo = " & intCodModulo & ","
		
		if 	strTitulo = "" then
			sql = sql & " Titulo = NULL "
		else
			sql = sql & " Titulo = '" & strTitulo & "',"
		end if
		
		if 	strDescricao = "" then
			sql = sql & " Descricao = NULL "
		else
			sql = sql & " Descricao = '" & strDescricao & "',"
		end if
		
		if 	strLinkTela = "" then
			sql = sql & " LinkTela = NULL "
		else
			sql = sql & " LinkTela = '" & strLinkTela & "',"
		end if
		
		if 	strLinkVideo = "" then
			sql = sql & " LinkVideo = NULL "
		else
			sql = sql & " LinkVideo = '" & strLinkVideo & "',"
		end if

		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " Where codigo = " & intCodigo
		
			
	elseif strAcao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso"
		
		sql = "Delete From Help_Sistema"
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