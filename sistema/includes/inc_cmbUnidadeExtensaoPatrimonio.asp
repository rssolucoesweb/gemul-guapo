<%
	if strUnidadeExtensao_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if Session("NivelPermissao") <> "A" then
		SQL = " select PAT_EXTENSAO.Codigo, "
		SQL = SQL & " PAT_EXTENSAO.Descricao,PAT_USUARIO_EXTENSAO.CODIGO AS cod_extensao, "
		SQL = SQL & " PAT_USUARIO_EXTENSAO.Usuario_web, SEG_USUARIOS_SISTEMA.usua_codg " 
		SQL = SQL & " FROM PAT_EXTENSAO "
		SQL = SQL & " INNER JOIN PAT_USUARIO_EXTENSAO ON PAT_USUARIO_EXTENSAO.Cod_extensao = PAT_EXTENSAO.Codigo "
		SQL = SQL & " INNER JOIN SEG_USUARIOS_SISTEMA ON SEG_USUARIOS_SISTEMA.USUA_CODG = PAT_USUARIO_EXTENSAO.Usuario_web "
		SQL = SQL & " WHERE PAT_USUARIO_EXTENSAO.USUARIO_WEB = '" & Session("UsuarioWeb")& "'" 
		SQL = SQL & " ORDER BY PAT_EXTENSAO.DESCRICAO "	
	else
		SQL = "select CODIGO, DESCRICAO FROM PAT_EXTENSAO ORDER BY DESCRICAO"
    end if
	rs.open SQL, cnn
%>
	<select name="cmbUnidadeExtensao" id="cmbUnidadeExtensao" style="width:100pt%" class="combo" <%=strFuncao%> >
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intUnidadeExtensao) = trim(rs("CODIGO")) then
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
