<select name="cmbQtdeIrmaoEscola" id="cmbQtdeIrmaoEscola" class="form-control" <%=strDisabilitaCombo%>>
  <option value="0">Selecione...</option>
  <% for i=1 to 15%>
  <option value="<%=i%>" <%if TRIM(intQtdeIrmaoEscola) = TRIM(i) then response.Write("selected") %>><%=i%></option>
  <% next%>
</select>