<select name="cmbSexo" id="cmbSexo" class="form-control">
	<option value="0">Selecione...</option>
	<option <%if sexo = "M" then response.write "selected"%> value="M">MASCULINO</option>
	<option <%if sexo = "F" then response.write "selected"%> value="F">FEMININO</option>
</select>