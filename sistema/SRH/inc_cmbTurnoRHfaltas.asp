<%	strSiglaTurno = ""
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT RH.COD_TURNO, RH.DESC_TURNO, SCA.COD_TURNO"
	sql = sql & " FROM SRH_TURNO RH"
	sql = sql & " INNER JOIN SCA_TURNO SCA ON SUBSTRING(RH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND RH.COD_GRUPO = " & session("codGrupo")
	SQL = SQL & " WHERE RH.Cod_Grupo=" & Session("CodGrupo")
	sql = sql & " Order by RH.Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoFaltas" id="cmbTurnoFaltas" style="width:150pt" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoFaltas) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
				intCodTurnoTurma = trim(rs("COD_TURNO_SCA"))
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