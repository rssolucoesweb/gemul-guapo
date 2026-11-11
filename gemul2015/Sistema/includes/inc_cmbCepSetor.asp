<select name="cmbCepSetor" id="cmbCepSetor" style="width:150pt" class="combo" onchange="submit()">
	<option value="0">Selecione...</option>
	<option <%if CepSetor = "749" then response.write "selected"%> value="749">CEPs de Aparecida</option>
	<option <%if CepSetor = "999" then response.write "selected"%> value="999">Outros CEPs</option>
</select>