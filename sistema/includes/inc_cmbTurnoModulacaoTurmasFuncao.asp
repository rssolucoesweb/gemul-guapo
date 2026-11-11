<%
	sql = "SELECT COD_TURNO, DESC_TURNO, TURNO_SIGLA"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE cod_grupo =" & Session("CodGrupo")
	if mid(strNomeTurma,6,1) = "I" then
	else
		SQL = SQL & " AND SUBSTRING(DESC_TURNO,1,1) = '" & mid(strNomeTurma,6,1) & "' "
	end if
	sql = sql & " Order by Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoRH" id="cmbTurnoRH" style="width:130pt" class="form-control">
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurno) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
				strSiglaTurno = trim(rs("TURNO_SIGLA")) 
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