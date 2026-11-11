<% if session("UsuarioWeb") = "USUARIO.TESTE" then
	strDesabilitaIncluir = " Disabled "
	strDesabilitaAlterar = " Disabled "
	strDesabilitaExcluir = " Disabled "
end if
%>
<!--
	::	SIGE
	::	Data de Criação...: 10/12/2006
	::	Desenvolvedores...: Roberto Barbosa Silva
	::	Objetivo Pagina...: Padronizar os botões de todas as páginas do sistema
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<%
	if strTextoBotaoRel = "" then strTextoBotaoRel ="Gerar Relat&oacute;rio"
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
			<input type="button" name="cmdGerar" value="<%=strTextoBotaoRel%>" class="btn-u float-shadow" <%=strDesabilitaGerar%> onclick="return gerar()">					
			<input type="button" name="cmdLimpar"  value="Limpar"  class="btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%>  onclick="window.location='<%=pagina%>'">
			<input type="button" name="cmdPrincipal"  value="Principal"  class="btn-u btn-u-default float-shadow" <%=strDesabilitaPrincipal%> onClick="window.location='default.asp'">
		</td>
    </tr>
</table>
