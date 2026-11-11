<select name="cmbSituacaoDisciplinaAbreviado" id="cmbSituacaoDisciplinaAbreviado" style="width:100pt" class="combo">
  <option value="0">Selecione...</option>
  <option value="CR" <%if strSituacaoDisciplinaAbreviado = "CR" then response.Write("selected") %>>CR - Curricular</option>
  <option value="DE" <%if strSituacaoDisciplinaAbreviado = "DE" then response.Write("selected") %>>DE - Dependência</option>
  <option value="DI" <%if strSituacaoDisciplinaAbreviado = "DI" then response.Write("selected") %>>DI - Dispensa</option>
</select>
