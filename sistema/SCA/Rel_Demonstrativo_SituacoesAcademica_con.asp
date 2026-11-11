<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
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
		
		frm.action = "Rel_Demonstrativo_SituacoesAcademica_rel.asp";
		frm.submit();
		return true;	

	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_Demonstrativo_SituacoesAcademica_con.asp"

	strExecutarSubmitSemestre = "S"
	
	intSemestre 			= Trim(Request.Form("cmbSemestre"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if intCodSemestre = "" then intCodSemestre = "0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
	<td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
</tr>
<tr valign="top">
<td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
	  <tr>
        <td width="12%" class="texto1">Ano Letivo:</td>
	    <td width="88" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
	    </tr>
	  <tr>
        <td class="texto1">Semestre:</td>
	    <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
	    </tr>
     <tr>
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
<br>
<br>		 
</td>
</tr>
</table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
