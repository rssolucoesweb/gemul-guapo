<%
if strSubmitDepto = "S" then
	strSubmitDepto = "onchange='submit()'"
else
	strSubmitDepto = ""
end if
%>

<select name="cmbDepartamento" id="cmbDepartamento" class="combo"  style="width:250pt" <%=strSubmitDepto%> >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from EST_departamento "
	sql = sql & " where cod_Empresa = " & session("Codempresa")
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
