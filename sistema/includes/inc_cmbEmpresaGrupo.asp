<%
	if strEmpresaGrupo_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	SQL = " select SEG_USUARIOS_EMPRESA.COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.codigo AS CodGrupo,"
	SQL = SQL & " SEG_GRUPO.DESCRICAO AS GRUPO "
	SQL = SQL & " FROM SEG_USUARIOS_EMPRESA"
	SQL = SQL & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
	SQL = SQL & " LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
	SQL = SQL & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
	SQL = SQL & " AND SEG_GRUPO.codigo = " & Session("CodGrupo")
	SQL = SQL & " AND SEG_EMPRESA.BLOQUEIO = 'N'"
	SQL = SQL & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
	RS.OPEN SQL, CNN
%>
	<select name="cmbEmpresaGrupo" id="cmbEmpresaGrupo" style="width:350pt" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodEmpresaGrupo) = trim(rs("COD_EMPRESA")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
			if ucase(Session("UsuarioWeb")) = "USUARIO.TESTE" then
				response.write "<option value=" & rs("COD_EMPRESA")& " " & strSelecionado &">" & session("EmpresaWeb") & "</option> "  & vbcrlf
			else
	            response.write "<option value=" & rs("COD_EMPRESA")& " " & strSelecionado &">" & rs("RAZAOSOCIAL") & "</option> "  & vbcrlf
			end if
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>