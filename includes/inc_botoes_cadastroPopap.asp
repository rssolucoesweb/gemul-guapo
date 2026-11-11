<% if session("UsuarioWeb") = "USUARIO.TESTE" then
	strDesabilitaIncluir = " Disabled "
	strDesabilitaAlterar = " Disabled "
	strDesabilitaExcluir = " Disabled "
end if
%>
 <div class="margin-bottom-30">
		<input type="button" name="cmdIncluir" style="cursor:hand"  value="Incluir"  class="btn btn-u float-shadow" <%=strDesabilitaIncluir%> onclick="return salvar('I')">
		<input type="button" name="cmdAlterar" style="cursor:hand"  value="Alterar"  class="btn btn-u btn-u-blue float-shadow" <%=strDesabilitaAlterar%> onclick="return salvar('A')">
		<input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"   class="btn btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onClick="window.location='<%=strPagina%>'">
        <%if strRetiraBotaoExcluir="" then%>
		<input type="button" name="cmdExcluir" style="cursor:hand"  value="Excluir"  class="btn btn-u btn-u-red float-shadow" <%=strDesabilitaExcluir%> onclick="return salvar('E')">
        <%end if%>
		<%if strRetiraBotaoRecibo="S" then%>
        <input type="button" name="cmdRecibo" style="cursor:hand"  value="Emitir Serviço"  class="btn btn-u btn-u-red float-shadow" <%=strDesabilitaRecibo%> onclick="return abreConsulta('Recibo_servico_rel.asp?id=<%=id%>')">
        <%end if%>
        <input type="button" name="cmdFechar" style="cursor:hand"   value="Fechar"   class="btn btn-u btn-u-brown float-shadow" onClick="window.close()">
</div>
