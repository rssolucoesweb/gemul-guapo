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
		<input class="btn-u float-shadow" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="submit()">
		<input type="button" name="cmdLimpar"  value="Limpar"  class="btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onclick="window.location.href='<%=strPagina%>';">&nbsp;
		<input type="button" name="cmdPrincipal"  value="Principal"  class="btn-u btn-u-default float-shadow" <%=strDesabilitaPrincipal%> onClick="window.location='default.asp'">
        <%if strBotaoVoltaTelaAnterior <> "" then%>
        <input type="button" name="cmdVoltar"  value="Voltar"  class="btn-u float-shadow" <%=strDesabilitaPrincipal%> onClick="window.location='<%=strBotaoVoltaTelaAnterior%>'">
        <%end if%>
		<%if strBotaoIncluirNovaRemocao <> "" then%>
        <input type="button" name="cmdVoltar"  value="Incluir Nova Solicita&ccedil;&atilde;o"  class="btn-u btn-u-blue float-shadow" <%=strDesabilitaPrincipal%> onClick="window.location='Pedidoremocao_cad.asp'">
        <%end if%>
    </tr>
</table>
