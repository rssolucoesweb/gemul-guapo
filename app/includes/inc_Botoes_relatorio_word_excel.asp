<%
if strPaginaDestino = "Fechar" then strPaginaDestino = "window.close()"
%>

<SCRIPT ID=clientEventHandlersVBS LANGUAGE=vbscript>
	sub window_onbeforeprint()
		imprimir.style.display="none"
	end sub
	sub window_onafterprint()
		imprimir.style.display="block"
	end sub
</script>

<style type="text/css">
@media print 
{
    .noPrint 
    {
        display: none;
    }    
}
</style>

<div id="imprimir" style="position:absolute;" class="noPrint">
  <table width="100%" border="0" class="TabelaImprime">
    <tr bgcolor="#f6f6f6"> 
      <td>
	  	<a href="#" onclick="window.location='<%=strExportarExcel%>'"><img src="/app/img/botao_icone_excel.png" border="0"></a>
	  	<a href="#" onclick="window.location='<%=strExportarWord%>'"><img src="/app/img/botao_icone_word.png" border="0"></a>
	  	<a href="#" onclick="window.print()"><img src="/app/img/botao_icone_imprimir.png" border="0"></a>
		<% if strPaginaDestino = "" then%>
		<a href="#" onclick="window.history.back()"><img src="/app/img/botao_icone_voltar.png" border="0"></a>
		<%else%>
	  	<a href="#" onclick="window.location='<%=strPaginaDestino%>'"><img src="/app/img/botao_icone_voltar.png" border="0"></a>
		<%end if%>
      </td>
    </tr>
  </table>
</div>
