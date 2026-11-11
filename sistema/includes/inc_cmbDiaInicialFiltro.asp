<select name="cmbDiaInicialFiltro" id="cmbDiaInicialFiltro" class="form-control"  style="width:35pt" onchange="submit()">
	<option value="0">...</option>
	<%
	for i=1 to 31
		%><option <%if trim(intDiaInicialFiltro)=trim(i) then response.Write("selected")%> value="<%=i%>"><%=i%></option><%
	next
	%>
</select>