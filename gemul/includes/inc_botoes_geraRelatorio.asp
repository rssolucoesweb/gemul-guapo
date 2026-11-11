<!--
	::	SIGE
	::	Data de Criação...: 10/12/2006
	::	Desenvolvedores...: Roberto Barbosa Silva
	::	Objetivo Pagina...: Padronizar os botões de todas as páginas do sistema
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<%
	if strTextoBotaoRel = "" then strTextoBotaoRel ="Gerar Relatório"
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
			<input type="button" name="cmdGerar" value="<%=strTextoBotaoRel%>" class="botao" <%=strDesabilitaGerar%> onclick="return gerar()">					
			<input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onclick="return limpar('<%=pagina%>')">
			<input type="button" name="cmdPrincipal"  value="Principal"  class="botao" <%=strDesabilitaPrincipal%> onClick="window.location='default.asp'">
		</td>
    </tr>
</table>
