<%
	if strEmpresa_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	SQL = " select codigo_escola_estadual, nome"
	SQL = SQL & " FROM ste_escola_estadual"
	SQL = SQL & " Order by nome"
	RS.OPEN SQL, CNN
	IF RS.EOF = FALSE THEN
%>
	<select name="cmbEscolaEstadual" id="cmbEscolaEstadual" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    
        while not rs.eof
            if trim(intCodEscolaEstadual) = trim(rs("codigo_escola_estadual")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("codigo_escola_estadual")& " " & strSelecionado &">" & rs("nome") & "</option> "  & vbcrlf
            rs.movenext
        wend
	end if
    rs.close
%>
</select>