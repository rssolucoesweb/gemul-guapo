<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
		<input type="button" name="cmdIncluir" style="cursor:hand"   value="Incluir" class="botaoIncluir" <%=strDesabilitaIncluir%> onClick="return salvar('I')">
		<input type="button" name="cmdAlterar" style="cursor:hand"  value="Alterar" class="botaoAlterar" <%=strDesabilitaAlterar%> onClick="return salvar('A')">
		<input type="button" name="cmdExcluir" style="cursor:hand"  value="Excluir" class="botaoExcluir" <%=strDesabilitaExcluir%> onClick="return salvar('E')">
		<input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"  class="botaoLimpar" <%=strDesabilitaLimpar%> onClick="return limpar('<%=strPagina%>')">
		<input type="button" name="cmdFechar" style="cursor:hand"   value="Fechar"  class="botao" onClick="window.close()"></td> 
    </tr>
</table>