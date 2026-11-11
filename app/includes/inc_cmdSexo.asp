<select name="cmbSexo" class="form-control" id="cmbSexo"  >
  <option value="0">Selecione...</option>
  <option value="M" <%if strSexo = "M" then response.Write("selected") %>>Masculino</option>
  <option value="F" <%if strSexo = "F" then response.Write("selected") %>>Feminino</option>
</select>
