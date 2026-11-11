<%
	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbTipoAvaliacao" id="cmbTipoAvaliacao" style="width:100pt" class="form-control" <%=strFuncao%>>
  <option value="0">Selecione...</option>
  <option value="1" <%if intTipoAvaliacao = "1" then response.Write("selected") %>>1 - Curricular</option>
  <option value="2" <%if intTipoAvaliacao = "2" then response.Write("selected") %>>2 - Não Curricular</option>
</select>
