<!--
	::	Data de Criação...: 
	::	Desenvolvedores...: 
	::	Objetivo Pagina...: Padronizar os botões de todas as páginas do sistema
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
   	  <td>
		<input class="botao" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="return reload()">
		<input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%> onClick="return limpar('<%=strPagina%>')">&nbsp;
		<input type="button" name="cmdVoltar" style="cursor:hand"   value="Fechar"  class="botao" <%=strDesabilitaPrincipal%> onClick="window.close()">
        </td>
    </tr>
</table>
