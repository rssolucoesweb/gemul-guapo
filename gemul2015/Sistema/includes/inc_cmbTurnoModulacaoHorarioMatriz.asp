<%	
if intCodTurma = "0" then
%>
    <select name="cmbTurnoHorario" id="cmbTurnoHorario" style="width:150pt" class="combo">
		<option value="0">Selecione...</option>
    </select>        
<%
else
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

		SQL = " select DISTINCT T.COD_TURNOFUNCAO AS COD_TURNO, TUR.DESC_TURNO AS TURNO"
		SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO T"
		SQL = SQL & " INNER JOIN SRH_TURNO TUR ON TUR.COD_TURNO = T.COD_TURNOFUNCAO"
		SQL = SQL & " where T.Cod_Turma = "& intCodTurma
		SQL = SQL & " UNION"
		SQL = SQL & " select DISTINCT DT.COD_TURNOFUNCAO AS COD_TURNO, TUR.DESC_TURNO AS TURNO"
		SQL = SQL & " from SCA_TURMA T "
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA D ON D.Cod_GradeCurricular = G.Cod_GradeCurricular"
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO DT ON D.Cod_GradeCurricularDisciplina = DT.Cod_GradeCurricularDisciplina"
		SQL = SQL & " INNER JOIN SRH_TURNO TUR ON TUR.COD_TURNO = DT.COD_TURNOFUNCAO"
		SQL = SQL & "  where T.Cod_Turma = " &intCodTurma
		SQL = SQL & "  ORDER BY 2"

if UCASE(session("usuarioWeb")) = "SERGIO" then
'response.Write(sql)
end if
	
	RS.OPEN SQL, CNN
	%>
	<select name="cmbTurnoHorario" id="cmbTurnoHorario" style="width:150pt" class="combo" <%=strFuncao%>>
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