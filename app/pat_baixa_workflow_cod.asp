<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	acao = Trim(Request.QueryString("acao"))
	strUsuario = session("UsuarioWeb")

	' ================================================================
	' EFETIVAR BAIXA
	' ================================================================
	if acao = "Efetivar" then

		intCodigo = Trim(Request.QueryString("cod"))

		cnn.begintrans

		sql = "SELECT cod_patrimonio, situacao FROM PAT_BAIXA WHERE codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof or rs("situacao") <> "EM_ELABORACAO" then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Esta baixa não está mais em elaboração."); window.location='pat_baixa.asp?cod=<%=intCodigo%>';</script><%
			response.end
		end if
		intCodPatrimonio = rs("cod_patrimonio")
		rs.close

		' Confere se o bem já não foi baixado por outro processo nesse meio tempo
		sql = "SELECT cod_situacao, cod_estado_conservacao FROM PAT_PATRIMONIO WHERE codigo = " & intCodPatrimonio
		rs.open sql, cnn
		intCodSituacaoAtualBem = rs("cod_situacao")
		intCodEstadoAtualBem = rs("cod_estado_conservacao")
		rs.close

		sql = "SELECT TOP 1 codigo FROM PAT_SITUACAO WHERE indicador_baixado = 1 AND situacao = 'A'"
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Cadastre primeiro uma Situação com 'Indica Baixado' marcado, em Patrimônio > Situação do Patrimônio."); window.location='pat_baixa.asp?cod=<%=intCodigo%>';</script><%
			response.end
		end if
		intCodSituacaoBaixado = rs("codigo")
		rs.close

		strEstadoSQL = "NULL" : if not isnull(intCodEstadoAtualBem) then strEstadoSQL = intCodEstadoAtualBem

		' Grava o snapshot da situação anterior e do estado de conservação no momento da baixa
		sql = "Update PAT_BAIXA Set situacao = 'EFETIVADA', cod_situacao_anterior = " & intCodSituacaoAtualBem
		sql = sql & ", cod_estado_conservacao = " & strEstadoSQL
		sql = sql & ", usuario_efet = '" & strUsuario & "', data_hora_efet = GETDATE()"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql

		' Marca o bem como baixado
		sql = "Update PAT_PATRIMONIO Set cod_situacao = " & intCodSituacaoBaixado
		sql = sql & ", usuario_altr = '" & strUsuario & "', data_hora_altr = GETDATE()"
		sql = sql & " where codigo = " & intCodPatrimonio
		cnn.execute sql

		sql = "Insert Into PAT_HISTORICO(cod_patrimonio, tipo_evento, descricao, entidade_origem, codigo_origem, usuario)"
		sql = sql & " Values (" & intCodPatrimonio & ",'BAIXA','Baixa efetivada','PAT_BAIXA'," & intCodigo & ",'" & strUsuario & "')"
		cnn.execute sql

		if err.number = 0 then
			cnn.committrans
			%><script>alert("Baixa efetivada com sucesso. O bem foi marcado como baixado."); window.location='pat_baixa.asp?cod=<%=intCodigo%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("ATENÇÃO: Não foi possível efetivar a baixa (pode já existir uma baixa efetivada para este bem). Nenhuma alteração foi salva."); window.location='pat_baixa.asp?cod=<%=intCodigo%>';</script><%
		end if
		response.end

	' ================================================================
	' CANCELAR (somente enquanto Em Elaboração - nada foi alterado no bem ainda)
	' ================================================================
	elseif acao = "Cancelar" then

		intCodigo = Trim(Request.Form("cod_baixa"))
		strMotivoCancelamento = Trim(Request.Form("motivo_cancelamento"))

		cnn.begintrans

		sql = "Update PAT_BAIXA Set situacao = 'CANCELADA', usuario_canc = '" & strUsuario & "',"
		sql = sql & " data_hora_canc = GETDATE(), motivo_cancelamento = '" & Replace(strMotivoCancelamento, "'", "''") & "'"
		sql = sql & " where codigo = " & intCodigo & " and situacao = 'EM_ELABORACAO'"
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>alert("Baixa cancelada."); window.location='pat_baixa.asp?cod=<%=intCodigo%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível cancelar a baixa."); window.location='pat_baixa.asp?cod=<%=intCodigo%>';</script><%
		end if
		response.end

	end if
%>
