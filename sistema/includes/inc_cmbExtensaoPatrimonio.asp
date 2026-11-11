<%
	if strExtensao_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	SQL = "select CODIGO, DESCRICAO FROM PAT_EXTENSAO ORDER BY DESCRICAO"
	rs.open SQL, cnn
%>
	<select name="cmbExtensao" id="cmbExtensao" style="width:100pt%" class="combo" <%=strFuncao%> >
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intExtensao) = trim(rs("CODIGO")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("DESCRICAO") & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>
