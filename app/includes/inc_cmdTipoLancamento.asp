<%	
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SCA_tipo_lancamento"
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoLancamento" id="cmbTipoLancamento" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoLancamento) = trim(rs("CODIGO")) then
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