<%
    if intCodCursoPrimeiraOpcao = "" or isnull(intCodCursoPrimeiraOpcao) then intCodCursoPrimeiraOpcao = "0"

	sql = "SELECT COD_TURNO, DESC_TURNO, COD_CURSO"
	sql = sql & " FROM SCA_TURNO_VESTIBULAR"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " AND COD_CURSO=" & intCodCursoPrimeiraOpcao
	sql = sql & " Order by DESC_TURNO"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoPrimeiraOpcao" id="cmbTurnoPrimeiraOpcao" style="width:130pt" class="combo" onchange='submit()'>
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoPrimeiraOpcao) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
				strTurnoDescricao = rs("DESC_TURNO")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("DESC_TURNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
<input name="txtTurnoDescricao" type="hidden" id="txtTurnoDescricao" class="text" size="20" value="<%=strTurnoDescricao%>" maxlength="20">
</select>