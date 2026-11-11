<%
	if strEmpresaGrupo_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	SQL = " select CODIGO AS COD_EMPRESA, RAZAOSOCIAL"
	SQL = SQL & " FROM SEG_EMPRESA "
	SQL = SQL & " WHERE 1=1"
	if strVerificaRegiao = "S" then
		SQL = SQL & " and CODIGO in (select re.cod_empresa"
		SQL = SQL & " from MAT_regiao_setores rs"
		SQL = SQL & " inner join MAT_setores s on s.codigo = rs.cod_setores"
		SQL = SQL & " inner join MAT_regiao_empresa re on re.cod_regiao = rs.cod_regiao"
		SQL = SQL & " where s.descricao='" & strBairroAluno & "')"
	end if
	if strMostraIntegral = "N" then
		SQL = SQL & " and codTipoEmpresa in (select CODIGO from SEG_TipoEmpresa where COD_GRUPO = " & Session("CodGrupo") & " and Descricao in ('ENSINO FUNDAMENTAL'))"
	else
		SQL = SQL & " and codTipoEmpresa in (select CODIGO from SEG_TipoEmpresa where COD_GRUPO = " & Session("CodGrupo") & " and Descricao in ('CMEIS','EMEI','ENSINO FUNDAMENTAL'))"
	end if
	SQL = SQL & " AND COD_GRUPO = " & Session("CodGrupo")
	SQL = SQL & " AND BLOQUEIO='N' "
	SQL = SQL & " Order by RAZAOSOCIAL"
	RS.OPEN SQL, CNN %>
	<select name="cmbEmpresa2opcao" id="cmbEmpresa2opcao" style="width:280pt" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodEmpresa2opcao) = trim(rs("COD_EMPRESA")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("COD_EMPRESA")& " " & strSelecionado &">" & rs("RAZAOSOCIAL") & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
	%>
	</select>