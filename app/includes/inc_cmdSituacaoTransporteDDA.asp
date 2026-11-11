<%
	if strExecutarSubmitSituacaoTransporteDDA = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbSituacaoDDA" id="cmbSituacaoDDA" class="form-control" style="width: 200px" <%=strFuncao%>>
  <option value="D" <%if strSituacaoDDA = "D" then response.Write("selected") %>>Deferido</option>
  <option value="I" <%if strSituacaoDDA = "I" then response.Write("selected") %>>Indeferido</option>
  <option value="T" <%if strSituacaoDDA = "T" then response.Write("selected") %>>Devolver ao Transporte</option>
</select>
