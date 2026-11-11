<%
	if strEmpresaSecaoProduto_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	SQL = " select CODIGO, DESCRICAO FROM EST_SECAO_PRODUTO "
	SQL = SQL & " where COD_EMPRESA = " & Session("CodEmpresa")
	if intSecaoProduto<>"0" then
		SQL = SQL & " and codigo in (" & intSecaoProduto & ",11)"
	end if
	SQL = SQL & " ORDER BY DESCRICAO "
	rs.open SQL, cnn
%>
	<select name="cmbSecaoProduto" id="cmbSecaoProduto" style="width:160pt" class="combo" <%=strFuncao%>>
    <%if Session("CodSecao")="0" then%>
    <option value="0">Selecione...</option>
    <%end if%>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intSecaoProduto) = trim(rs("CODIGO")) then
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
