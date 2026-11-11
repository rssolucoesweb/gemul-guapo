<%	
	strFuncao = ""
	if strUfResidencia = "" then strUfResidencia = "GO"
	sql = "SELECT CODIGO, SIGLA"
	sql = sql & " FROM SCF_UF"
	sql = sql & " Order by SIGLA"
	RS.OPEN SQL, CNN
%>
<select name="cmbUFResidencia" id="cmbUFResidencia" style="width:60pt" class="form-control" <%=strFuncao%>>
	<option value="0">...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if isnumeric(strUfResidencia) then
				if trim(strUfResidencia) = trim(rs("CODIGO")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
			else
				if trim(strUfResidencia) = trim(rs("SIGLA")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("SIGLA") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>