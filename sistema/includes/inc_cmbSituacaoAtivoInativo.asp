<select name="cmbSituacao" id="cmbSituacao" class="form-control">
	<option <%if situacao = "A" then response.write "selected"%> value="A">Ativo</option>
	<option <%if situacao = "I" then response.write "selected"%> value="I">Inativo</option>
</select>