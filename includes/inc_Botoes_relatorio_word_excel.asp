<SCRIPT ID=clientEventHandlersVBS LANGUAGE=vbscript>
	sub window_onbeforeprint()
		imprimir.style.display="none"
	end sub
	sub window_onafterprint()
		imprimir.style.display="block"
	end sub	S
</script>
<map name="Map"> 
  <!--area shape="rect" coords="108,2,140,32" href="#" alt="Voltar" onclick=""-->
  <area shape="rect" coords="106,1,138,31" 	href="#" alt="Exportar para Word" 	onclick="window.location='<%=strExportarWord%>'" >
  <area shape="rect" coords="138,1,168,33" 	href="#" alt="Exportar para Excel" 	onclick="window.location='<%=strExportarExcel%>'" />
  <%if fecharRel="S" then%>
  <area shape="rect" coords="168,1,196,30" href="javascript:window.close()" alt="Fechar" >
  <%else%>
  <area shape="rect" coords="168,1,196,30" href="javascript:history.go(-1)" alt="Voltar" >
  <%end if%>
  <area shape="rect" coords="75,1,107,31" 	href="#" alt="Imprimir" 			onClick="window.print()">
</map>
<div id="imprimir" style="position:absolute;">
  <table width="100%" border="0" class="TabelaImprime">
    <tr> 
      <td>
	  	<img src="/images/botoes_relatorio_word_excel.gif" border="0" usemap="#Map">&nbsp;&nbsp;	
      </td>
    </tr>
  </table>
</div>
