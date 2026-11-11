<select name="cmbStatus" id="cmbStatus" style="width:100pt" class="form-control">
  <option value="0">Selecione...</option>
  <option value="A" <%if strStatus = "A" then response.Write("selected") %>>A - Ativo</option>
  <option value="I" <%if strStatus = "I" then response.Write("selected") %>>I - Inativo</option>
</select>
