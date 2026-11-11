<!--
	::	IMOB
	::	Data de Criação...: 16/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir os tipo de acesso existentes em um combobox 
	::	Data Atualizacao..: 
-->
<%
IF StrReloadGrupo = "" then 'Verifica se é para dar o reload na página
	strOnChangeGrupo = ""
else
	strOnChangeGrupo="onChange='return reload()'"
end if
%>
<select name="cmbGrupo" id="cmbGrupo" class="combo"  style="width:200pt" <%=strOnChangeGrupo%> >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from SEG_Grupo"
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if trim(intCodGrupo) = trim(rs("codigo")) then
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