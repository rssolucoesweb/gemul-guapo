<select name="cmbOpcao" id="cmbOpcao" style="width:70pt" class="combo">
  <option value="0">Selecione...</option>
  <option value="S" <%if strOpcao = "S" then response.Write("selected") %>>Sim</option>
  <option value="N" <%if strOpcao = "N" then response.Write("selected") %>>Não</option>
</select>
