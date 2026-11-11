<select name="cmbSituacao" id="cmbSituacao" class="form-control">
	<option value="0">Selecione...</option>
	<option <%if strSituacao = "A" then response.write "selected"%> value="A">ATIVO</option>
	<option <%if strSituacao = "I" then response.write "selected"%> value="I">INATIVO</option>
</select>