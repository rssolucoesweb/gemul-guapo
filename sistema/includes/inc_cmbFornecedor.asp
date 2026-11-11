<%
	if strEmpresaFornecedor_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	    
	SQL = " select CODIGO, razaosocialNome, numero FROM EST_FORNECEDOR " 
	SQL = SQL & " where codEmpresa = " & Session("CodEmpresa") &" "
	SQL = SQL & " ORDER BY razaosocialNome "
	rs.open SQL, cnn
%>
	<select name="cmbFornecedor" id="cmbFornecedor" style="width:150pt" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intFornecedor) = trim(rs("CODIGO")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("razaosocialNome") & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>