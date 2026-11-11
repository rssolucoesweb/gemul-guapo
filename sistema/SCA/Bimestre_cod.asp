<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Feriado
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strPeriodo	 		= Trim(Request.Form("txtPeriodo"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
			
	if acao="I" then
		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_BIMESTRE(COD_EMPRESA, ANO_LETIVO, SEMESTRE, DESCRICAO, PERIODO)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strPeriodo & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_BIMESTRE Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " PERIODO = '" & strPeriodo & "'"
		sql = sql & " where CODIGO = " & intCodigo
		sql = sql & " and COD_EMPRESA = " & intCodEmp
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_BIMESTRE "
		sql = sql & " where CODIGO = " & intCodigo
		sql = sql & " and COD_EMPRESA = " & intCodEmp
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Bimestre_cad.asp';
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