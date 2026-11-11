<%
	sql = "SELECT COD_Grau, DESC_Grau"
	sql = sql & " FROM SCA_GRAU"
	sql = sql & " Order by DESC_Grau"
	RS.OPEN SQL, CNN
%>
<select name="cmbGrau" id="cmbGrau" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodGrau) = trim(rs("COD_Grau")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Grau")& " " & strSelecionado &">" & rs("DESC_Grau") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>