<%	
	sql = "SELECT CODIGO, DESCRICAO "
	sql = sql & " FROM SCA_TIPO_AVALIACAO_AGRUPAMENTO "
    sql = sql & " WHERE 1 = 1"
    sql = sql & " AND CODIGO <> 5 "
    sql = sql & " AND CODIGO <> 7 "
    sql = sql & " AND CODIGO <> 8 "
	sql = sql & " Order by Codigo "
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoAvaliacaoAgrupamento" id="cmbTipoAvaliacaoAgrupamento" style="width:150pt" class="combo">
	<option value="0">Não permite alteração...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAvaliacaoAgrupamento) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>