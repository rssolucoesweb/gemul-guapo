<select name="cmbEtiqueta" id="cmbEtiqueta" style="width:100pt" class="combo">
  <option value="0">Selecione...</option>
  <option value="S" <%if strEtiqueta = "S" then response.Write("selected") %>>Sim</option>
  <option value="N" <%if strEtiqueta = "N" then response.Write("selected") %>>Não</option>
</select>
