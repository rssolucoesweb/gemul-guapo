<%	strSiglaTurno = ""

	sql = "SELECT COD_TURNO, DESC_TURNO"
	sql = sql & " FROM SCA_TURNO"
	sql = sql & " Order by Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurno<%=strCodigoAluno%>" id="cmbTurno<%=strCodigoAluno%>" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoRenovacao) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
				strSiglaTurno =  UCASE(LEFT(trim(rs("DESC_TURNO")),1))
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