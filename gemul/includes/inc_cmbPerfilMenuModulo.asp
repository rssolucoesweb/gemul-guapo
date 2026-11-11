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
<select name="cmbCodPerfilMenuModulo" id="cmbCodPerfilMenuModulo" class="combo"  style="width:150pt" <%=strOnChangePerfilMenu%> >
	<option value="0">Selecione...</option>
	<%
	sql = "select	distinct p.codigo, mo.sigla, p.descricao "
	sql = sql & " from SEG_perfil_menu m"
	sql = sql & " inner join Seg_perfil p on p.codigo = m.codigo_SEG_perfil"
	sql = sql & " inner join Seg_menu me on me.codigo = m.codigo_seg_menu"
	sql = sql & " inner join Seg_modulo mo on mo.codigo = me.codigo_seg_modulo"
	sql = sql & " where me.codigo_seg_modulo = " & intCodModulo
	sql = sql & " order by p.descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodPerfil) = cstr(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("sigla") & " - " & rs("descricao") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>