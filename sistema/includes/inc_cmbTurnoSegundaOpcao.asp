<%
    if intCodCursoSegundaOpcao = "" or isnull(intCodCursoSegundaOpcao) then intCodCursoSegundaOpcao = "0"

	sql = "SELECT COD_TURNO, DESC_TURNO, COD_CURSO"
	sql = sql & " FROM SCA_TURNO_VESTIBULAR"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " AND COD_CURSO=" & intCodCursoSegundaOpcao
	sql = sql & " Order by DESC_TURNO"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoSegundaOpcao" id="cmbTurnoSegundaOpcao" style="width:130pt" class="combo">
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoSegundaOpcao) = trim(rs("COD_TURNO")) then
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