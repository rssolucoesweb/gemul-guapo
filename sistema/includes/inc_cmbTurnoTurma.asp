<%
	if strSubmitTurnoTurma = "" then
		strFuncaoTurnoTurma = ""
	else
		strFuncaoTurnoTurma = "onchange='submit()'"
	end if
	
	sql = "SELECT COD_TURNO, DESC_TURNO, TURNO_SIGLA"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE cod_grupo =" & Session("CodGrupo")
	sql = sql & " Order by Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoTurma" id="cmbTurnoTurma" style="width:130pt" class="form-control" <%=strFuncaoTurnoTurma%>>
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoTurma) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
				if trim(rs("COD_TURNO"))<>4 then intCodTurno = trim(rs("COD_TURNO"))
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