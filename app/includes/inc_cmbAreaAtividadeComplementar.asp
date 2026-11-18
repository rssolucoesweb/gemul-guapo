<%	
	if strExecutarSubmitArea = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	
%>

<select name="cmbAreaAC" id="cmbAreaAC" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%
        sql = "select id,codigo,descricao from sca_atividade_complementar_area where ativo=1"
        rs.open sql, cnn
        While not rs.eof
            if trim(intCodigoAreaAC) = trim(rs("id")) then
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