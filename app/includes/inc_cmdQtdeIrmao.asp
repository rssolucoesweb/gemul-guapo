<select name="cmbQtdeIrmao" id="cmbQtdeIrmao" class="form-control" <%=strDisabilitaCombo%>>
  <option value="0">Selecione...</option>
  <% for i=1 to 15%>
  <option value="<%=i%>" <%if TRIM(intQtdeIrmao) = TRIM(i) then response.Write("selected") %>><%=i%></option>
  <% next%>
</select>