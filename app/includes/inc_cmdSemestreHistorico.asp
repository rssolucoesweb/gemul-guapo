<%	
	if strExecutarSubmitSemestre = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, SIGLA, DESCRICAO "
	sql = sql & " FROM SCA_SEMESTRE"
	sql = sql & " where codigo in (1,2,3)"
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbSemestreHistorico" id="cmbSemestreHistorico" class="form-control"  <%=strFuncao%>>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intSemestreHistorico) = trim(rs("Codigo")) then
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