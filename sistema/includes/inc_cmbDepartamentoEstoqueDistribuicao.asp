<%
if strSubmitDepto = "S" then
	strSubmitDepto = "onchange='submit()'"
else
	strSubmitDepto = ""
end if
%>

<select name="cmbDepartamento" id="cmbDepartamento" class="form-control"  style="width:250pt" <%=strSubmitDepto%> >
	<option value="0">Selecione...</option>
	<%
	tipo_usuario = ""
	sql = "SELECT codigo, descricao, tipo "
	sql = sql & " from EST_departamento "
	sql = sql & " where cod_Empresa = " & session("Codempresa")
	sql = sql & " and tipo in ('UNIDADE_ESCOLA','CMEIS','EMEI')"
	sql = sql & " order by tipo, descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if trim(intCodDepartamento) = trim(rs("codigo")) then
				strSelecionado = "selected"
				tipo_usuario = rs("tipo")
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
<input name="tipo_usuario" type="hidden" id="tipo_usuario"  value="<%=tipo_usuario%>">
