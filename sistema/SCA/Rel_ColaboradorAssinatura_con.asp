<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 09/10/2012
	::	Desenvolvedores...: Sergio Borges - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Rel. Colaborador Assinatura
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function gerar(){
		var frm = document.getElementById("frm");
		frm.action = "Rel_ColaboradorAssinatura_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_ColaboradorAssinatura_con.asp"
	strSituacao					= Trim(Request.Form("cmbSituacao"))	
	intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))
%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
   <tr>
       <td width="5%" class="texto1">Situa&ccedil;&atilde;o:</td>
       <td width="95%" colspan="4"><!--#include file="../includes/inc_cmdSituacao.asp" --></td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td colspan="4">&nbsp;</td>
     </tr>
    <tr>
      <td colspan="6"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="6"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
<br>
<br>		  </td>
		</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
