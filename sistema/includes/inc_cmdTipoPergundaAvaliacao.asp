<select name="cmbTipoPerguntaAvaliacao" id="cmbTipoPerguntaAvaliacao" style="width:100pt" class="form-control">
  <option value="0">Selecione...</option>
  <option value="O" <%if strTipoPerguntaAvaliacao = "O" then response.Write("selected") %>>Objetiva</option>
  <option value="D" <%if strTipoPerguntaAvaliacao = "D" then response.Write("selected") %>>Discursiva</option>
</select>
