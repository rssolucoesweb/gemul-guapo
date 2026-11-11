<!--
	::	Desenvolvido por..: Supera webX - www.superawebx.com.br"
	::	Data de Criação...: 05/03/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Consulta Modulos Sistema
-->
<%	
	if strSiglaSistema = "" then strSiglaSistema = 0  	
	
	sql = "SELECT Modu_Sist_Sigl, Modu_Sigl, Modu_Desc, Modu_Stat"
	sql = sql & " FROM SEG_MODULOS_SISTEMA"
	sql = sql & " WHERE Modu_Sist_Sigl = '" & strSiglaSistema  & "'"
	RS.OPEN SQL, CNN
%>
<select name="cmbModulosSistema" id="cmbModulosSistema" style="width:350pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strSiglaModulo) = trim(rs("Modu_Sigl")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Modu_Sigl")& " " & strSelecionado &">" & rs("Modu_Sigl") & " - " & rs("Modu_Desc") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>