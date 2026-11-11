<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/03/2010
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de sistema
-->
<%	
	if strExecutarSubmitSistema = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT SIST_SIGL, SIST_DESC"
	sql = sql & " FROM SEG_SISTEMAS_INFORMATICA"
	sql = sql & " Order by SIST_DESC"
	RS.OPEN SQL, CNN
%>
<select name="cmdSistema" id="cmdSistema" style="width:250pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodSistema) = trim(rs("SIST_SIGL")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("SIST_SIGL")& " " & strSelecionado &">" & rs("SIST_DESC") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>