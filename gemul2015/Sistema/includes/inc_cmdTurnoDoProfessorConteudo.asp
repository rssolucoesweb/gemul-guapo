<%
	
	if intCodTurno = "" then intCodTurno = "0"
	sql = "select cod_turno, desc_turno from sca_turno"
	sql = sql & " where cod_turno =" & intCodTurno
	sql = sql & " Order by 2 " 
	RS.OPEN SQL, CNN,3,1
	%>
	<select name="cmbTurnoDoProfessor" id="cmbTurnoDoProfessor" style="width:250pt" class="combo" <%=strFuncao%>>
		<option value="0">Selecione...</option>
		<%
        IF RS.EOF = FALSE THEN
            qtdeRegistro = RS.recordCount		
        
            while not rs.eof
                if trim(intCodTurno) = trim(rs("cod_turno")) then
                    strSelecionado = "selected"
                else
                    strSelecionado = ""
                end if
                if qtdeRegistro = "1" then
                    intCodTurno = rs("cod_turno")
                    strSelecionado = " selected"
                    strEncontrou = "S"
                end if			
                
                response.write "<option value=" & rs("cod_turno")& " " & strSelecionado &">" & rs("desc_turno") & "</option> "  & vbcrlf
                rs.movenext
            wend
        END IF
        rs.close
        %>
	</select>

