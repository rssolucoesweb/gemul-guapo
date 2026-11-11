<%
	strSiglaTurnoOpcional = ""
	strTurnoOpcional = ""
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT COD_TURNO, DESC_TURNO, TURNO_SIGLA"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE cod_grupo =" & Session("CodGrupo")
	sql = sql & " Order by Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoOpcional" id="cmbTurnoOpcional" style="width:130pt" class="form-control" <%=strFuncao%>>
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoOpcional) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
				strSiglaTurnoOpcional =  UCASE(LEFT(trim(rs("DESC_TURNO")),1))
				strTurnoOpcional =  UCASE(trim(rs("DESC_TURNO")))
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("DESC_TURNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
	response.write strTurnoOpcional
%>
</select>