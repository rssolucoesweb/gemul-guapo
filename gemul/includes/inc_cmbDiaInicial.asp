<select name="cmbDiaInicial" id="cmbDiaInicial" class="combo"  style="width:35pt">
	<option value="0">...</option>
	<%
	for i=1 to 31
		%><option <%if intDiaInicial=i then response.Write("selected")%> value="<%=i%>"><%=i%></option><%
	next
	%>
</select>