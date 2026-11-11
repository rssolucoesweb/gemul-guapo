<%	
	sql = "SELECT COD_RELIGIAO, DESC_RELIGIAO"
	sql = sql & " FROM SCA_RELIGIAO"
	sql = sql & " Order by DESC_RELIGIAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbReligiao" id="cmbReligiao" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodReligiao) = trim(rs("COD_RELIGIAO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_RELIGIAO")& " " & strSelecionado &">" & rs("DESC_RELIGIAO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>