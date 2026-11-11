<!--
	::	Desenvolvido por..: Supera webX - www.superawebx.com.br"
	::	Data de Criação...: 07/03/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Consulta Menus
-->
<%	
	if strSiglaSistema = "" then strSiglaSistema = 0  
	if strSiglaModulo = "" then strSiglaModulo = 0  	
	
	sql = "SELECT Menu_Sist_Sigl, Menu_Modu_Sigl, Menu_Codg, Menu_Desc, Menu_Numr_Posicao"
	sql = sql & " FROM SEG_MENUS_SISTEMA"
	sql = sql & " WHERE Menu_Sist_Sigl = '" & strSiglaSistema  & "'"
	sql = sql & " AND Menu_Modu_Sigl = '" & strSiglaModulo  & "'"
	sql = sql & " ORDER BY Menu_Codg"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbMenu" id="cmbMenu" style="width:350pt" class="form-control" onChange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodMenu) = trim(rs("Menu_Codg")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Menu_Codg")& " " & strSelecionado &">" & rs("Menu_Codg") & " - " & rs("Menu_Desc") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
