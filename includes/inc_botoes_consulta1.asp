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
			<input class="btn btn-u float-shadow" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="Consulta()">
			<%if strMostraBotaoVincular = "S" then%>
				<input type="button" name="cmdVincular"  style="cursor:hand"  value="Vincular"  class="btn btn-u btn-u-blue float-shadow" <%=strDesabilitaBotaoVincular%> onclick="return resultadoConsulta()">&nbsp;
			<%end if%>
			<%if strMostraBotaoIncluir = "S" then%>
				<input type="button" name="cmdBtnIncluir"  style="cursor:hand"  value=" Incluir "  class="btn btn-u float-shadow" onclick="return incluirNovo()">
			<%end if%>
			<input type="button" name="cmdLimpar"  value="Limpar"  class="btn btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onclick="return limpar('<%=strPagina%>')">&nbsp;
			<input class="btn btn-u btn-u-brown float-shadow" type="button" value=" Fechar " name="BtnFechar" onClick="window.close()">
		</td>
    </tr>
</table>
