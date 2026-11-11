<%
	if strSituacao_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	    
	SQL = " select CODIGO, descricao FROM pro_situacao where codigo<>1" 
	SQL = SQL & " ORDER BY codigo"
	rs.open SQL, cnn
%>
	<select name="cmbSituacao" id="cmbSituacao" style="width:80pt" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodSituacao) = trim(rs("CODIGO")) then
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