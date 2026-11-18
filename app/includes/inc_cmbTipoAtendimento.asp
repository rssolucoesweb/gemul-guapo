<select name="cmbTipoAtendimento" id="cmbTipoAtendimento" class="form-control" onchange="submit()">
	<option value="0">Selecione...</option>
	<option <%if strTipoAtendimento = "ATC" then response.write "selected"%> value="ATC">ATC - Atividade Complementar</option>
</select>