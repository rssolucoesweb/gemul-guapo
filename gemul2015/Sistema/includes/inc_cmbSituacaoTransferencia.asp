<select name="cmbSituacaoTransferencia" id="cmbSituacaoTransferencia" style="width:150pt" class="combo" onChange="submit()">
	<option value="0">Todas...</option>
	<option <%if situacao_transferencia = "A" then response.write "selected" %> value="A">Aguardando Atendimento</option>
	<option <%if situacao_transferencia = "F" then response.write "selected" %> value="F">Concluida</option>
	<option <%if situacao_transferencia = "C" then response.write "selected" %> value="C">Cancelada</option>
</select>