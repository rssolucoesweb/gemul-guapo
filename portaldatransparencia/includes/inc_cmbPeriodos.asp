<%
	strFuncao = "onchange='submit()'"

	SQL = " SELECT DISTINCT Periodo"
	SQL = SQL & " FROM MAT_reserva "
	SQL = SQL & " WHERE cod_aluno is null"
	SQL = SQL & " and Curso = 'EDUCAÇÃO INFANTIL'"
	SQL = SQL & " ORDER BY 1"
	RS.OPEN SQL, CNN,1,3
	IF RS.EOF = FALSE THEN
%>
	<select name="cmbPeriodo" id="cmbPeriodo" class="form-control filtro-item" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    
        while not rs.eof
            if trim(strPeriodo) = trim(replace(rs("Periodo")," ","_")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & replace(rs("Periodo")," ","_")& " " & strSelecionado &">" & rs("periodo") & "</option> "  & vbcrlf
            rs.movenext
        wend
	end if
    rs.close
%>
</select>