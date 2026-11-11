<%
	if strExecutarFuncaoIdade = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbIdade" id="cmbIdade" class="form-control" <%=strFuncao%>>
  <option  value="0">Selecione...</option>
  	<%
	For i = 1 to 100
		%>
  		<option value="<%=i%>" <%if cInt(i)=cInt(strIdade) then%> selected<%end if%>><%=i%></option>
 		<%
	Next									
	%>
</select>
