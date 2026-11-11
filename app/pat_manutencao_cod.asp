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
	strNumeroPatrimonio		= Trim(Request.Form("txtNumeroPatrimonio"))
	strNumeroOrdemServico	= Trim(Request.Form("txtNumeroOrdemServico"))
	strTipoManutencao		= Trim(Request.Form("cmbTipoManutencao"))
	strDataSolicitacao		= Trim(Request.Form("txtDataSolicitacao"))
	strDataEnvio			= Trim(Request.Form("txtDataEnvio"))
	strDataPrevistaRetorno	= Trim(Request.Form("txtDataPrevistaRetorno"))
	strDataRetorno			= Trim(Request.Form("txtDataRetorno"))
	strProblema				= Trim(Request.Form("txtProblema"))
	strServicoRealizado		= Trim(Request.Form("txtServicoRealizado"))
	strPrestadorNome		= Trim(Request.Form("txtPrestadorNome"))
	strNumeroOrcamento		= Trim(Request.Form("txtNumeroOrcamento"))
	strValorOrcamento		= Trim(Request.Form("txtValorOrcamento"))
	strValorServico			= Trim(Request.Form("txtValorServico"))
	strObservacao			= Trim(Request.Form("txtObservacao"))

	strUsuario = session("UsuarioWeb")

	if strDataSolicitacao = "" then strDataSolicitacao = FormatDateTime(Now(), 2)

	strDataEnvioSQL = "NULL" : if strDataEnvio <> "" then strDataEnvioSQL = "'" & strDataEnvio & "'"
	strDataPrevistaSQL = "NULL" : if strDataPrevistaRetorno <> "" then strDataPrevistaSQL = "'" & strDataPrevistaRetorno & "'"
	strDataRetornoSQL = "NULL" : if strDataRetorno <> "" then strDataRetornoSQL = "'" & strDataRetorno & "'"
	strPrestadorSQL = "NULL" : if strPrestadorNome <> "" then strPrestadorSQL = "'" & strPrestadorNome & "'"
	strOrcamentoNumSQL = "NULL" : if strNumeroOrcamento <> "" then strOrcamentoNumSQL = "'" & strNumeroOrcamento & "'"
	strOrcamentoValSQL = "NULL" : if strValorOrcamento <> "" then strOrcamentoValSQL = Replace(strValorOrcamento, ",", ".")
	strServicoValSQL = "NULL" : if strValorServico <> "" then strServicoValSQL = Replace(strValorServico, ",", ".")
	strServicoRealizadoSQL = "NULL" : if strServicoRealizado <> "" then strServicoRealizadoSQL = "'" & strServicoRealizado & "'"
	strObservacaoSQL = "NULL" : if strObservacao <> "" then strObservacaoSQL = "'" & strObservacao & "'"

	if acao="I" then
		
		' Busca o bem pelo número de patrimônio
		sql = "SELECT codigo FROM PAT_PATRIMONIO WHERE numero_patrimonio = '" & Replace(strNumeroPatrimonio, "'", "''") & "'"
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Bem patrimonial não encontrado para o número informado."); window.history.back();</script><%
			response.end
		end if
		intCodPatrimonio = rs("codigo")
		rs.close

		strMensagem = "Manutenção registrada com sucesso..."
		sql = "Insert Into PAT_MANUTENCAO(cod_patrimonio, numero_ordem_servico, tipo_manutencao, data_solicitacao,"
		sql = sql & " problema, situacao, usuario_incl)"
		sql = sql & " Values ("
		sql = sql & intCodPatrimonio & ","
		sql = sql & "'" & strNumeroOrdemServico & "',"
		sql = sql & "'" & strTipoManutencao & "',"
		sql = sql & "'" & strDataSolicitacao & "',"
		sql = sql & "'" & strProblema & "',"
		sql = sql & "'AGUARDANDO_ORCAMENTO',"
		sql = sql & "'" & strUsuario & "')"
		cnn.execute sql
		GravarLog sql

		sql = "SELECT SCOPE_IDENTITY() AS novo_id"
		rs.open sql, cnn
		intCodigoNovo = rs("novo_id")
		rs.close

	elseif acao="A" then
		
		strMensagem = "Manutenção atualizada com sucesso..."
		sql = "Update PAT_MANUTENCAO Set"
		sql = sql & " numero_ordem_servico = '" & strNumeroOrdemServico & "',"
		sql = sql & " tipo_manutencao = '" & strTipoManutencao & "',"
		sql = sql & " data_solicitacao = '" & strDataSolicitacao & "',"
		sql = sql & " problema = '" & strProblema & "',"
		sql = sql & " prestador_nome = " & strPrestadorSQL & ","
		sql = sql & " numero_orcamento = " & strOrcamentoNumSQL & ","
		sql = sql & " valor_orcamento = " & strOrcamentoValSQL & ","
		sql = sql & " valor_servico = " & strServicoValSQL & ","
		sql = sql & " data_envio = " & strDataEnvioSQL & ","
		sql = sql & " data_prevista_retorno = " & strDataPrevistaSQL & ","
		sql = sql & " data_retorno = " & strDataRetornoSQL & ","
		sql = sql & " servico_realizado = " & strServicoRealizadoSQL & ","
		sql = sql & " observacao = " & strObservacaoSQL & ","
		sql = sql & " usuario_altr = '" & strUsuario & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and situacao not in ('CONCLUIDA','NAO_REPARAVEL','CANCELADA')"
		cnn.execute sql
		GravarLog sql
		intCodigoNovo = intCodigo
		
	elseif acao="E" then
	
		strMensagem = "Manutenção excluída com sucesso..."
		sql = "Delete from PAT_MANUTENCAO "
		sql = sql & " where codigo = " & intCodigo & " and situacao = 'AGUARDANDO_ORCAMENTO'"

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			<%if acao = "E" then%>
			window.location='pat_manutencao.asp';
			<%else%>
			window.location='pat_manutencao.asp?cod=<%=intCodigoNovo%>';
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
