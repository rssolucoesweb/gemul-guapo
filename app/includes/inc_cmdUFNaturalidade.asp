<%	
	strFuncao = ""

	sql = "SELECT CODIGO, SIGLA"
	sql = sql & " FROM SCF_UF"
	sql = sql & " Order by SIGLA"
	RS.OPEN SQL, CNN
%>
<select name="cmbUFNaturalidade" id="cmbUFNaturalidade" class="form-control" <%=strFuncao%>>
	<option value="0">...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strUFNaturalidade) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("SIGLA") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>