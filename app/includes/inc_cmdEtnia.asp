<%	

	if strExecutarSubmitEtnia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
		
	end if
	
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SCA_ETNIAS"
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbEtnia" id="cmbEtnia" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodEtnia) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("DESCRICAO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>