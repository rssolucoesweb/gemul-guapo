<!--
	::	IMOB
	::	Data de Criação...: 16/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir os tipo de acesso existentes em um combobox 
	::	Data Atualizacao..: 
-->
<%
IF StrReloadEmpresa = "" then 'Verifica se é para dar o reload na página
	strOnChangeEmpresa = ""
else
	strOnChangeEmpresa="onChange='return reload()'"
end if
%>
<select name="cmbCodEmpresa" id="cmbCodEmpresa" class="combo"  style="width:200pt" <%=strOnChangeEmpresa%> >
	<option value="0">Selecione...</option>
	<%
	if intCodGrupo = "" then intCodGrupo = "0"
	sql = "SELECT codigo, nomefantazia as descricao "
	sql = sql & " from SEG_empresa "
	sql = sql & " where codGrupo = " & intCodGrupo
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodEmpresa) = cstr(rs("codigo")) then
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