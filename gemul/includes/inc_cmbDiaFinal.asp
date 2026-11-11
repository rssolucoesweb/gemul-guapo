<select name="cmbDiaFinal" id="cmbDiaFinal" class="combo"  style="width:35pt">
	<option value="0">...</option>
	<%
	for i=1 to 31
		%><option <%if intDiaFinal=i then response.Write("selected")%> value="<%=i%>"><%=i%></option><%
	next
	%>
</select>