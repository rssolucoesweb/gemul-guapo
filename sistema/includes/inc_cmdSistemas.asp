<!--
	::	Desenvolvido por..: Supera webX - www.superawebx.com.br"
	::	Data de Criação...: 05/03/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Consulta Modulo
-->
<%	
	sql = "SELECT Sist_Sigl, Sist_Desc, Sist_Stat "
	sql = sql & " FROM SEG_SISTEMAS_INFORMATICA"
	sql = sql & " ORDER BY Sist_Sigl"
	RS.OPEN SQL, CNN
%>
<select name="cmbSistemas" id="cmbSistemas" style="width:350pt" class="form-control" onChange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strSiglaSistema) = trim(rs("Sist_Sigl")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Sist_Sigl")& " " & strSelecionado &">" & rs("Sist_Sigl") & " - " & rs("Sist_Desc") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>