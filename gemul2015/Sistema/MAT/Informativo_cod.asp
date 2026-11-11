<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 2/04/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Ata
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodGrupo	 			= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodTipoEmpresa		= Trim(Request("cmbTipoEmpresa"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDados 				= Trim(Request.Form("txtDados"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into MAT_Dados( Cod_grupo, CodTipoEmpresa, Descricao, Dados)"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "" & intCodTipoEmpresa & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strDados & "')"
		cnn.execute sql

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update MAT_Dados Set"
		sql = sql & " CodTipoEmpresa = " & intCodTipoEmpresa & ","
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Dados = '" & strDados & "'"
		sql = sql & " Where Cod_grupo = " & intCodGrupo
		sql = sql & " And Codigo = " & intCodigo
		cnn.execute sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From MAT_Dados "
		sql = sql & " Where Cod_grupo = " & intCodGrupo
		sql = sql & " And Codigo = " & intCodigo
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Informativo_cad.asp';
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