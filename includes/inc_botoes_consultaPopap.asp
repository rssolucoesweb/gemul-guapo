<% if session("UsuarioWeb") = "USUARIO.TESTE" then
	strDesabilitaIncluir = " Disabled "
	strDesabilitaAlterar = " Disabled "
	strDesabilitaExcluir = " Disabled "
end if
%>
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
		<input class="btn btn-u float-shadow" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="return submit()">
		<input type="button" name="cmdLimpar"  value="Limpar"  class="btn btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onClick="window.location='<%=strPagina%>'">&nbsp;
		<input type="button" name="cmdFechar" style="cursor:hand"   value="Fechar"  class="btn btn-u btn-u-brown float-shadow" <%=strDesabilitaPrincipal%> onClick="window.close()"></td>
    </tr>
</table>
