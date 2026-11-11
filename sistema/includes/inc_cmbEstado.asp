<%	
	if strExecutarSubmitEstado = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, NOME"
	sql = sql & " FROM PES_ESTADO"
	sql = sql & " Order by NOME"
	RS.OPEN SQL, CNN
%>
<select name="cmbEstado" id="cmbEstado" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_estado) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>