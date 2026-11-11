<select name="cmbSituacaoUsuario" class="Combo" id="cmbSituacaoUsuario" style="width:100pt">
    <option value="0">Selecione...</option>
    <option value="A" <%if strSituacaoEmpresa = "A" then response.Write("selected") %>>Ativo</option>
    <option value="I" <%if strSituacaoEmpresa = "I" then response.Write("selected") %>>Inativo</option>
    <option value="B" <%if strSituacaoEmpresa = "B" then response.Write("selected") %>>Bloqueado</option>
</select>
