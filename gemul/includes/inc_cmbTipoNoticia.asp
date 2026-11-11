<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 20/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Tipo Noticia 
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<select name="cmbTipoNoticia" id="cmbTipoNoticia" class="combo"  style="width:150pt" >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from SIT_TipoNoticia "
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodTipoNoticia) = cstr(rs("codigo")) then
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