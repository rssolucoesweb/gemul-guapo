<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/11/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Departamento
-->
<%
	if strDepartamento_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	SQL = "Select Codigo, Descricao "
	SQL = SQL & " From SEG_DEPARTAMENTO "
	SQL = SQL & " Where SITUACAO = 'A'"
	RS.OPEN SQL, CNN
%>
	<select name="cmbDepartamento" id="cmbDepartamento" style="width:300pt" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodDepartamento) = trim(rs("Codigo")) then
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