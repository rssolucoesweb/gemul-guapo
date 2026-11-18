<%	
	if strExecutarSubmitSubArea = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodigoAreaAC="" then intCodigoAreaAC = 0
%>

<select name="cmbSubAreaAC" id="cmbSubAreaAC" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%
        sql = "select id, codigo, descricao "
		sql = sql & " from sca_atividade_complementar_subarea"
		sql = sql & " where ativo=1 and area_id = " & intCodigoAreaAC
        rs.open sql, cnn
        While not rs.eof
            if trim(intCodigoSubAreaAC) = trim(rs("id")) then
                strSeleciona  = "selected"
            else
                strSeleciona = ""	
            end if
            Response.Write "<option value = " & rs("id") & " " & strSeleciona & ">" & trim(rs("codigo")) & " - " & trim(rs("descricao")) & "</option>" & vbcrlf
            rs.movenext
        wend 
        rs.close
    %>	
    </select>