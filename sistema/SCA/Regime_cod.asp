<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strTipoSeriacao		= replace(replace(Trim(Request.Form("optTipo")),",","")," ","")
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_REGIME(COD_EMPRESA, DESC_REGIME, Tipo_Seriacao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strTipoSeriacao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_REGIME Set"
		sql = sql & " DESC_REGIME = '" & strDescricao & "',"
		sql = sql & " Tipo_Seriacao = '" & strTipoSeriacao & "'"
		sql = sql & " where COD_REGIME = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_REGIME "
		sql = sql & " where COD_REGIME = " & intCodigo
		
	end if
	cnn.execute sql
	GravarLog sql
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Regime_cad.asp';
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