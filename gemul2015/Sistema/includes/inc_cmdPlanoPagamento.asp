<select name="cmbPlanoPagamento" id="cmbPlanoPagamento" style="width:150pt" class="combo">
  <option value="0">Selecione...</option>
  <option value="1" <%if intCodPlanoPagamento = "1" then response.Write("selected") %>>Plano A</option>
  <option value="2" <%if intCodPlanoPagamento = "2" then response.Write("selected") %>>Plano B</option>
</select>
