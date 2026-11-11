
<select name="cmbAcessoProduto" id="cmbAcessoProduto" class="combo"  style="width:170pt" >
	<option <%if strAcessoProduto = "TODOS" then response.Write("selected")%> 			value="TODOS">Todos podem ver esse Produto</option>
	<option <%if strAcessoProduto = "ADMINISTRACAO" then response.Write("selected")%> 	value="ADMINISTRACAO">Somente o Administrativo</option>
	<option <%if strAcessoProduto = "UNIDADE_ESCOLA" then response.Write("selected")%> 	value="UNIDADE_ESCOLA">Somente as Unidade Escolares</option>
	<option <%if strAcessoProduto = "EMEI" then response.Write("selected")%> 			value="EMEI">Somente os EMEI</option>
</select>