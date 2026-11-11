<select name="cmbSituacao" id="cmbSituacao" style="width:100pt" class="combo">
  <option value="0">Selecione...</option>
  <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
  <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
</select>
