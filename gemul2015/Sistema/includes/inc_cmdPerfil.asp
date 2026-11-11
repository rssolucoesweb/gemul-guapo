<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/03/2010
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de perfil
-->
<%	
	if strExecutarSubmitPerfil = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT PERF_CODG, PERF_DESC"
	sql = sql & " FROM SEG_PERFIS_SISTEMA"
	if intCodSistema <> "0" then
		sql = sql & " where PERF_SIST_SIGL = '" & intCodSistema & "'"
	end if
	sql = sql & " Order by PERF_DESC"
	RS.OPEN SQL, CNN
%>
<select name="cmdPerfil" id="cmdPerfil" style="width:250pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPerfil) = trim(rs("PERF_CODG")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("PERF_CODG")& " " & strSelecionado &">" & rs("PERF_DESC") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>