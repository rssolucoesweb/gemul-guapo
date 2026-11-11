<!--
	::	IMOB
	::	Data de Criação...: 12/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir os menus existentes em um combobox 
	::	Data Atualizacao..: 
-->
<%
IF StrReloadPerfilMenu = "N" then 'Verifica se é para dar o reload na página
	strOnChangePerfilMenu = ""
else
	strOnChangePerfilMenu="onChange='return reload()'"
end if
%>
<select name="cmbCodPerfilMenu" id="cmbCodPerfilMenu" class="combo"  style="width:150pt" <%=strOnChangePerfilMenu%> >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from SEG_perfil"
	if strCodEmpresas = "" then
		sql = sql & " where codEmpresa = " & intCodEmpresa
	else
		sql = sql & " where codEmpresa in (" & strCodEmpresas & ")"
	end if
	if strFiltroPerfilMenu <> "" then
		sql = sql & " and codigo in (" & strFiltroPerfilMenu & ")"
	end if
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodPerfil) = cstr(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("descricao") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>