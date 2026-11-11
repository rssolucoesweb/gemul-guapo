<select <%=strDesabilitaEnvio%>  name="cmbMes" id="cmbMes" class="form-control" >
  <option  value="0">..LIBERADO..</option>
  	<%
	For i = 1 to 12
	%>
  		<option value="<%=i%>" <%if cstr(i)=cstr(strMes) then%>selected<%end if%>><%=ucase(monthname(i))%></option>
  	<%
	Next	
	%>
</select>
