<%
	if strEmpresaGrupo_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if contEmpresaDoGrupo = "" then contEmpresaDoGrupo= 0
	
	SQL = " select SEG_USUARIOS_EMPRESA.COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.codigo AS CodGrupo,"
	SQL = SQL & " SEG_GRUPO.DESCRICAO AS GRUPO "
	SQL = SQL & " FROM SEG_USUARIOS_EMPRESA"
	SQL = SQL & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
	SQL = SQL & " LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
	SQL = SQL & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
	SQL = SQL & " AND SEG_GRUPO.codigo = " & Session("CodGrupo")
	SQL = SQL & " AND SEG_EMPRESA.BLOQUEIO='N'"
	if strExecutarSubmitTipoEmpresa = "S" then
		if intCodTipoEmpresa <> "0" and intCodTipoEmpresa <> "9999" then
			SQL = SQL & " AND SEG_EMPRESA.CODTIPOEMPRESA = " & intCodTipoEmpresa
		end if
	end if
	SQL = SQL & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
	RS.OPEN SQL, CNN,1,3
	%>
	<select name="cmbEmpresaGrupo" id="cmbEmpresaGrupo" class="form-control" <%=strFuncao%>>
	<%
	IF RS.EOF = FALSE THEN
		contEmpresaDoGrupo = rs.RecordCount
		%>
	
    <%if (Session("NivelPermissao") = "A" AND contEmpresaDoGrupo>1) or (mostraSelecione = "") then%>
    <option value="0">Selecione...</option>
    <%end if%>
    <%	
    
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
    else
	%>
	 <%if (Session("NivelPermissao") = "A" AND contEmpresaDoGrupo>1) or (mostraSelecione = "") then%>
    <option value="0">Selecione...</option>
    <%end if%>
	<%
	end if
    rs.close
%>
</select>