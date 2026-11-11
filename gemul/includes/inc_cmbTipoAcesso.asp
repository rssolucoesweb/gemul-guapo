<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 20/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Tipo Acesso 
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<%
IF StrReloadTipoAcesso = "" then 'Verifica se é para dar o reload na página
	strOnChangeTipoAcesso = ""
else
	strOnChangeTipoAcesso="onChange='return reload()'"
end if
%>
<select name="cmbCodTipoAcesso" id="cmbCodTipoAcesso" class="combo"  style="width:150pt" <%=strOnChangePerfilMenu%> >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from SEG_tipo_acesso "
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodTipoAcesso) = cstr(rs("codigo")) then
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