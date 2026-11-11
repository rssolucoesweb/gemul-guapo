<%	
	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT DISTINCT cod_curso, Descricao"
	sql = sql & " FROM SCA_CURSO"
	SQL = SQL & " WHERE Situacao = 'A' "
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbCurso" id="cmbCurso" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCurso) = trim(rs("cod_curso")) then
				strSelecionado = " selected"
				strCurso = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_curso") & " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>