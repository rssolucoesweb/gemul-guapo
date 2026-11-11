<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intAnoReferencia		= Trim(Request.Form("txtAnoReferencia"))
	intCodEmpresa			= Trim(Request.Form("cmbEmpresa"))
	intCodLocal				= Trim(Request.Form("cmbLocal"))
	strDataInicio			= Trim(Request.Form("txtDataInicio"))
	intCodColaboradorResp	= Trim(Request.Form("cmbColaboradorResponsavel"))
	strObservacao			= Trim(Request.Form("txtObservacao"))

	strUsuario = session("UsuarioWeb")

	if intAnoReferencia = "" then intAnoReferencia = Year(Now())
	if strDataInicio = "" then strDataInicio = FormatDateTime(Now(), 2)
	intCodLocalSQL = "NULL" : if intCodLocal <> "" then intCodLocalSQL = intCodLocal
	intCodColaboradorRespSQL = "NULL" : if intCodColaboradorResp <> "" then intCodColaboradorRespSQL = intCodColaboradorResp
	strObservacaoSQL = "NULL" : if strObservacao <> "" then strObservacaoSQL = "'" & strObservacao & "'"

	if acao="I" then
		
		strMensagem = "Inventário criado com sucesso. Clique em 'Gerar Itens' para começar."

		Dim cmdNumero, strNumeroInventario
		Set cmdNumero = Server.CreateObject("ADODB.Command")
		cmdNumero.ActiveConnection = cnn
		cmdNumero.CommandType = 4 ' adCmdStoredProc
		cmdNumero.CommandText = "SP_PAT_PROXIMO_NUMERO_INVENTARIO"
		cmdNumero.Parameters.Append cmdNumero.CreateParameter("@numero_inventario", 200, 2, 20) ' adVarChar, adParamOutput
		cmdNumero.Execute
		strNumeroInventario = cmdNumero.Parameters("@numero_inventario").Value
		Set cmdNumero = Nothing

		sql = "Insert Into PAT_INVENTARIO(numero_inventario, ano_referencia, cod_empresa, cod_local,"
		sql = sql & " data_inicio, cod_colaborador_responsavel, observacao, situacao, usuario_incl)"
		sql = sql & " Values ("
		sql = sql & "'" & strNumeroInventario & "',"
		sql = sql & intAnoReferencia & ","
		sql = sql & intCodEmpresa & ","
		sql = sql & intCodLocalSQL & ","
		sql = sql & "'" & strDataInicio & "',"
		sql = sql & intCodColaboradorRespSQL & ","
		sql = sql & strObservacaoSQL & ","
		sql = sql & "'ABERTO',"
		sql = sql & "'" & strUsuario & "')"
		cnn.execute sql
		GravarLog sql

		sql = "SELECT SCOPE_IDENTITY() AS novo_id"
		rs.open sql, cnn
		intCodigoNovo = rs("novo_id")
		rs.close

	elseif acao="A" then
		
		strMensagem = "Inventário atualizado com sucesso..."
		sql = "Update PAT_INVENTARIO Set"
		sql = sql & " ano_referencia = " & intAnoReferencia & ","
		sql = sql & " cod_empresa = " & intCodEmpresa & ","
		sql = sql & " cod_local = " & intCodLocalSQL & ","
		sql = sql & " data_inicio = '" & strDataInicio & "',"
		sql = sql & " cod_colaborador_responsavel = " & intCodColaboradorRespSQL & ","
		sql = sql & " observacao = " & strObservacaoSQL
		sql = sql & " where codigo = " & intCodigo & " and situacao = 'ABERTO'"
		cnn.execute sql
		GravarLog sql
		intCodigoNovo = intCodigo
		
	elseif acao="E" then
	
		strMensagem = "Inventário excluído com sucesso..."
		sql = "Delete from PAT_INVENTARIO "
		sql = sql & " where codigo = " & intCodigo & " and situacao = 'ABERTO'"

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			<%if acao = "E" then%>
			window.location='pat_inventario.asp';
			<%else%>
			window.location='pat_inventario.asp?cod=<%=intCodigoNovo%>';
			<%end if%>
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
