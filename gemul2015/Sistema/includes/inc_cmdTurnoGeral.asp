<%	
	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT DISTINCT Desc_turno"
	sql = sql & " FROM SRH_TURNO"
	sql = sql & " where cod_grupo in (" & Session("CodGrupo") & ")"			
	sql = sql & " Order by Desc_turno"

	RS.OPEN SQL, CNN
%>
<select name="cmbTurno" id="cmbTurno" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurno) = trim(REPLACE(rs("Desc_turno")," ","_")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & REPLACE(rs("Desc_turno")," ","_") & " " & strSelecionado &">" &rs("Desc_turno") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>