<%
	if strEmpresaUnidadeProduto_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	SQL = " select CODIGO, DESCRICAO FROM EST_UNIDADE_PRODUTO "
	SQL = SQL & " where COD_EMPRESA = " & Session("CodEmpresa")
	IF intSecaoProduto<>"0" THEN
		sql = sql & " and COD_SECAO = "& intSecaoProduto
	END IF
	SQL = SQL & " ORDER BY DESCRICAO "
	rs.open SQL, cnnAlmox
%>
	<select name="cmbUnidadeProduto" id="cmbUnidadeProduto" style="width:80pt" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intUnidadeProduto) = trim(rs("CODIGO")) then
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
