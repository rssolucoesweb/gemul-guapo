<%
	sql = "select codigo, nome from SOS_FUNCIONARIO_EXTERNO where situacao = 'A' and COD_GRUPO = " & session("CodGrupo") & " order by nome "
	RS.OPEN SQL, CNN
%>
<select name="cmbUsuarioOS" id="cmbUsuarioOS" style="width:300pt" class="form-control">
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodUsuarioOS) = trim(rs("codigo")) then
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