<select name="cmbContratado" id="cmbContratado" class="combo"  style="width:250pt" >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, razaosocialNome "
	sql = sql & " from SCC_beneficiario "
	sql = sql & " where codEmpresa = " & session("CodEmpresa")
	sql = sql & " order by razaosocialNome "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if trim(intCodContratado) = trim(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("razaosocialNome") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>