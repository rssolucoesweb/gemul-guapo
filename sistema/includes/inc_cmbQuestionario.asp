<%	
	if strExecutarSubmitQuestionario = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT p.CODIGO, p.NOME"
	sql = sql & " FROM EAD_questionario p "
	sql = sql & " WHERE cod_empresa = " & session("codEmpresa")
	sql = sql & " Order by p.NOME"
	RS.OPEN SQL, CNN
%>
<select name="cmbQuestionario" id="cmbQuestionario" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_questionario) = trim(rs("codigo")) then
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