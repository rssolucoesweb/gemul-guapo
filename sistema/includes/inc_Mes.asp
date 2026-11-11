<%
	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	SQL = "SELECT Codigo, Mes"
	SQL = SQL & " FROM SCC_MES"
	SQL = SQL & " Order by Codigo "
	RS.OPEN SQL, CNN
%>
<select name="cmbMes" id="cmbMes" style="width:80pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodMes) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("Mes") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>