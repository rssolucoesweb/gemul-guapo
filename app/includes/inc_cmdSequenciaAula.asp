<%
	if strExecutarSubmitSequenciaAula = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbSequenciaAula" id="cmbSequenciaAula" class="form-control" <%=strFuncao%>>
  <option value="0">Selecione...</option>
  <% for i=1 to 10%>
  <option value="<%=i%>" <%if trim(intCodSequenciaAula) = trim(i) then response.Write("selected") %>><%=i%>ª Aula</option>
  <% next%>
</select>