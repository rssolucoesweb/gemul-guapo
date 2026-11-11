<%
	if strUsuarioSistema_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = "select USUA_CODG FROM SEG_USUARIOS_SISTEMA "
	sql = sql & " WHERE USUA_STAT = 'A' "
	sql = sql & " AND COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " ORDER BY USUA_CODG "
	rs.open SQL, cnn
%>
	<select name="cmbUsuarioSistema" id="cmbUsuarioSistema" style="width:100pt%" class="combo" <%=strFuncao%> >
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(strUsuarioSistema) = trim(rs("USUA_CODG")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("USUA_CODG")& " " & strSelecionado &">" & rs("USUA_CODG") & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>
