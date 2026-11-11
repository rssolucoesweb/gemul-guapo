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
	strCodigoOrigem			= Trim(Request.Form("txtCodigoOrigem"))
	intCodEmpresa			= Trim(Request.Form("cmbEmpresa"))
	intCodLocal				= Trim(Request.Form("cmbLocal"))
	intCodColaborador		= Trim(Request.Form("cmbColaborador"))
	intCodTipoBem			= Trim(Request.Form("cmbTipoBem"))
	intCodSituacao			= Trim(Request.Form("cmbSituacao"))
	intCodEstadoConservacao	= Trim(Request.Form("cmbEstadoConservacao"))
	strDescricao			= Trim(Request.Form("txtDescricao"))
	strMarca				= Trim(Request.Form("txtMarca"))
	strModelo				= Trim(Request.Form("txtModelo"))
	strNumeroSerie			= Trim(Request.Form("txtNumeroSerie"))
	intQuantidade			= Trim(Request.Form("txtQuantidade"))
	strNumerosSerieLote		= Trim(Request.Form("txtNumerosSerieLote"))
	strCodigoBarras			= Trim(Request.Form("txtCodigoBarras"))
	strDataAquisicao		= Trim(Request.Form("txtDataAquisicao"))
	strNumeroNotaFiscal		= Trim(Request.Form("txtNumeroNotaFiscal"))
	strFornecedorNome		= Trim(Request.Form("txtFornecedorNome"))
	strValorAquisicao		= Trim(Request.Form("txtValorAquisicao"))
	strObservacao			= Trim(Request.Form("txtObservacao"))

	strUsuario = session("UsuarioWeb")

	if intCodColaborador = "" then intCodColaborador = "NULL"
	if intCodEstadoConservacao = "" then intCodEstadoConservacao = "NULL"
	if strCodigoOrigem = "" then strCodigoOrigemSQL = "NULL" else strCodigoOrigemSQL = "'" & strCodigoOrigem & "'"
	if strCodigoBarras = "" then strCodigoBarrasSQL = "NULL" else strCodigoBarrasSQL = "'" & strCodigoBarras & "'"
	if strNumeroNotaFiscal = "" then strNumeroNotaFiscalSQL = "NULL" else strNumeroNotaFiscalSQL = "'" & strNumeroNotaFiscal & "'"
	if strFornecedorNome = "" then strFornecedorNomeSQL = "NULL" else strFornecedorNomeSQL = "'" & strFornecedorNome & "'"
	if strObservacao = "" then strObservacaoSQL = "NULL" else strObservacaoSQL = "'" & strObservacao & "'"
	if strValorAquisicao = "" then
		strValorAquisicao = "NULL"
	else
		strValorAquisicao = Replace(strValorAquisicao, ",", ".")
	end if
	if strDataAquisicao = "" then
		strDataAquisicaoSQL = "NULL"
	else
		strDataAquisicaoSQL = "'" & strDataAquisicao & "'"
	end if

	if acao="I" then

		'------------------------------------------------------------
		' Cadastro em lote: 1 ou mais unidades idênticas (ex: 10 mesas)
		'------------------------------------------------------------
		if intQuantidade = "" then intQuantidade = 1
		intQuantidade = CInt(intQuantidade)

		' Quebra a lista de números de série em um array (um por linha), se informada
		Dim arrSeries, blnUsarSeriesLote
		strNumerosSerieLote = Replace(strNumerosSerieLote, vbCrLf, vbLf)
		arrSeries = Split(strNumerosSerieLote, vbLf)
		blnUsarSeriesLote = False
		if strNumerosSerieLote <> "" then
			if UBound(arrSeries) + 1 = intQuantidade then
				blnUsarSeriesLote = True
			else
				cnn.rollbacktrans
				%><script>alert("A quantidade de linhas em 'Números de Série' (<%=UBound(arrSeries)+1%>) não bate com a Quantidade informada (<%=intQuantidade%>)."); window.history.back();</script><%
				response.end
			end if
		end if

		strPrimeiroNumero = ""
		strUltimoNumero = ""

		for i = 1 to intQuantidade

			'--------------------------------------------------------
			' Gera o número de patrimônio via stored procedure
			' (ano + sequencial, ex: 2026000123)
			'--------------------------------------------------------
			Dim cmdNumero, strNumeroPatrimonio
			Set cmdNumero = Server.CreateObject("ADODB.Command")
			cmdNumero.ActiveConnection = cnn
			cmdNumero.CommandType = 4 ' adCmdStoredProc
			cmdNumero.CommandText = "SP_PAT_PROXIMO_NUMERO_PATRIMONIO"
			cmdNumero.Parameters.Append cmdNumero.CreateParameter("@numero_patrimonio", 200, 2, 20) ' adVarChar, adParamOutput
			cmdNumero.Execute
			strNumeroPatrimonio = cmdNumero.Parameters("@numero_patrimonio").Value
			Set cmdNumero = Nothing

			if i = 1 then strPrimeiroNumero = strNumeroPatrimonio
			strUltimoNumero = strNumeroPatrimonio

			' Número de série desta unidade: vem da lista em lote (se houver) ou do campo único (só faz sentido se quantidade=1)
			strNumeroSerieItem = strNumeroSerie
			if blnUsarSeriesLote then strNumeroSerieItem = Trim(arrSeries(i-1))

			sql = "Insert Into PAT_PATRIMONIO(numero_patrimonio, codigo_origem, cod_empresa, cod_local,"
			sql = sql & " cod_colaborador, cod_tipo_bem, cod_situacao, cod_estado_conservacao, descricao,"
			sql = sql & " marca, modelo, numero_serie, codigo_barras, data_aquisicao, numero_nota_fiscal,"
			sql = sql & " fornecedor_nome, valor_aquisicao, observacao, usuario_incl)"
			sql = sql & " Values ("
			sql = sql & "'" & strNumeroPatrimonio & "',"
			sql = sql & strCodigoOrigemSQL & ","
			sql = sql & intCodEmpresa & ","
			sql = sql & intCodLocal & ","
			sql = sql & intCodColaborador & ","
			sql = sql & intCodTipoBem & ","
			sql = sql & intCodSituacao & ","
			sql = sql & intCodEstadoConservacao & ","
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'" & strMarca & "',"
			sql = sql & "'" & strModelo & "',"
			sql = sql & "'" & strNumeroSerieItem & "',"
			sql = sql & strCodigoBarrasSQL & ","
			sql = sql & strDataAquisicaoSQL & ","
			sql = sql & strNumeroNotaFiscalSQL & ","
			sql = sql & strFornecedorNomeSQL & ","
			sql = sql & strValorAquisicao & ","
			sql = sql & strObservacaoSQL & ","
			sql = sql & "'" & strUsuario & "')"
			cnn.execute sql
			GravarLog sql

			'----------------------------------------------------
			' Registra o cadastro no histórico (PAT_HISTORICO)
			'----------------------------------------------------
			sql = "SELECT codigo FROM PAT_PATRIMONIO WHERE numero_patrimonio = '" & strNumeroPatrimonio & "'"
			rs.open sql, cnn
			if rs.eof = false then
				intCodigoNovoBem = rs("codigo")
			end if
			rs.close

			sql = "Insert Into PAT_HISTORICO(cod_patrimonio, tipo_evento, descricao, usuario)"
			sql = sql & " Values ("
			sql = sql & intCodigoNovoBem & ","
			sql = sql & "'CADASTRO',"
			sql = sql & "'Cadastro inicial do bem patrimonial " & strNumeroPatrimonio & "',"
			sql = sql & "'" & strUsuario & "')"
			cnn.execute sql

		next

		if intQuantidade = 1 then
			strMensagem = "Registro Salvo com sucesso..."
		else
			strMensagem = intQuantidade & " bens cadastrados com sucesso, numerados de " & strPrimeiroNumero & " a " & strUltimoNumero & "."
		end if

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update PAT_PATRIMONIO Set"
		sql = sql & " codigo_origem = " & strCodigoOrigemSQL & ","
		sql = sql & " cod_empresa = " & intCodEmpresa & ","
		sql = sql & " cod_local = " & intCodLocal & ","
		sql = sql & " cod_colaborador = " & intCodColaborador & ","
		sql = sql & " cod_tipo_bem = " & intCodTipoBem & ","
		sql = sql & " cod_situacao = " & intCodSituacao & ","
		sql = sql & " cod_estado_conservacao = " & intCodEstadoConservacao & ","
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " marca = '" & strMarca & "',"
		sql = sql & " modelo = '" & strModelo & "',"
		sql = sql & " numero_serie = '" & strNumeroSerie & "',"
		sql = sql & " codigo_barras = " & strCodigoBarrasSQL & ","
		sql = sql & " data_aquisicao = " & strDataAquisicaoSQL & ","
		sql = sql & " numero_nota_fiscal = " & strNumeroNotaFiscalSQL & ","
		sql = sql & " fornecedor_nome = " & strFornecedorNomeSQL & ","
		sql = sql & " valor_aquisicao = " & strValorAquisicao & ","
		sql = sql & " observacao = " & strObservacaoSQL & ","
		sql = sql & " usuario_altr = '" & strUsuario & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql

		sql = "Insert Into PAT_HISTORICO(cod_patrimonio, tipo_evento, descricao, usuario)"
		sql = sql & " Values ("
		sql = sql & intCodigo & ","
		sql = sql & "'ALTERACAO_CADASTRAL',"
		sql = sql & "'Alteração dos dados cadastrais do bem',"
		sql = sql & "'" & strUsuario & "')"
		cnn.execute sql
		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from PAT_PATRIMONIO "
		sql = sql & " where codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='pat_patrimonio.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.\n\nObs: se o bem tiver movimentações, manutenções, transferências ou baixa registrada, não pode ser excluído.");
			window.history.back();
		</script>
		<%
	end if
%>
