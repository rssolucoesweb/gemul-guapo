<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/11/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Usuario
-->
<%
	if intCodGrupo = "" then intCodGrupo = "0"
	
	sql = " select DISTINCT CODIGO_SEG_USUARIOS_SISTEMA as USUA_CODG"
	sql = sql & " FROM SEG_USUARIOS_EMPRESA "
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA "
	sql = sql & " INNER JOIN SEG_USUARIOS_SISTEMA ON SEG_USUARIOS_SISTEMA.USUA_CODG = SEG_USUARIOS_EMPRESA.CODIGO_SEG_USUARIOS_SISTEMA"
	sql = sql & " LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO "
	sql = sql & " WHERE 1=1 "
	sql = sql & " And USUA_STAT = 'A'"
	sql = sql & " AND SEG_GRUPO.codigo = " & intCodGrupo
	
	if intCodEmpresaUsuario <> "0" then 
		sql = sql & " AND SEG_USUARIOS_EMPRESA.COD_EMPRESA = " & intCodEmpresaUsuario
	end if
	sql = sql & " order by 1"
	RS.OPEN SQL, CNN
%>
<select name="cmbUsuario" id="cmbUsuario" style="width:150pt" class="form-control">
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodUsuario) = trim(rs("USUA_CODG")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("USUA_CODG")& " " & strSelecionado &">" & ucase(rs("USUA_CODG")) & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>