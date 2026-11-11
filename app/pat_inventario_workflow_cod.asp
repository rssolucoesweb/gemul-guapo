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
	' GERAR ITENS (lista automaticamente os bens ativos da unidade/local)
	' ================================================================
	if acao = "GerarItens" then

		intCodigo = Trim(Request.QueryString("cod"))

		cnn.begintrans

		sql = "SELECT cod_empresa, cod_local, situacao FROM PAT_INVENTARIO WHERE codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof or rs("situacao") <> "ABERTO" then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Este inventário não está mais aberto."); window.location='pat_inventario.asp?cod=<%=intCodigo%>';</script><%
			response.end
		end if
		intCodEmpresa = rs("cod_empresa")
		intCodLocal = rs("cod_local")
		rs.close

		sql = "SELECT p.codigo, p.cod_empresa, p.cod_local, p.cod_colaborador, p.cod_estado_conservacao"
		sql = sql & " FROM PAT_PATRIMONIO p"
		sql = sql & " INNER JOIN PAT_SITUACAO s ON s.codigo = p.cod_situacao"
		sql = sql & " WHERE p.cod_empresa = " & intCodEmpresa & " AND s.indicador_baixado = 0"
		if not isnull(intCodLocal) then
			sql = sql & " AND p.cod_local = " & intCodLocal
		end if

		Set rsBens = Server.CreateObject("ADODB.Recordset")
		rsBens.open sql, cnn

		intGerados = 0
		while not rsBens.eof

			strLocalSQL = "NULL" : if not isnull(rsBens("cod_local")) then strLocalSQL = rsBens("cod_local")
			strColaboradorSQL = "NULL" : if not isnull(rsBens("cod_colaborador")) then strColaboradorSQL = rsBens("cod_colaborador")
			strEstadoSQL = "NULL" : if not isnull(rsBens("cod_estado_conservacao")) then strEstadoSQL = rsBens("cod_estado_conservacao")

			sql = "Insert Into PAT_INVENTARIO_ITEM(cod_inventario, cod_patrimonio, tipo_item,"
			sql = sql & " cod_empresa_esperada, cod_local_esperado, cod_colaborador_esperado, cod_estado_conservacao_esperado,"
			sql = sql & " status_conferencia)"
			sql = sql & " Values ("
			sql = sql & intCodigo & ","
			sql = sql & rsBens("codigo") & ","
			sql = sql & "'CADASTRADO',"
			sql = sql & rsBens("cod_empresa") & ","
			sql = sql & strLocalSQL & ","
			sql = sql & strColaboradorSQL & ","
			sql = sql & strEstadoSQL & ","
			sql = sql & "'AGUARDANDO_CONFERENCIA')"
			cnn.execute sql

			intGerados = intGerados + 1
			rsBens.movenext
		wend
		rsBens.close

		sql = "Update PAT_INVENTARIO Set situacao = 'EM_ANDAMENTO' where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>alert("<%=intGerados%> itens gerados para conferência."); window.location='pat_inventario.asp?cod=<%=intCodigo%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível gerar os itens do inventário."); window.location='pat_inventario.asp?cod=<%=intCodigo%>';</script><%
		end if
		response.end

	' ================================================================
	' FINALIZAR INVENTÁRIO
	' ================================================================
	elseif acao = "Finalizar" then

		intCodigo = Trim(Request.QueryString("cod"))

		cnn.begintrans

		sql = "SELECT situacao FROM PAT_INVENTARIO WHERE codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof or rs("situacao") <> "EM_ANDAMENTO" then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Este inventário não está em andamento."); window.location='pat_inventario.asp?cod=<%=intCodigo%>';</script><%
			response.end
		end if
		rs.close

		' Marca como NÃO LOCALIZADO tudo que ficou pendente (não pode finalizar com pendência)
		sql = "SELECT codigo, cod_patrimonio FROM PAT_INVENTARIO_ITEM WHERE cod_inventario = " & intCodigo & " AND status_conferencia = 'AGUARDANDO_CONFERENCIA'"
		Set rsPend = Server.CreateObject("ADODB.Recordset")
		rsPend.open sql, cnn
		while not rsPend.eof
			sql = "Update PAT_INVENTARIO_ITEM Set status_conferencia = 'NAO_LOCALIZADO', data_hora_conferencia = GETDATE(), usuario_conferencia = '" & strUsuario & "'"
			sql = sql & " where codigo = " & rsPend("codigo")
			cnn.execute sql

			if not isnull(rsPend("cod_patrimonio")) then
				sql = "Insert Into PAT_HISTORICO(cod_patrimonio, tipo_evento, descricao, entidade_origem, codigo_origem, usuario)"
				sql = sql & " Values (" & rsPend("cod_patrimonio") & ",'INVENTARIO','Bem não localizado durante inventário nº" & intCodigo & "','PAT_INVENTARIO'," & intCodigo & ",'" & strUsuario & "')"
				cnn.execute sql
			end if

			rsPend.movenext
		wend
		rsPend.close

		sql = "Update PAT_INVENTARIO Set situacao = 'FINALIZADO', data_fim = GETDATE(), usuario_final = '" & strUsuario & "', data_hora_final = GETDATE()"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>alert("Inventário finalizado com sucesso."); window.location='pat_inventario.asp?cod=<%=intCodigo%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível finalizar o inventário."); window.location='pat_inventario.asp?cod=<%=intCodigo%>';</script><%
		end if
		response.end

	' ================================================================
	' CANCELAR INVENTÁRIO
	' ================================================================
	elseif acao = "Cancelar" then

		intCodigo = Trim(Request.Form("cod_inventario"))
		strMotivoCancelamento = Trim(Request.Form("motivo_cancelamento"))

		cnn.begintrans

		sql = "Update PAT_INVENTARIO Set situacao = 'CANCELADO', usuario_canc = '" & strUsuario & "',"
		sql = sql & " data_hora_canc = GETDATE(), motivo_cancelamento = '" & Replace(strMotivoCancelamento, "'", "''") & "'"
		sql = sql & " where codigo = " & intCodigo & " and situacao in ('ABERTO', 'EM_ANDAMENTO')"
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>alert("Inventário cancelado."); window.location='pat_inventario.asp?cod=<%=intCodigo%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível cancelar o inventário."); window.location='pat_inventario.asp?cod=<%=intCodigo%>';</script><%
		end if
		response.end

	end if
%>
