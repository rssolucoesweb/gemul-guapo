<%	
	if strExecutarSubmitSemestreTodos = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, SIGLA, DESCRICAO "
	sql = sql & " FROM SCA_SEMESTRE"
	sql = sql & " where codigo in (" & Session("strTodosSemestre") & ")"
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbSemestre" id="cmbSemestre" class="form-control"  <%=strFuncao%>>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intSemestre) = trim(rs("Codigo")) then
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