<%
	if strEmpresa_submit = "" then
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
	SQL = SQL & " AND SEG_EMPRESA.BLOQUEIO='N'"
	SQL = SQL & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
	RS.OPEN SQL, CNN,1,3
	IF RS.EOF = FALSE THEN
%>
	<select name="cmbEmpresa" id="cmbEmpresa" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    
        while not rs.eof
            if trim(intCodEmpresa) = trim(rs("COD_EMPRESA")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("COD_EMPRESA")& " " & strSelecionado &">" & rs("RAZAOSOCIAL") & "</option> "  & vbcrlf
            rs.movenext
        wend
	end if
    rs.close
%>
</select>