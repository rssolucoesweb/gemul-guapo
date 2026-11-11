<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/11/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Departamento Recado
-->
<%	
	if strDepartamentoRecado_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = " select DISTINCT SEG_DEPARTAMENTO.CODIGO, SEG_DEPARTAMENTO.DESCRICAO"
	sql = sql & " FROM SEG_USUARIOS_EMPRESA "
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA "
	sql = sql & " INNER JOIN SEG_USUARIOS_SISTEMA ON SEG_USUARIOS_SISTEMA.USUA_CODG = SEG_USUARIOS_EMPRESA.CODIGO_SEG_USUARIOS_SISTEMA"
	sql = sql & " INNER JOIN SEG_DEPARTAMENTO ON SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO = SEG_DEPARTAMENTO.CODIGO AND SEG_EMPRESA.CODIGO = SEG_DEPARTAMENTO.COD_EMPRESA"
	sql = sql & " LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO "
	sql = sql & " WHERE 1=1 "
	sql = sql & " And SEG_USUARIOS_SISTEMA.USUA_STAT = 'A' and SEG_DEPARTAMENTO.SITUACAO = 'A'"
	sql = sql & " AND SEG_GRUPO.codigo = " & intCodGrupoRecado
	if intCodEmpresaRecado <> "0" then 
		sql = sql & " AND SEG_USUARIOS_EMPRESA.COD_EMPRESA = " & intCodEmpresaRecado
	end if
	if intCodDepartamentoRecado <> "0" then
		sql = sql & " AND SEG_USUARIOS_SISTEMA.CODIGO_DEPARTAMENTO = " & intCodDepartamentoRecado
	end if
	sql = sql & " order by 2"
	RS.OPEN SQL, CNN
%>
	<select name="cmbDepartamentoRecado" id="cmbDepartamentoRecado" style="width:150pt" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodDepartamentoRecado) = trim(rs("Codigo")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>