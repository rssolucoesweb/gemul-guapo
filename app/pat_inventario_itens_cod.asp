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
	' CONFERIR LOCALIZADO (bem confere exatamente com o esperado)
	' ================================================================
	if acao = "ConferirLocalizado" then

		intCodItem = Trim(Request.QueryString("cod_item"))

		cnn.begintrans

		sql = "SELECT cod_inventario, cod_empresa_esperada, cod_local_esperado, cod_colaborador_esperado, cod_estado_conservacao_esperado"
		sql = sql & " FROM PAT_INVENTARIO_ITEM WHERE codigo = " & intCodItem
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Item não encontrado."); window.history.back();</script><%
			response.end
		end if
		intCodInventario = rs("cod_inventario")
		intCodEmpresaEsp = rs("cod_empresa_esperada")
		intCodLocalEsp = rs("cod_local_esperado")
		intCodColaboradorEsp = rs("cod_colaborador_esperado")
		intCodEstadoEsp = rs("cod_estado_conservacao_esperado")
		rs.close

		strLocalSQL = "NULL" : if not isnull(intCodLocalEsp) then strLocalSQL = intCodLocalEsp
		strColabSQL = "NULL" : if not isnull(intCodColaboradorEsp) then strColabSQL = intCodColaboradorEsp
		strEstadoSQL = "NULL" : if not isnull(intCodEstadoEsp) then strEstadoSQL = intCodEstadoEsp

		sql = "Update PAT_INVENTARIO_ITEM Set status_conferencia = 'LOCALIZADO',"
		sql = sql & " cod_empresa_encontrada = " & intCodEmpresaEsp & ","
		sql = sql & " cod_local_encontrado = " & strLocalSQL & ","
		sql = sql & " cod_colaborador_encontrado = " & strColabSQL & ","
		sql = sql & " cod_estado_conservacao_encontrado = " & strEstadoSQL & ","
		sql = sql & " data_hora_conferencia = GETDATE(), usuario_conferencia = '" & strUsuario & "'"
		sql = sql & " where codigo = " & intCodItem
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>window.location='pat_inventario_itens.asp?cod=<%=intCodInventario%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível confirmar o item."); window.location='pat_inventario_itens.asp?cod=<%=intCodInventario%>';</script><%
		end if
		response.end

	' ================================================================
	' CONFERIR NÃO LOCALIZADO
	' ================================================================
	elseif acao = "ConferirNaoLocalizado" then

		intCodItem = Trim(Request.QueryString("cod_item"))

		cnn.begintrans

		sql = "SELECT cod_inventario FROM PAT_INVENTARIO_ITEM WHERE codigo = " & intCodItem
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Item não encontrado."); window.history.back();</script><%
			response.end
		end if
		intCodInventario = rs("cod_inventario")
		rs.close

		sql = "Update PAT_INVENTARIO_ITEM Set status_conferencia = 'NAO_LOCALIZADO',"
		sql = sql & " data_hora_conferencia = GETDATE(), usuario_conferencia = '" & strUsuario & "'"
		sql = sql & " where codigo = " & intCodItem
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>window.location='pat_inventario_itens.asp?cod=<%=intCodInventario%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível registrar o item como não localizado."); window.location='pat_inventario_itens.asp?cod=<%=intCodInventario%>';</script><%
		end if
		response.end

	' ================================================================
	' CONFERIR COM DIVERGÊNCIA (observação livre)
	' ================================================================
	elseif acao = "ConferirDivergencia" then

		intCodItem = Trim(Request.Form("cod_item"))
		strObservacao = Trim(Request.Form("observacao"))

		cnn.begintrans

		sql = "SELECT cod_inventario FROM PAT_INVENTARIO_ITEM WHERE codigo = " & intCodItem
		rs.open sql, cnn
		if rs.eof then
			rs.close
			cnn.rollbacktrans
			%><script>alert("Item não encontrado."); window.history.back();</script><%
			response.end
		end if
		intCodInventario = rs("cod_inventario")
		rs.close

		sql = "Update PAT_INVENTARIO_ITEM Set status_conferencia = 'OUTRA_DIVERGENCIA',"
		sql = sql & " observacao = '" & Replace(strObservacao, "'", "''") & "',"
		sql = sql & " data_hora_conferencia = GETDATE(), usuario_conferencia = '" & strUsuario & "'"
		sql = sql & " where codigo = " & intCodItem
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>window.location='pat_inventario_itens.asp?cod=<%=intCodInventario%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível registrar a divergência."); window.location='pat_inventario_itens.asp?cod=<%=intCodInventario%>';</script><%
		end if
		response.end

	' ================================================================
	' ADICIONAR BEM NÃO CADASTRADO (encontrado fisicamente, sem registro no sistema)
	' ================================================================
	elseif acao = "AdicionarNaoCadastrado" then

		intCodInventario = Trim(Request.Form("cod_inventario"))
		strNumeroIdentificacao = Trim(Request.Form("numero_identificacao"))
		strDescricaoEncontrado = Trim(Request.Form("descricao_encontrado"))

		cnn.begintrans

		strNumIdentSQL = "NULL" : if strNumeroIdentificacao <> "" then strNumIdentSQL = "'" & Replace(strNumeroIdentificacao, "'", "''") & "'"

		sql = "Insert Into PAT_INVENTARIO_ITEM(cod_inventario, cod_patrimonio, tipo_item, status_conferencia,"
		sql = sql & " numero_identificacao_encontrado, descricao_item_encontrado, data_hora_conferencia, usuario_conferencia)"
		sql = sql & " Values ("
		sql = sql & intCodInventario & ","
		sql = sql & "NULL,"
		sql = sql & "'NAO_CADASTRADO',"
		sql = sql & "'BEM_NAO_CADASTRADO',"
		sql = sql & strNumIdentSQL & ","
		sql = sql & "'" & Replace(strDescricaoEncontrado, "'", "''") & "',"
		sql = sql & "GETDATE(),"
		sql = sql & "'" & strUsuario & "')"
		cnn.execute sql
		GravarLog sql

		if err.number = 0 then
			cnn.committrans
			%><script>window.location='pat_inventario_itens.asp?cod=<%=intCodInventario%>';</script><%
		else
			cnn.rollbacktrans
			%><script>alert("Não foi possível registrar o item."); window.location='pat_inventario_itens.asp?cod=<%=intCodInventario%>';</script><%
		end if
		response.end

	end if
%>
