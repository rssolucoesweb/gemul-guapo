<%	
	if strExecutarSubmitPeriodo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if trim(intCodCurso) = "" then intCodCurso = "0"
	if isnull(intCodCurso) then intCodCurso = "0"
	
	sql = "SELECT distinct p.cod_periodo, p.Descricao, p.sequencia"
	sql = sql & " FROM SCA_PERIODO p"
	sql = sql & " where p.cod_curso = " & intCodCurso
	sql = sql & " Order by p.sequencia, p.Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" class="form-control"  <%=strDisabilitaCombo%> <%=strFuncao%> <%=strPeriodo_Disabled%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPeriodo) = trim(rs("cod_periodo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_periodo") & " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>