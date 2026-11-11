<%
	if intCodArea = "" then intCodArea=0
	sql = "select codigo, nome from SOS_FUNCIONARIO_EXTERNO where situacao = 'A' "
	if intCodArea <> "0" then
		sql = sql & " and cod_area = " & intCodArea 
	end if
	sql = sql & " and COD_GRUPO = " & session("CodGrupo") & " order by nome "
	RS.OPEN SQL, CNN
%>
<select name="cmbExecutor" id="cmbExecutor" style="width:300pt" class="form-control">
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodExecutor) = trim(rs("codigo")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>