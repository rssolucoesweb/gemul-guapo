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
	strPeriodoFinal				= formatadataBD(Trim(Request.Form("txtPeriodoFinal")))	
	if strPeriodoFinal = "" then strPeriodoFinal = formatadataBD(date)
	
	strDataFinal 				= formatadataBD(Trim(Request.Form("txtDataFinal")))	
	if strDataFinal = "" then strDataFinal = formatadataBD(date)
	
	if Trim(intCodColaborador) <> "" then
	
		sql = "SELECT codigo_SEG_USUARIOS_SISTEMA "
		sql = sql & " FROM 	SRH_COLABORADOR C "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " Where C.Codigo = " & intCodColaborador
		sql = sql & " and E.COD_GRUPO = " & session("codGrupo")
		rs.open sql, cnn
		if rs.eof = false then
			strUsuarioPortal	= Trim(Rs("codigo_SEG_USUARIOS_SISTEMA"))
		end if
		rs.close
	end if
	
		
	if acao="I" then
		
		if cCur(formataDataCalc(strPeriodoFinal)) > cCur(formataDataCalc(date)) then strPeriodoFinal = formatadataBD(date)
		if cCur(formataDataCalc(strDataFinal)) > cCur(formataDataCalc(date)) then strDataFinal = formatadataBD(date)
		
		strMensagem = "Registro inativada com sucesso..."
		
		sql = "Update SRH_MODULACAO_DISCIPLINAR_DOCENTE Set"
		sql = sql & " DataFinal = '" & strDataFinal & "',"
		sql = sql & "periodo_Final = '" & strPeriodoFinal & "',"
		sql = sql & " status = 'I'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " and Cod_Colaborador = " & intCodColaborador
		cnn.execute sql
		GravarLog sql
		
		
		sql = " Delete from SEG_USUARIOS_EMPRESA "
		sql = sql & " Where CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
		sql = sql & " And COD_EMPRESA = '" & intCodEmpresaGrupo & "'"
		cnn.execute sql
		GravarLog sql

	end if	

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
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