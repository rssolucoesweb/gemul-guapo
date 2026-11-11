<select name="cmbSituacao" id="cmbSituacao" class="form-control">
	<option <%if situacao = "A" then response.write "selected"%> value="A">Em aberto</option>
	<option <%if situacao = "E" then response.write "selected"%> value="E">Encerrado</option>
</select>