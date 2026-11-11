<%	strSiglaTurno = ""
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if strAnoLetivo = "" then strAnoLetivo = year(date)
	
	if libera_turma_inativa = "S" then
		sql = "select distinct t.COD_TURNO, t.DESC_TURNO"
		sql = sql & " from SCA_TURNO t"
		sql = sql & " where t.Cod_Empresa = " & session("codEmpresa")
		if intCodTurno<>"" then
			sql = sql & " and t.COD_TURNO = "& intCodTurno
		end if
		sql = sql & " Order by t.COD_TURNO"
	else
		sql = "select distinct t.COD_TURNO, t.DESC_TURNO"
		sql = sql & " from SCA_TURNO t"
		sql = sql & " INNER JOIN SCA_HORARIO H ON h.CodTurno = t.Cod_Turno "
		sql = sql & " inner join SCA_HORARIO_AULA HA on HA.cod_horario = H.codigo"
		sql = sql & " where HA.AnoLetivo = " & strAnoLetivo
		sql = sql & " and HA.Cod_Empresa = " & session("codEmpresa")
		sql = sql & " AND HA.Cod_Colaborador = " & intCodProfessor
		sql = sql & " Order by t.COD_TURNO"
	end if
	'response.write sql
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