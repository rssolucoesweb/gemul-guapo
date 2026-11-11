<%
	if strTipoEquipamento_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	SQL = " select CODIGO, DESCRICAO FROM PAT_TIPO_EQUIPAMENTO ORDER BY DESCRICAO"
	rs.open SQL, cnn
%>
	<select name="cmbTipoEquipamento" id="cmbTipoEquipamento" style="width:130pt" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intTipoEquipamento) = trim(rs("CODIGO")) then
                strSelecionado = " selected"
				strDescricaoTipoEquipamentoPatrimonio = ucase(trim(rs("DESCRICAO")))
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