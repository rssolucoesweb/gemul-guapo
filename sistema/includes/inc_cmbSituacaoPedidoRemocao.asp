<select name="cmbSituacaoPedidoRemocao" id="cmbSituacaoPedidoRemocao" style="width:230pt" class="form-control" onchange="submit()">
	<option <%if strSituacaoPedidoRemocao = "" or strSituacaoPedidoRemocao = "0" then response.write "selected"%> value="0">Todos...</option>
	<%if tiraSolicitado = "" then%>
    <option <%if strSituacaoPedidoRemocao = "A" then response.write "selected"%> value="A">Solicitado</option>
	<%end if%>
    <option <%if strSituacaoPedidoRemocao = "G" then response.write "selected"%> value="G">Aguardando Autorização</option>
    <option <%if strSituacaoPedidoRemocao = "N" then response.write "selected"%> value="N">Não Atendido</option>
    <option <%if strSituacaoPedidoRemocao = "F" then response.write "selected"%> value="F">Atendido</option>
</select>
