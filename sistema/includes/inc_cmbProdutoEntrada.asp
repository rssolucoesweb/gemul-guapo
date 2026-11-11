<%
IF StrReloadProduto = "" then 'Verifica se é para dar o reload na página
	strOnChangeProduto = ""
else
	strOnChangeProduto="onChange='return reload()'"
end if
%>
<select name="cmbProdutoEntrada<%=id%>" id="cmbProdutoEntrada<%=id%>" class="form-control"  style="width:200pt" <%=strOnChangeProduto%> >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from EST_PRODUTO"
	sql = sql & " where COD_SECAO = "& intSecaoProduto
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if trim(intCodProduto) = trim(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("descricao") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>