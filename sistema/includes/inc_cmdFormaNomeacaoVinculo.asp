<%	
	sql = "SELECT Cod_FormaNomeacaoVinculo AS CODIGO, DESCRICAO "
	sql = sql & " FROM SRH_FORMANOMEACAOVINCULO"
	sql = sql & " Order by descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbVinculo" id="cmbVinculo" style="width:150pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFormaNomeacaoVinculo) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>