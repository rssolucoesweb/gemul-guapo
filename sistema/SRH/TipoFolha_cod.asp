<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro da Folha
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodGrupo			= Session("CodGrupo")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSituacao 		= Trim(Request.Form("cmbSituacao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_TIPOFOLHA(Cod_grupo, Descricao, Situacao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strSituacao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_TIPOFOLHA Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_TIPOFOLHA "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo

	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TipoFolha_cad.asp';
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