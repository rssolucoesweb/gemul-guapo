<%
	if strAnoAtual = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbAno" id="cmbAno" class="combo" <%=strFuncao%> >
  <option  value="0">Selecione...</option>
  	<%
	For i = year(date) - 5 to year(date) + 5
  	%>
  		<option value="<%=i%>" <%if cstr(i) = cstr(strAno) then response.Write("selected")%>><%=i%></option>
  	<%
	Next									
	%>
</select>
</strong>