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
	' AVANÇAR SITUAÇÃO (Registrar Orçamento / Autorizar / Enviar para
	' Manutenção / Concluir / Marcar Não Reparável)
	' ================================================================
	if acao = "Avancar" then

		intCodigo = Trim(Request.QueryString("cod"))
		strNovaSituacao = Trim(Request.QueryString("nova_situacao"))

		cnn.begintrans

		sql = "SELECT cod_patrimonio, situacao, cod_situacao_patrimonio_anterior, data_envio, data_retorno"
		sql = sql & " FROM PAT_MANUTENCAO WHERE codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Manutenção não encontrada."); window.history.back();</script><%
			response.end
		end if
		intCodPatrimonio = rs("cod_patrimonio")
		strSituacaoAtual = rs("situacao")
		intCodSituacaoAnterior = rs("cod_situacao_patrimonio_anterior")
		strDataEnvioAtual = rs("data_envio")
		strDataRetornoAtual = rs("data_retorno")
		rs.close

		if strSituacaoAtual = "CONCLUIDA" or strSituacaoAtual = "NAO_REPARAVEL" or strSituacaoAtual = "CANCELADA" then
			cnn.rollbacktrans
			%><script>alert("Esta manutenção já foi finalizada."); window.location='pat_manutencao.asp?cod=<%=intCodigo%>';</script><%
			response.end
		end if

		sqlUpdate = "Update PAT_MANUTENCAO Set situacao = '" & strNovaSituacao & "', usuario_altr = '" & strUsuario & "', data_hora_altr = GETDATE()"

		' Ao enviar para manutenção: guarda a situação atual do bem e move pra "Em Manutenção"
		if strNovaSituacao = "EM_MANUTENCAO" then

			sql = "SELECT TOP 1 codigo FROM PAT_SITUACAO WHERE descricao = 'EM_MANUTENCAO' AND situacao = 'A'"
			rs.open sql, cnn
			if rs.eof then
				rs.close
				cnn.rollbacktrans
				%><script>alert("Cadastre primeiro a Situação 'EM_MANUTENCAO' em Patrimônio > Situação do Patrimônio."); window.location='pat_manutencao.asp?cod=<%=intCodigo%>';</script><%
				response.end
			end if
			intCodSituacaoEmManutencao = rs("codigo")
			rs.close

			sql = "SELECT cod_situacao FROM PAT_PATRIMONIO WHERE codigo = " & intCodPatrimonio
			rs.open sql, cnn
			intCodSituacaoAtualBem = rs("cod_situacao")
			rs.close

			sqlUpdate = sqlUpdate & ", cod_situacao_patrimonio_anterior = " & intCodSituacaoAtualBem
			if isnull(strDataEnvioAtual) or strDataEnvioAtual = "" then
				sqlUpdate = sqlUpdate & ", data_envio = GETDATE()"
			end if

			sql = "Update PAT_PATRIMONIO Set cod_situacao = " & intCodSituacaoEmManutencao
			sql = sql & ", usuario_altr = '" & strUsuario & "', data_hora_altr = GETDATE()"
			sql = sql & " where codigo = " & intCodPatrimonio
			cnn.execute sql

			sql = "Insert Into PAT_HISTORICO(cod_patrimonio, tipo_evento, descricao, entidade_origem, codigo_origem, usuario)"
			sql = sql & " Values (" & intCodPatrimonio & ",'MANUTENCAO','Bem enviado para manutenção','PAT_MANUTENCAO'," & intCodigo & ",'" & strUsuario & "')"
			cnn.execute sql

		' Ao concluir ou marcar como não reparável: restaura a situação anterior do bem
		elseif strNovaSituacao = "CONCLUIDA" or strNovaSituacao = "NAO_REPARAVEL" then

			if not isnull(intCodSituacaoAnterior) then
				sql = "Update PAT_PATRIMONIO Set cod_situacao = " & intCodSituacaoAnterior
				sql = sql & ", usuario_altr = '" & strUsuario & "', data_hora_altr = GETDATE()"
				sql = sql & " where codigo = " & intCodPatrimonio
				cnn.execute sql
			end if

			if strNovaSituacao = "CONCLUIDA" then
				sqlUpdate = sqlUpdate & ", usuario_concl = '" & strUsuario & "', data_hora_concl = GETDATE()"
				if isnull(strDataRetornoAtual) or strDataRetornoAtual = "" then
					sqlUpdate = sqlUpdate & ", data_retorno = GETDATE()"
				end if
			end if

			strDescHist = "Manutenção concluída"
			if strNovaSituacao = "NAO_REPARAVEL" then strDescHist = "Bem marcado como não reparável durante manutenção"

			sql = "Insert Into PAT_HISTORICO(cod_patrimonio, tipo_evento, descricao, entidade_origem, codigo_origem, usuario)"
			sql = sql & " Values (" & intCodPatrimonio & ",'MANUTENCAO','" & strDescHist & "','PAT_MANUTENCAO'," & intCodigo & ",'" & strUsuario & "')"
			cnn.execute sql

		end if

		sqlUpdate = sqlUpdate & " where codigo = " & intCodigo
		cnn.execute sqlUpdate
		GravarLog sqlUpdate

		if err.number = 0 then
			cnn.committrans
			%><script>window.location='pat_manutencao.asp?cod=<%=intCodigo%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível atualizar a situação da manutenção."); window.location='pat_manutencao.asp?cod=<%=intCodigo%>';</script><%
		end if
		response.end

	' ================================================================
	' CANCELAR MANUTENÇÃO
	' ================================================================
	elseif acao = "Cancelar" then

		intCodigo = Trim(Request.Form("cod_manutencao"))
		strMotivoCancelamento = Trim(Request.Form("motivo_cancelamento"))

		cnn.begintrans

		sql = "SELECT cod_patrimonio, cod_situacao_patrimonio_anterior, situacao FROM PAT_MANUTENCAO WHERE codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Manutenção não encontrada."); window.history.back();</script><%
			response.end
		end if
		intCodPatrimonio = rs("cod_patrimonio")
		intCodSituacaoAnterior = rs("cod_situacao_patrimonio_anterior")
		strSituacaoAtual = rs("situacao")
		rs.close

		' Se o bem já estava marcado como "Em Manutenção", restaura a situação original
		if strSituacaoAtual = "EM_MANUTENCAO" and not isnull(intCodSituacaoAnterior) then
			sql = "Update PAT_PATRIMONIO Set cod_situacao = " & intCodSituacaoAnterior
			sql = sql & ", usuario_altr = '" & strUsuario & "', data_hora_altr = GETDATE()"
			sql = sql & " where codigo = " & intCodPatrimonio
			cnn.execute sql
		end if

		sql = "Update PAT_MANUTENCAO Set situacao = 'CANCELADA', usuario_canc = '" & strUsuario & "',"
		sql = sql & " data_hora_canc = GETDATE(), motivo_cancelamento = '" & Replace(strMotivoCancelamento, "'", "''") & "'"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>alert("Manutenção cancelada."); window.location='pat_manutencao.asp?cod=<%=intCodigo%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível cancelar a manutenção."); window.location='pat_manutencao.asp?cod=<%=intCodigo%>';</script><%
		end if
		response.end

	end if
%>
