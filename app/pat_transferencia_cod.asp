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
	strDataTransferencia	= Trim(Request.Form("txtDataTransferencia"))
	intCodEmpresaOrigem	= Trim(Request.Form("cmbEmpresaOrigem"))
	intCodEmpresaDestino	= Trim(Request.Form("cmbEmpresaDestino"))
	intCodLocalDestino		= Trim(Request.Form("cmbLocalDestino"))
	intCodColaboradorDestino = Trim(Request.Form("cmbColaboradorDestino"))
	strMotivo				= Trim(Request.Form("txtMotivo"))
	strObservacao			= Trim(Request.Form("txtObservacao"))

	strUsuario = session("UsuarioWeb")

	if intCodLocalDestino = "" then intCodLocalDestino = "NULL"
	if intCodColaboradorDestino = "" then intCodColaboradorDestino = "NULL"
	if strDataTransferencia = "" then strDataTransferencia = FormatDateTime(Now(), 2)

	if acao="I" then
		
		strMensagem = "Transferência iniciada com sucesso. Adicione os itens abaixo..."

		'------------------------------------------------------------
		' Gera o número da transferência via stored procedure
		'------------------------------------------------------------
		Dim cmdNumero, strNumeroTransferencia
		Set cmdNumero = Server.CreateObject("ADODB.Command")
		cmdNumero.ActiveConnection = cnn
		cmdNumero.CommandType = 4 ' adCmdStoredProc
		cmdNumero.CommandText = "SP_PAT_PROXIMO_NUMERO_TRANSFERENCIA"
		cmdNumero.Parameters.Append cmdNumero.CreateParameter("@numero_transferencia", 200, 2, 20) ' adVarChar, adParamOutput
		cmdNumero.Execute
		strNumeroTransferencia = cmdNumero.Parameters("@numero_transferencia").Value
		Set cmdNumero = Nothing

		sql = "Insert Into PAT_TRANSFERENCIA(numero_transferencia, data_transferencia, cod_empresa_origem,"
		sql = sql & " cod_empresa_destino, cod_local_destino, cod_colaborador_destino, motivo, observacao,"
		sql = sql & " situacao, usuario_incl)"
		sql = sql & " Values ("
		sql = sql & "'" & strNumeroTransferencia & "',"
		sql = sql & "'" & strDataTransferencia & "',"
		sql = sql & intCodEmpresaOrigem & ","
		sql = sql & intCodEmpresaDestino & ","
		sql = sql & intCodLocalDestino & ","
		sql = sql & intCodColaboradorDestino & ","
		sql = sql & "'" & strMotivo & "',"
		sql = sql & "'" & strObservacao & "',"
		sql = sql & "'EM_ELABORACAO',"
		sql = sql & "'" & strUsuario & "')"
		cnn.execute sql
		GravarLog sql

		' Recupera o código gerado pra já cair na tela de itens
		sql = "SELECT codigo FROM PAT_TRANSFERENCIA WHERE numero_transferencia = '" & strNumeroTransferencia & "'"
		rs.open sql, cnn
		intCodigoNovo = rs("codigo")
		rs.close

	elseif acao="A" then
		
		strMensagem = "Cabeçalho da transferência atualizado com sucesso..."
		sql = "Update PAT_TRANSFERENCIA Set"
		sql = sql & " data_transferencia = '" & strDataTransferencia & "',"
		sql = sql & " cod_empresa_origem = " & intCodEmpresaOrigem & ","
		sql = sql & " cod_empresa_destino = " & intCodEmpresaDestino & ","
		sql = sql & " cod_local_destino = " & intCodLocalDestino & ","
		sql = sql & " cod_colaborador_destino = " & intCodColaboradorDestino & ","
		sql = sql & " motivo = '" & strMotivo & "',"
		sql = sql & " observacao = '" & strObservacao & "'"
		sql = sql & " where codigo = " & intCodigo & " and situacao = 'EM_ELABORACAO'"
		cnn.execute sql
		GravarLog sql
		intCodigoNovo = intCodigo
		
	elseif acao="E" then
	
		strMensagem = "Transferência excluída com sucesso..."
		sql = "Delete from PAT_TRANSFERENCIA "
		sql = sql & " where codigo = " & intCodigo & " and situacao = 'EM_ELABORACAO'"

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			<%if acao = "E" then%>
			window.location='pat_transferencia.asp';
			<%else%>
			window.location='pat_transferencia.asp?cod=<%=intCodigoNovo%>';
			<%end if%>
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.\n\nObs: só é possível editar ou excluir transferências que ainda estão Em Elaboração.");
			window.history.back();
		</script>
		<%
	end if
%>
