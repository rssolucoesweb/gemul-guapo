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
	' ADICIONAR ITEM
	' ================================================================
	if acao = "AdicionarItem" then

		intCodTransferencia = Trim(Request.Form("cod_transferencia"))
		strNumeroPatrimonio = Trim(Request.Form("txtNumeroPatrimonio"))

		cnn.begintrans

		' Busca o cabeçalho da transferência
		sql = "SELECT cod_empresa_origem, cod_empresa_destino, cod_local_destino, cod_colaborador_destino, situacao"
		sql = sql & " FROM PAT_TRANSFERENCIA WHERE codigo = " & intCodTransferencia
		rs.open sql, cnn
		if rs.eof then
			cnn.rollbacktrans
			%><script>alert("Transferência não encontrada."); window.history.back();</script><%
			response.end
		end if
		intCodEmpresaOrigem = rs("cod_empresa_origem")
		intCodEmpresaDestino = rs("cod_empresa_destino")
		intCodLocalDestino = rs("cod_local_destino")
		intCodColaboradorDestino = rs("cod_colaborador_destino")
		strSituacaoTransf = rs("situacao")
		rs.close

		if strSituacaoTransf <> "EM_ELABORACAO" then
			cnn.rollbacktrans
			%><script>alert("Esta transferência não está mais em elaboração."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if

		' Busca o bem pelo número de patrimônio
		sql = "SELECT p.codigo, p.cod_empresa, p.cod_local, p.cod_colaborador, s.indicador_baixado"
		sql = sql & " FROM PAT_PATRIMONIO p"
		sql = sql & " INNER JOIN PAT_SITUACAO s ON s.codigo = p.cod_situacao"
		sql = sql & " WHERE p.numero_patrimonio = '" & Replace(strNumeroPatrimonio, "'", "''") & "'"
		rs.open sql, cnn
		if rs.eof then
			cnn.rollbacktrans
			%><script>alert("Bem patrimonial não encontrado para o número informado."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if

		intCodPatrimonio = rs("codigo")
		intCodEmpresaBem = rs("cod_empresa")
		intCodLocalBem = rs("cod_local")
		intCodColaboradorBem = rs("cod_colaborador")
		blnBaixado = rs("indicador_baixado")
		rs.close

		if blnBaixado = true then
			cnn.rollbacktrans
			%><script>alert("Este bem já está baixado e não pode ser transferido."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if

		if CStr(intCodEmpresaBem) <> CStr(intCodEmpresaOrigem) then
			cnn.rollbacktrans
			%><script>alert("Este bem não pertence à unidade de origem informada nesta transferência."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if

		sql = "SELECT codigo FROM PAT_TRANSFERENCIA_ITEM WHERE cod_transferencia = " & intCodTransferencia & " AND cod_patrimonio = " & intCodPatrimonio
		rs.open sql, cnn
		if not rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Este bem já foi adicionado a esta transferência."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if
		rs.close

		strLocalDestinoSQL = "NULL"
		if intCodLocalDestino <> "" and not isnull(intCodLocalDestino) then strLocalDestinoSQL = intCodLocalDestino
		strColaboradorDestinoSQL = "NULL"
		if intCodColaboradorDestino <> "" and not isnull(intCodColaboradorDestino) then strColaboradorDestinoSQL = intCodColaboradorDestino
		strLocalBemSQL = "NULL"
		if not isnull(intCodLocalBem) then strLocalBemSQL = intCodLocalBem
		strColaboradorBemSQL = "NULL"
		if not isnull(intCodColaboradorBem) then strColaboradorBemSQL = intCodColaboradorBem

		sql = "Insert Into PAT_TRANSFERENCIA_ITEM(cod_transferencia, cod_patrimonio,"
		sql = sql & " cod_empresa_origem, cod_local_origem, cod_colaborador_origem,"
		sql = sql & " cod_empresa_destino, cod_local_destino, cod_colaborador_destino)"
		sql = sql & " Values ("
		sql = sql & intCodTransferencia & ","
		sql = sql & intCodPatrimonio & ","
		sql = sql & intCodEmpresaOrigem & ","
		sql = sql & strLocalBemSQL & ","
		sql = sql & strColaboradorBemSQL & ","
		sql = sql & intCodEmpresaDestino & ","
		sql = sql & strLocalDestinoSQL & ","
		sql = sql & strColaboradorDestinoSQL & ")"
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível adicionar o item."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		end if
		response.end

	' ================================================================
	' ADICIONAR VÁRIOS (lista com checkbox)
	' ================================================================
	elseif acao = "AdicionarVarios" then

		intCodTransferencia = Trim(Request.Form("cod_transferencia"))
		strBensMarcados = Trim(Request.Form("chkBem")) ' vem como lista separada por vírgula

		if strBensMarcados = "" then
			%><script>alert("Nenhum bem foi selecionado."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if

		cnn.begintrans

		sql = "SELECT cod_empresa_origem, cod_empresa_destino, cod_local_destino, cod_colaborador_destino, situacao"
		sql = sql & " FROM PAT_TRANSFERENCIA WHERE codigo = " & intCodTransferencia
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Transferência não encontrada."); window.history.back();</script><%
			response.end
		end if
		intCodEmpresaOrigem = rs("cod_empresa_origem")
		intCodEmpresaDestino = rs("cod_empresa_destino")
		intCodLocalDestino = rs("cod_local_destino")
		intCodColaboradorDestino = rs("cod_colaborador_destino")
		strSituacaoTransf = rs("situacao")
		rs.close

		if strSituacaoTransf <> "EM_ELABORACAO" then
			cnn.rollbacktrans
			%><script>alert("Esta transferência não está mais em elaboração."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if

		strLocalDestinoSQL = "NULL"
		if intCodLocalDestino <> "" and not isnull(intCodLocalDestino) then strLocalDestinoSQL = intCodLocalDestino
		strColaboradorDestinoSQL = "NULL"
		if intCodColaboradorDestino <> "" and not isnull(intCodColaboradorDestino) then strColaboradorDestinoSQL = intCodColaboradorDestino

		arrBens = Split(strBensMarcados, ",")
		intAdicionados = 0

		for i = 0 to UBound(arrBens)

			intCodPatrimonio = Trim(arrBens(i))
			if intCodPatrimonio <> "" then

				' Confere novamente que o bem pertence à unidade de origem e não está já nesta transferência
				' (segurança extra, já que a lista exibida já vem filtrada)
				sql = "SELECT p.codigo, p.cod_local, p.cod_colaborador"
				sql = sql & " FROM PAT_PATRIMONIO p"
				sql = sql & " WHERE p.codigo = " & intCodPatrimonio & " AND p.cod_empresa = " & intCodEmpresaOrigem
				sql = sql & " AND p.codigo NOT IN (SELECT cod_patrimonio FROM PAT_TRANSFERENCIA_ITEM WHERE cod_transferencia = " & intCodTransferencia & ")"
				rs.open sql, cnn

				if not rs.eof then

					intCodLocalBem = rs("cod_local")
					intCodColaboradorBem = rs("cod_colaborador")
					rs.close

					strLocalBemSQL = "NULL" : if not isnull(intCodLocalBem) then strLocalBemSQL = intCodLocalBem
					strColaboradorBemSQL = "NULL" : if not isnull(intCodColaboradorBem) then strColaboradorBemSQL = intCodColaboradorBem

					sql = "Insert Into PAT_TRANSFERENCIA_ITEM(cod_transferencia, cod_patrimonio,"
					sql = sql & " cod_empresa_origem, cod_local_origem, cod_colaborador_origem,"
					sql = sql & " cod_empresa_destino, cod_local_destino, cod_colaborador_destino)"
					sql = sql & " Values ("
					sql = sql & intCodTransferencia & ","
					sql = sql & intCodPatrimonio & ","
					sql = sql & intCodEmpresaOrigem & ","
					sql = sql & strLocalBemSQL & ","
					sql = sql & strColaboradorBemSQL & ","
					sql = sql & intCodEmpresaDestino & ","
					sql = sql & strLocalDestinoSQL & ","
					sql = sql & strColaboradorDestinoSQL & ")"
					cnn.execute sql

					intAdicionados = intAdicionados + 1

				else
					rs.close
				end if

			end if

		next

		GravarLog "AdicionarVarios - Transferencia " & intCodTransferencia & " - " & intAdicionados & " itens adicionados"

		if err.number = 0 then
			cnn.committrans
			%><script>window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível adicionar os itens selecionados."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		end if
		response.end

	' ================================================================
	' REMOVER ITEM
	' ================================================================
	elseif acao = "RemoverItem" then

		intCodItem = Trim(Request.QueryString("cod_item"))

		cnn.begintrans

		sql = "SELECT cod_transferencia FROM PAT_TRANSFERENCIA_ITEM WHERE codigo = " & intCodItem
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Item não encontrado."); window.history.back();</script><%
			response.end
		end if
		intCodTransferencia = rs("cod_transferencia")
		rs.close

		sql = "Delete from PAT_TRANSFERENCIA_ITEM where codigo = " & intCodItem & " and cod_movimentacao is null"
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível remover o item."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		end if
		response.end

	' ================================================================
	' CONCLUIR TRANSFERÊNCIA
	' ================================================================
	elseif acao = "Concluir" then

		intCodTransferencia = Trim(Request.QueryString("cod"))

		cnn.begintrans

		sql = "SELECT situacao FROM PAT_TRANSFERENCIA WHERE codigo = " & intCodTransferencia
		rs.open sql, cnn
		if rs.eof or rs("situacao") <> "EM_ELABORACAO" then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Esta transferência não está mais em elaboração."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if
		rs.close

		' Busca o tipo de movimentação TRANSFERENCIA (pré-requisito cadastrado)
		sql = "SELECT TOP 1 codigo FROM PAT_TIPO_MOVIMENTACAO WHERE descricao = 'TRANSFERENCIA' AND situacao = 'A'"
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Cadastre primeiro o Tipo de Movimentação 'TRANSFERENCIA' em Patrimônio > Tipo de Movimentação."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
			response.end
		end if
		intCodTipoMovimentacao = rs("codigo")
		rs.close

		' Percorre os itens ainda não movimentados
		sql = "SELECT codigo, cod_patrimonio, cod_empresa_destino, cod_local_destino, cod_colaborador_destino"
		sql = sql & " FROM PAT_TRANSFERENCIA_ITEM WHERE cod_transferencia = " & intCodTransferencia & " AND cod_movimentacao IS NULL"
		Set rsItem = Server.CreateObject("ADODB.Recordset")
		rsItem.open sql, cnn

		while not rsItem.eof

			intCodItem = rsItem("codigo")
			intCodPatrimonio = rsItem("cod_patrimonio")
			intCodEmpresaDestino = rsItem("cod_empresa_destino")
			intCodLocalDestino = rsItem("cod_local_destino")
			intCodColaboradorDestino = rsItem("cod_colaborador_destino")

			' Snapshot atual do bem (vira a "origem" da movimentação)
			sql = "SELECT cod_empresa, cod_local, cod_colaborador, cod_situacao, cod_estado_conservacao FROM PAT_PATRIMONIO WHERE codigo = " & intCodPatrimonio
			Set rsBem = Server.CreateObject("ADODB.Recordset")
			rsBem.open sql, cnn
			intCodEmpresaOrigemBem = rsBem("cod_empresa")
			intCodLocalOrigemBem = rsBem("cod_local")
			intCodColaboradorOrigemBem = rsBem("cod_colaborador")
			intCodSituacaoBem = rsBem("cod_situacao")
			intCodEstadoBem = rsBem("cod_estado_conservacao")
			rsBem.close

			strLocalOrigemSQL = "NULL" : if not isnull(intCodLocalOrigemBem) then strLocalOrigemSQL = intCodLocalOrigemBem
			strColaboradorOrigemSQL = "NULL" : if not isnull(intCodColaboradorOrigemBem) then strColaboradorOrigemSQL = intCodColaboradorOrigemBem
			strEstadoBemSQL = "NULL" : if not isnull(intCodEstadoBem) then strEstadoBemSQL = intCodEstadoBem
			strLocalDestinoSQL = "NULL" : if not isnull(intCodLocalDestino) then strLocalDestinoSQL = intCodLocalDestino
			strColaboradorDestinoSQL = "NULL" : if not isnull(intCodColaboradorDestino) then strColaboradorDestinoSQL = intCodColaboradorDestino

			' Grava a movimentação
			sql = "Insert Into PAT_MOVIMENTACAO(cod_patrimonio, cod_tipo_movimentacao,"
			sql = sql & " cod_empresa_origem, cod_local_origem, cod_colaborador_origem, cod_situacao_origem, cod_estado_conservacao_origem,"
			sql = sql & " cod_empresa_destino, cod_local_destino, cod_colaborador_destino, cod_situacao_destino, cod_estado_conservacao_destino,"
			sql = sql & " cod_transferencia, usuario_incl)"
			sql = sql & " Values ("
			sql = sql & intCodPatrimonio & ","
			sql = sql & intCodTipoMovimentacao & ","
			sql = sql & intCodEmpresaOrigemBem & ","
			sql = sql & strLocalOrigemSQL & ","
			sql = sql & strColaboradorOrigemSQL & ","
			sql = sql & intCodSituacaoBem & ","
			sql = sql & strEstadoBemSQL & ","
			sql = sql & intCodEmpresaDestino & ","
			sql = sql & strLocalDestinoSQL & ","
			sql = sql & strColaboradorDestinoSQL & ","
			sql = sql & intCodSituacaoBem & ","
			sql = sql & strEstadoBemSQL & ","
			sql = sql & intCodTransferencia & ","
			sql = sql & "'" & strUsuario & "')"
			cnn.execute sql

			' Recupera o código da movimentação recém-criada
			sql = "SELECT SCOPE_IDENTITY() AS novo_id"
			Set rsNovoId = Server.CreateObject("ADODB.Recordset")
			rsNovoId.open sql, cnn
			intCodMovimentacao = rsNovoId("novo_id")
			rsNovoId.close

			' Vincula a movimentação ao item da transferência
			sql = "Update PAT_TRANSFERENCIA_ITEM Set cod_movimentacao = " & intCodMovimentacao & " where codigo = " & intCodItem
			cnn.execute sql

			' Atualiza a localização atual do bem
			sql = "Update PAT_PATRIMONIO Set"
			sql = sql & " cod_empresa = " & intCodEmpresaDestino & ","
			sql = sql & " cod_local = " & strLocalDestinoSQL & ","
			sql = sql & " cod_colaborador = " & strColaboradorDestinoSQL & ","
			sql = sql & " usuario_altr = '" & strUsuario & "',"
			sql = sql & " data_hora_altr = GETDATE()"
			sql = sql & " where codigo = " & intCodPatrimonio
			cnn.execute sql

			' Registra no histórico
			sql = "Insert Into PAT_HISTORICO(cod_patrimonio, tipo_evento, descricao, entidade_origem, codigo_origem, usuario)"
			sql = sql & " Values ("
			sql = sql & intCodPatrimonio & ","
			sql = sql & "'TRANSFERENCIA',"
			sql = sql & "'Bem transferido via transferência nº' + CAST(" & intCodTransferencia & " as varchar),"
			sql = sql & "'PAT_TRANSFERENCIA',"
			sql = sql & intCodTransferencia & ","
			sql = sql & "'" & strUsuario & "')"
			cnn.execute sql

			rsItem.movenext
		wend
		rsItem.close

		' Conclui o cabeçalho
		sql = "Update PAT_TRANSFERENCIA Set situacao = 'CONCLUIDA', usuario_concl = '" & strUsuario & "', data_hora_concl = GETDATE()"
		sql = sql & " where codigo = " & intCodTransferencia
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>alert("Transferência concluída com sucesso! Todos os bens foram movimentados."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("ATENÇÃO: Não foi possível concluir a transferência. Nenhuma alteração foi salva. Tente novamente ou contate o administrador."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		end if
		response.end

	' ================================================================
	' CANCELAR TRANSFERÊNCIA
	' ================================================================
	elseif acao = "Cancelar" then

		intCodTransferencia = Trim(Request.Form("cod_transferencia"))
		strMotivoCancelamento = Trim(Request.Form("motivo_cancelamento"))

		cnn.begintrans

		sql = "Update PAT_TRANSFERENCIA Set situacao = 'CANCELADA', usuario_canc = '" & strUsuario & "',"
		sql = sql & " data_hora_canc = GETDATE(), motivo_cancelamento = '" & Replace(strMotivoCancelamento, "'", "''") & "'"
		sql = sql & " where codigo = " & intCodTransferencia & " and situacao = 'EM_ELABORACAO'"
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>alert("Transferência cancelada."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível cancelar a transferência."); window.location='pat_transferencia.asp?cod=<%=intCodTransferencia%>';</script><%
		end if
		response.end

	end if
%>
