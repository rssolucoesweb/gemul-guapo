	<%	
	strSiglaTurno = ""
	strTurno = ""
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "EXEC SP_MostraDisponibilidadeTurno " & intCodEmpresaGrupo & "," & strAnoLetivo & "," & intSemestre & ",'" & strTipoModulacao & "','" &strTipoLancamento& "'"
	RS.OPEN SQL, CNN
	%>
	<select name="cmbTurno" id="cmbTurno" style="width:150pt" class="combo" <%=strFuncao%>>
		<option value="0">Selecione...</option>
		<%
        IF RS.EOF = FALSE THEN
            while not rs.eof
                if trim(intCodTurnoColaborador) = trim(rs("COD_TURNO")) then
                    strSelecionado = " selected"
                    strSiglaTurno =  UCASE(LEFT(trim(rs("DESC_TURNO")),1))
					strTurno =  UCASE(trim(rs("DESC_TURNO")))
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