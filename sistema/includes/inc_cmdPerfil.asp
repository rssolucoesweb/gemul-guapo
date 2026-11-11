<!--
	::	Desenvolvido por..: Supera webX - www.superawebx.com.br"
	::	Data de Criação...: 07/03/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Consulta Menus
-->
<%	
	if strSiglaSistema = "" then strSiglaSistema = 0  
	
	sql = " SELECT Perf_Codg, Perf_Sist_Sigl, Perf_Desc, SIST_DESC"
	sql = sql & " FROM SEG_PERFIS_SISTEMA, SEG_SISTEMAS_INFORMATICA "
	sql = sql & " WHERE SEG_PERFIS_SISTEMA.Perf_Sist_Sigl = SEG_SISTEMAS_INFORMATICA.SIST_SIGL "
	
	if strSiglaSistema <> "0" then 
		sql = sql & " AND SEG_PERFIS_SISTEMA.Perf_Sist_Sigl LIKE '%" & strSiglaSistema  & "%'"
	end if
	
	if strUsuarioPortal = "0" then 
		sql = sql & " AND SEG_PERFIS_SISTEMA.Perf_Sist_Sigl LIKE '0'"
	end if

	sql = sql & " AND SEG_SISTEMAS_INFORMATICA.SIST_STAT = 'A'" 
	sql = sql & " ORDER BY SIST_DESC"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbPerfil" id="cmbPerfil" style="width:350pt" class="form-control" onChange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPerfil) = trim(rs("Perf_Codg")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Perf_Codg")& " " & strSelecionado &">" &  rs("SIST_DESC") & " - " & rs("Perf_Desc") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
