<%	strSiglaTurno = ""
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT RH.COD_TURNO, RH.DESC_TURNO"
	sql = sql & " FROM SRH_TURNO RH"
	SQL = SQL & " WHERE RH.Cod_Grupo=" & Session("CodGrupo")
	sql = sql & " Order by RH.Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoFaltas" id="cmbTurnoFaltas" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoFaltas) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("DESC_TURNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>