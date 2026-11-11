<%

if strPaginaDestino = "" then strPaginaDestino = "window.history.back()"
%>
<!--
	::	SIGE
	::	Data de Criação...: 13/09/2004
	::	Desenvolvedores...: Roberto Barbosa Silva 
	::	Objetivo Pagina...: Botões da tela de relatório
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<script>
	//VISUALIZA A IMPRESSÃO DA PÁGINA
	function ieExecWB( intOLEcmd, intOLEparam ) { 
		var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>'; 
		
		document.body.insertAdjacentHTML('beforeEnd', WebBrowser); 
		
		if (!intOLEparam || intOLEparam < -1 || intOLEparam > 1 ) { 
			intOLEparam = 1; 
		} 
		
		WebBrowser1.ExecWB( intOLEcmd, intOLEparam ); 
		WebBrowser1.outerHTML = ""; 
	}
</script>

<SCRIPT ID=clientEventHandlersVBS LANGUAGE=vbscript>
	sub window_onbeforeprint()
		imprimir.style.display="none"
	end sub
	sub window_onafterprint()
		imprimir.style.display="block"
	end sub	
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
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

<map name="Map">
  <area shape="rect" coords="108,2,140,32" href="#" alt="Voltar" onclick="<%=strPaginaDestino%>">
  <!--area shape="rect" coords="108,2,140,32" href="#" alt="Voltar" onclick="window.close()"> -->
  <area shape="rect" coords="75,2,107,32" href="#" alt="Imprimir" onClick="window.print()">
  <area shape="rect" coords="42,2,74,32" href="#" alt="Visualizar Impress&atilde;o"  onClick="ieExecWB(7)">
  <area shape="rect" coords="9,2,41,32" href="#" alt="Configurar P&aacute;gina" onClick="ieExecWB(8)">
</map>

<div id="imprimir" style="position:absolute;" class="noPrint">
  <table width="100%" border="0" class="TabelaImprime">
    <tr> 
      <td>
	  	<% 
		%>
	  	<img src="../../images/botoes_relatorio.gif" border="0" usemap="#Map">&nbsp;&nbsp;	
      </td>
    </tr>
  </table>
</div>
