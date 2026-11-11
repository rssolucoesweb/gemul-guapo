<%
	if strExecutarSubmitMes = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
%>

<select <%=strDesabilitaEnvio%>  name="cmbMes" id="cmbMes" class="form-control" <%=strFuncao%>>
  <option  value="0">Selecione...</option>
  	<%
	For i = 1 to 12
	%>
  		<option value="<%=i%>" <%if cstr(i)=cstr(strMes) then%>selected<%end if%>><%=ucase(monthname(i))%></option>
  	<%
	Next	
	%>
</select>
