<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDataInicial					= formataDataBD(Trim(Request.Form("txtDataInicio")))
	strDataFinal					= formataDataBD(Trim(Request.Form("txtDataFim")))
	intCodCriterio 		= Trim(Request.Form("cmbCriterio"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	strPeriodo 			=  strDataInicial & " a " & strDataFinal
	if acao="I" then
	
		'VERIFICA DATA
		SQL = "select CODIGO"
		SQL = SQL & " from SCA_BIMESTRE "
		SQL = SQL & " WHERE DESCRICAO = '" & strDescricao & "'"
		SQL = SQL & " AND ANO_LETIVO = " & strAnoLetivo
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			RS.CLOSE
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENǃO: Bimestre já existe para esse ano.");
				window.location='sca_bimestre.asp';
			</script>
			<%
			RESPONSE.End()
		ELSE
			RS.CLOSE
		END IF
	
		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_BIMESTRE(ANO_LETIVO, SEMESTRE, COD_CRITERIO, DESCRICAO, PERIODO, DATA_INICIO, DATA_FIM, USUARIO_INCL, DATA_HORA_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & intCodCriterio & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strPeriodo & "',"
		sql = sql & "'" & strDataInicial & "',"
		sql = sql & "'" & strDataFinal & "',"
		sql = sql & "'" & SESSION("USUARIOWEB") & "',"
		sql = sql & "GETDATE())"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_BIMESTRE Set"
		sql = sql & " COD_CRITERIO = " & intCodCriterio & ","
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " PERIODO = '" & strPeriodo & "',"
		sql = sql & " DATA_INICIO = '" & strDataInicial & "',"
		sql = sql & " DATA_FIM = '" & strDataFinal & "',"
		sql = sql & " USUARIO_ALTR = '" & SESSION("USUARIOWEB") & "',"
		sql = sql & " DATA_HORA_ALTR = GETDATE()"
		sql = sql & " where CODIGO = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_BIMESTRE "
		sql = sql & " where CODIGO = " & intCodigo
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_bimestre.asp';
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