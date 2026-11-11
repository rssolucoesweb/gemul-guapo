<%
if strPaginaDestino = "Fechar" then strPaginaDestino = "window.close()"
if strPaginaDestino = "" then strPaginaDestino = "window.history.back()"
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
.TabelaImprime{
	height: 50px;
    width: 50px;
    position: fixed;
    top: 0;
    transition: 0.5s;
	}
</style>

<map name="Map">
  <area shape="rect" coords="108,2,140,32" href="#" alt="Voltar" onclick="<%=strPaginaDestino%>">
  <area shape="rect" coords="75,2,107,32" href="#" alt="Imprimir" onClick="window.print()">
</map>

<div id="imprimir" style="position:absolute;" class="noPrint">
  <table width="100%" border="0" class="TabelaImprime">
    <tr> 
      <td>
	  	<img src="/app/img/botao_rel.png" border="0" usemap="#Map">&nbsp;&nbsp;	
      </td>
    </tr>
  </table>
</div>
