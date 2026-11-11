<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo estado civil
-->
<%	
	sql = "SELECT COD_ESTADOCIVIL, DESC_ESTADOCIVIL"
	sql = sql & " FROM SCA_ESTADOCIVIL"
	sql = sql & " Order by DESC_ESTADOCIVIL"
	RS.OPEN SQL, CNN
%>
<select name="cmbEstadoCivil" id="cmbEstadoCivil" style="width:150pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodEstadoCivil) = trim(rs("COD_ESTADOCIVIL")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_ESTADOCIVIL")& " " & strSelecionado &">" & rs("DESC_ESTADOCIVIL") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>