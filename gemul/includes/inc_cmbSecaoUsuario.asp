<%
	if strEmpresaSecaoProduto_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	SQL = " select CODIGO, DESCRICAO FROM EST_SECAO_PRODUTO "
	SQL = SQL & " where COD_EMPRESA = " & Session("CodEmpresa") &" "
	SQL = SQL & " ORDER BY DESCRICAO "
	rs.open SQL, cnn
%>
	<select name="cmbSecaoUsuario" id="cmbSecaoUsuario" style="width:120pt" class="combo" <%=strFuncao%>>
    <option value="0">Todas...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intSecaoUsuario) = trim(rs("CODIGO")) then
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
