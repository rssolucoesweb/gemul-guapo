<%
	strFuncao = "onchange='submit()'"

	SQL = " SELECT p.Cod_Periodo, p.descricao as periodo, c.descricao as curso"
	SQL = SQL & " FROM SCA_PERIODO p"
	SQL = SQL & " inner join SCA_CURSO c on c.cod_curso = p.cod_curso"
	SQL = SQL & " where c.Cod_Curso in (1,2,3)"
	SQL = SQL & " ORDER BY 3,2"
	RS.OPEN SQL, CNN,1,3
	IF RS.EOF = FALSE THEN
%>
	<select name="cmbPeriodo" id="cmbPeriodo" class="form-control filtro-item" <%=strFuncao%>>
    <option value="0">Todos...</option>
    <%	
    
        while not rs.eof
            if trim(intCodPeriodo) = trim(rs("Cod_Periodo")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("Cod_Periodo")& " " & strSelecionado &">" & rs("curso") & " - " & rs("periodo") & "</option> "  & vbcrlf
            rs.movenext
        wend
	end if
    rs.close
%>
</select>