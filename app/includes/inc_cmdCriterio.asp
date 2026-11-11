<%	
	if strExecutarSubmitTipoCriterio = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT codigo, descricao"
	sql = sql & " FROM SCA_CRITERIO"
	sql = sql & " Order by codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbCriterio" id="cmbCriterio" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCriterio) = trim(rs("codigo")) then
				strSelecionado = " selected"
				strCurso = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" &  rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>