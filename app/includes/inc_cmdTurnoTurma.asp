<%	strSiglaTurno = ""
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if strAnoLetivo = "" then strAnoLetivo = year(date)
	
	sql = "select distinct t.COD_TURNO, t.DESC_TURNO"
	sql = sql & " from SCA_TURNO t"
	sql = sql & " inner join SCA_TURMA tu on tu.Cod_turno = t.Cod_turno"
	sql = sql & " where tu.AnoLetivo = " & strAnoLetivo
	sql = sql & " and tu.Situacao = 'A'"
	sql = sql & " and tu.Cod_Empresa = " & session("codEmpresa")
	sql = sql & " Order by t.COD_TURNO"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoRH" id="cmbTurnoRH" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoRH) = trim(rs("COD_TURNO")) then
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