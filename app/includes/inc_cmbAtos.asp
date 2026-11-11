<%	
	if strExecutarSubmitAtos = "" then
		strExecutarSubmitAtos = ""
	else
		strExecutarSubmitAtos = "onchange='submit()'"
	end if

	sql = "SELECT codigo, descricao"
	sql = sql & " FROM SCA_ATOS"
	RS.OPEN SQL, CNN
%>
<select name="cmbAtos" id="cmbAtos" class="form-control" <%=strExecutarSubmitAtos%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAtos) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>