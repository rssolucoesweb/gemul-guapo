<select name="cmbTipoNacionalidade" class="form-control" id="cmbTipoNacionalidade"  >
  <option value="0">Selecione...</option>
  <option value="1" <%if strTipoNacionalidade = "1" then response.Write("selected") %>>Nascido no Brasil</option>
  <option value="2" <%if strTipoNacionalidade = "2" then response.Write("selected") %>>Nascido no Ext. ou Naturalizado</option>
  <option value="3" <%if strTipoNacionalidade = "3" then response.Write("selected") %>>Estrangeira</option>
</select>
