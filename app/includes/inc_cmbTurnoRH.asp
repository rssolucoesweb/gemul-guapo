<%	
	if strExecutarSubmitTurnoRH = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	SQL = " select COD_TURNO, DESC_TURNO "
	SQL = SQL & " from SRH_TURNO " 
	if filtroTurno = "" then
		SQL = SQL & " where DESC_TURNO<>'INTEGRAL' and Cod_Grupo = " & Session("CodGrupo")
	else
		SQL = SQL & " where cod_turno in (1,2,3)"
	end if
	SQL = SQL & " ORDER BY COD_TURNO" 
	
	RS.OPEN SQL, CNN, 3, 1
%>

<select name="cmbTurnoRH" id="cmbTurnoRH" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	 IF RS.EOF = FALSE THEN
		qtdeRegistro = RS.recordCount		
	
		while not rs.eof
			if trim(intCodTurnoRH) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			if qtdeRegistro = "1" then
				intCodTurnoRH = rs("cod_turno")
				strSelecionado = " selected"
			end if			
			
			response.write "<option value=" & rs("cod_turno")& " " & strSelecionado &">" & rs("desc_turno") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
	
%>
</select>