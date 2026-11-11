	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 02/02/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Serviço
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	intCodGrupo			= session("CodGrupo")
	strServico		 	= Trim(Request.Form("txtServico"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCH_TIPOSERVICO(cod_grupo, Nome)"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strServico & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCH_TIPOSERVICO Set"
		sql = sql & " Nome = '" & strServico & "'"
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " And cod_grupo = " & intCodGrupo
		
	else

		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCH_TIPOSERVICO "
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " And cod_grupo = " & intCodGrupo
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Servico_cad.asp';
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