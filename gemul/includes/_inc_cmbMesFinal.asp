<select name="cmbMesFinal" id="cmbMesFinal" class="combo"  style="width:55pt">
	<option value="0">...</option>
	<%
	for i=1 to 12
		%><option value="<%=i%>"><%=ucase(monthName(i))%></option><%
	next
	%>
</select>