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
	strDataBaixa			= Trim(Request.Form("txtDataBaixa"))
	strTipoBaixa			= Trim(Request.Form("cmbTipoBaixa"))
	strMotivo				= Trim(Request.Form("txtMotivo"))
	strNumeroProcesso		= Trim(Request.Form("txtNumeroProcesso"))
	strDocumentoReferencia	= Trim(Request.Form("txtDocumentoReferencia"))
	strObservacao			= Trim(Request.Form("txtObservacao"))

	strUsuario = session("UsuarioWeb")

	if strDataBaixa = "" then strDataBaixa = FormatDateTime(Now(), 2)
	strNumeroProcessoSQL = "NULL" : if strNumeroProcesso <> "" then strNumeroProcessoSQL = "'" & strNumeroProcesso & "'"
	strDocRefSQL = "NULL" : if strDocumentoReferencia <> "" then strDocRefSQL = "'" & strDocumentoReferencia & "'"
	strMotivoSQL = "NULL" : if strMotivo <> "" then strMotivoSQL = "'" & strMotivo & "'"
	strObservacaoSQL = "NULL" : if strObservacao <> "" then strObservacaoSQL = "'" & strObservacao & "'"

	if acao="I" then
		
		' Busca o bem pelo número de patrimônio
		sql = "SELECT p.codigo, s.indicador_baixado"
		sql = sql & " FROM PAT_PATRIMONIO p"
		sql = sql & " INNER JOIN PAT_SITUACAO s ON s.codigo = p.cod_situacao"
		sql = sql & " WHERE p.numero_patrimonio = '" & Replace(strNumeroPatrimonio, "'", "''") & "'"
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Bem patrimonial não encontrado para o número informado."); window.history.back();</script><%
			response.end
		end if
		intCodPatrimonio = rs("codigo")
		blnJaBaixado = rs("indicador_baixado")
		rs.close

		if blnJaBaixado = true then
			cnn.rollbacktrans
			%><script>alert("Este bem já está baixado."); window.history.back();</script><%
			response.end
		end if

		strMensagem = "Baixa registrada com sucesso. Revise os dados e clique em Efetivar Baixa quando confirmado."
		sql = "Insert Into PAT_BAIXA(cod_patrimonio, data_baixa, tipo_baixa, motivo, numero_processo,"
		sql = sql & " documento_referencia, observacao, situacao, usuario_incl)"
		sql = sql & " Values ("
		sql = sql & intCodPatrimonio & ","
		sql = sql & "'" & strDataBaixa & "',"
		sql = sql & "'" & strTipoBaixa & "',"
		sql = sql & strMotivoSQL & ","
		sql = sql & strNumeroProcessoSQL & ","
		sql = sql & strDocRefSQL & ","
		sql = sql & strObservacaoSQL & ","
		sql = sql & "'EM_ELABORACAO',"
		sql = sql & "'" & strUsuario & "')"
		cnn.execute sql
		GravarLog sql

		sql = "SELECT SCOPE_IDENTITY() AS novo_id"
		rs.open sql, cnn
		intCodigoNovo = rs("novo_id")
		rs.close

	elseif acao="A" then
		
		strMensagem = "Baixa atualizada com sucesso..."
		sql = "Update PAT_BAIXA Set"
		sql = sql & " data_baixa = '" & strDataBaixa & "',"
		sql = sql & " tipo_baixa = '" & strTipoBaixa & "',"
		sql = sql & " motivo = " & strMotivoSQL & ","
		sql = sql & " numero_processo = " & strNumeroProcessoSQL & ","
		sql = sql & " documento_referencia = " & strDocRefSQL & ","
		sql = sql & " observacao = " & strObservacaoSQL
		sql = sql & " where codigo = " & intCodigo & " and situacao = 'EM_ELABORACAO'"
		cnn.execute sql
		GravarLog sql
		intCodigoNovo = intCodigo
		
	elseif acao="E" then
	
		strMensagem = "Baixa excluída com sucesso..."
		sql = "Delete from PAT_BAIXA "
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
			window.location='pat_baixa.asp';
			<%else%>
			window.location='pat_baixa.asp?cod=<%=intCodigoNovo%>';
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
