<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 15/11/2013
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Modulação
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	strAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	
	intCodColaborador			= Trim(Request.Form("txtCodFuncionario"))
	intCodEmpresaGrupo			= Trim(Request.Form("cmbEmpresaGrupo"))

	strTipoLancamento 			= Trim(Request.Form("optTipoLancamento"))
	strTipoModulacao 			= Trim(Request.Form("optTipoModulacao"))
	intTotalAulas 				= Trim(Request.Form("txtTotalAulas"))
	if strTipoModulacao = "FUNCIONARIO" then intTotalAulas = "1"
	strSituacao					= Trim(Request.Form("cmbSituacao"))	
	strTipoContratacao			= Trim(Request.Form("tipoContratacao"))	
	strPorPeriodo 				= Trim(Request.Form("PorPeriodo"))
	
	strPeriodoFinal				= formatadataBD(Trim(Request.Form("txtPeriodoFinal")))	
	if strPeriodoFinal = "" then strPeriodoFinal = formatadataBD(date)
	
	strDataFinal 				= formatadataBD(Trim(Request.Form("txtDataFinal")))	
	if strDataFinal = "" then strDataFinal = formatadataBD(date)
		
	if acao="I" then
		
		if cCur(formataDataCalc(strPeriodoFinal)) > cCur(formataDataCalc(date)) then strPeriodoFinal = formatadataBD(date)
		if cCur(formataDataCalc(strDataFinal)) > cCur(formataDataCalc(date)) then strDataFinal = formatadataBD(date)
		
		strMensagem = "Modulação Funcionario inativada com sucesso..."
		
		sql = "Update SRH_MODULACAO_DISCIPLINAR_DOCENTE Set"
		sql = sql & " DataFinal = '" & strDataFinal & "',"
		
		if strPeriodoFinal = "S" then
			sql = sql & "periodo_Final = '" & strPeriodoFinal & "',"
		end if
		
		sql = sql & " status = 'I'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " and Cod_Colaborador = " & intCodColaborador
		
		
		cnn.execute sql
		GravarLog sql

	end if	

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location="ModulacaoFuncionario_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
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