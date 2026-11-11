<%

	
	SQL = " select CODIGO, DESCRICAO FROM EST_MARCA_PRODUTO "
	SQL = SQL & " where COD_EMPRESA = " & Session("CodEmpresa") &" "
	SQL = SQL & " ORDER BY DESCRICAO "
	rs.open SQL, cnn
%>
	<select name="cmbMarcaProduto" id="cmbMarcaProduto" style="width:120pt" class="combo" >
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodMarca) = trim(rs("CODIGO")) then
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
