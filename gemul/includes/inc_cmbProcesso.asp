<select name="cmbProcesso" id="cmbProcesso" class="combo"  style="width:300pt" >
	<option value="0">Selecione...</option>
	<%
	sql = " select _p.codigo, _p.numero, _a.descricao as assunto, _m.descricao as modalidade "
	sql = sql & " from SCC_processo _p"
	sql = sql & " left join SCC_assunto _a on _a.codigo = _p.codAssunto and _a.codEmpresa = _p.codEmpresa"
	sql = sql & " left join SCC_modalidade _m on _m.codigo = _p.codModalidade and _a.codEmpresa = _m.codEmpresa"
	sql = sql & " where _p.situacao = 'A' "
	sql = sql & " order by 2"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodProcesso) = cstr(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("numero") & " | " & rs("Modalidade") & " | " & rs("assunto") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>