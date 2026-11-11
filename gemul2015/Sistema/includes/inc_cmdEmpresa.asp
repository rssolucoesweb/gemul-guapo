<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Empresas
-->
<%	
	if strExecutarSubmitEmpresa = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if strExecutarSubmitEmpresaImportacao = "S" then
		strFuncao = "onchange='carregaEmpresa()'"
	end if

	sql = "SELECT CODIGO, RAZAOSOCIAL"
	sql = sql & " FROM SEG_EMPRESA"
	sql = sql & " Order by RAZAOSOCIAL, CODIGO"
	RS.OPEN SQL, CNN
%>
<select name="cmdEmpresa" id="cmdEmpresa" style="width:300pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodEmpresa) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & ucase(rs("RAZAOSOCIAL")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>