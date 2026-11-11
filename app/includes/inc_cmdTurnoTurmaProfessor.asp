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
	sql = sql & " inner join SCA_HORARIO_AULA ha on ha.AnoLetivo = tu.AnoLetivo and ha.Cod_Empresa = tu.Cod_Empresa and ha.Cod_turma = tu.Cod_Turma"
	sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO and h.CodTurno = tu.Cod_Turno "
	sql = sql & " where tu.AnoLetivo = " & strAnoLetivo
	sql = sql & " and tu.Situacao = 'A'"
	sql = sql & " and tu.Cod_Empresa = " & session("codEmpresa")
	sql = sql & " AND HA.Cod_Colaborador = " & intCodProfessor
	sql = sql & " Order by t.COD_TURNO"
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