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
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodigo			= Trim(Request.Form("txtCodigo"))
	intCodGrupo			= Trim(Request.Form("cmdGrupo"))
	intCodPerfil		= Trim(Request.Form("cmbPerfil"))
	
	if acao="I" then
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SEG_PERFIL_GRUPO (cod_grupo, cod_perfis_sistema)"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "" & intCodPerfil & ")"
		cnn.execute sql

	elseif acao="A" then
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SEG_PERFIL_GRUPO "
		sql = sql & " Where Codigo = " & intCodigo
		cnn.execute sql
	end if
	
	
	GravarLog sql
	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PerfilGrupo_cad.asp?cmdGrupo=<%=intCodGrupo%>';
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