<select name="cmbDepartamento" id="cmbDepartamento" class="combo"  style="width:250pt" onchange="submit()" >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from est_departamento "
	sql = sql & " where situacao = 'A' and cod_Empresa = " & session("CodEmpresa")
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if trim(intCodDepartamento) = trim(rs("codigo")) then
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