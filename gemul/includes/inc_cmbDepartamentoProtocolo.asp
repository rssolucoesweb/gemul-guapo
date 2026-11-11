<%
	if strDepartamento_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	    
	SQL = " select CODIGO, descricao FROM pro_Departamento " 
	SQL = SQL & " where cod_Empresa = " & Session("CodEmpresa") & " and situacao = 'A' "
	SQL = SQL & " ORDER BY descricao "
	rs.open SQL, cnn
%>
	<select name="cmbDepartamento" id="cmbDepartamento" style="width:250pt" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodDepartamento) = trim(rs("CODIGO")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>