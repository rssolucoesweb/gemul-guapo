<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 01/12/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Grupo Recado
-->
<%
	if strEmpresaGrupo_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO AS COD_EMPRESA, RAZAOSOCIAL"
	sql = sql & " FROM SEG_EMPRESA"
	sql = sql & " where CODIGO <> " & Session("CodEmpresa")
	sql = sql & " Order by RAZAOSOCIAL, CODIGO"
	RS.OPEN SQL, CNN
%>
	<select name="cmbEmpresaGrupo" id="cmbEmpresaGrupo" style="width:250pt" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodEmpresaGrupo) = trim(rs("COD_EMPRESA")) then
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