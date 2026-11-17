<%	
	if strExecutarSubmitAnoFechamentoMes = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "select distinct ano_letivo from [dbo].[SCA_FECHAMENTO_MENSAL_ALUNO] order by 1"
	
	RS.OPEN SQL, CNN
%>
<select name="txtAnoLetivo" id="txtAnoLetivo" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strAnoLetivo) = trim(rs("ano_letivo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("ano_letivo")& " " & strSelecionado &">" & rs("ano_letivo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>