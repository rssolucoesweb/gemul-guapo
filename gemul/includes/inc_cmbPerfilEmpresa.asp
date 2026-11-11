<%
IF StrReloadPerfilMenu = "N" then
	strOnChangePerfilMenu = ""
else
	strOnChangePerfilMenu="onChange='return reload()'"
end if
%>
<select name="cmbCodPerfilEmpresa" id="cmbCodPerfilEmpresa" class="combo"  style="width:180pt" <%=strOnChangePerfilMenu%> >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from SEG_perfil"
	sql = sql & " where codEmpresa = " & session("codEmpresa")
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodPerfilEmpresa) = cstr(rs("codigo")) then
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