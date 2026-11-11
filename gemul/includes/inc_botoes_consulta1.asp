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
			<input class="botao" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="return Consulta()">
			<%if strMostraBotaoVincular = "S" then%>
				<input type="button" name="cmdVincular"  style="cursor:hand"  value="Vincular"  class="botao" <%=strDesabilitaBotaoVincular%> onclick="return resultadoConsulta()">&nbsp;
			<%end if%>
			<%if strMostraBotaoIncluir = "S" then%>
				<input type="button" name="cmdBtnIncluir"  style="cursor:hand"  value=" Incluir "  class="botao" onclick="return incluirNovo()">
			<%end if%>
			<input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%> onclick="return limpar('<%=strPagina%>')">&nbsp;
			<%if strMostraBotaoConsultaPrincipal = "S" then%>
			<input type="button" name="cmdPrincipal" style="cursor:hand" value="Principal"  class="botao" <%=strDesabilitaPrincipal%> onClick="window.location='default.asp'">
			<%end if%>
			<%if strMostraBotaoConsultaRetornar = "S" then%>
			<input class="botao" type="button" value=" Retornar " name="BtnFechar" onClick="window.close()">
			<%end if%>
		</td>
    </tr>
</table>
