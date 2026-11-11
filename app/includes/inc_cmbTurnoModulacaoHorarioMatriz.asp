<%	
if intCodTurma = "0" then
%>
    <select name="cmbTurnoHorario" id="cmbTurnoHorario" class="form-control">
		<option value="0">Selecione...</option>
    </select>        
<%
else
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if


		SQL = " select DISTINCT tu.Cod_Turno, tu.Desc_Turno as turno"
		SQL = SQL & " from [dbo].[SRH_DIRETRIZES] d"
		SQL = SQL & " inner join SCA_TURMA t on t.Cod_Turno = d.Cod_turno_turma and t.AnoLetivo = d.Ano_Letivo and t.Cod_periodo = d.Cod_Periodo and t.Cod_Empresa = d.Cod_Empresa"
		SQL = SQL & " inner join SCA_TURNO tu on tu.Cod_Turno = d.Cod_turno"
		SQL = SQL & " where t.cod_turma=" & intCodTurma
		SQL = SQL & " order by turno"

if UCASE(session("usuarioWeb")) = "SERGIO" then
'response.Write(sql)
end if
	
	RS.OPEN SQL, CNN
	%>
	<select name="cmbTurnoHorario" id="cmbTurnoHorario" class="form-control" <%=strFuncao%>>
		<option value="0">Selecione...</option>
		<%
		IF RS.EOF = FALSE THEN
			while not rs.eof
				if trim(intCodTurnoRH) = trim(rs("COD_TURNO")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
				response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("TURNO") & "</option> "  & vbcrlf
				rs.movenext
			wend
		END IF
		rs.close
		%>
	</select>
<%
end if
%>