<select name="cmbSituacaoAcademica" id="cmbSituacaoAcademica" class="form-control">
  <option value="0">Selecione...</option>
  <option value="A" <%if strSituacaoAcademica = "A" then response.Write("selected") %>>Ativo</option>
  <option value="I" <%if strSituacaoAcademica = "I" then response.Write("selected") %>>Inativo</option>
</select>
