<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: FonteRecurso
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<select name="cmbFonteRecurso" id="cmbFonteRecurso" class="combo"  style="width:250pt">
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, numero, descricao "
	sql = sql & " from SCC_fonte_recurso "
	sql = sql & " where codEmpresa = " & session("CodEmpresa")
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodFonteRecurso) = cstr(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("numero") & " - " & rs("descricao") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>