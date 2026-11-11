<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/07/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Menu Principal
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<%
	Session("strNomeSistema") 	= "MAT"
	Session("strSistema") 		= "MAT"
	Session("strModulo")		= "MAT" 
	Session("MatriculaInformatizada") =  "2026"
	Session("MatriculaInformatizadaAnoEfetivacao") = "2026"
%>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<form method="post" id="frm">

<table width="100%" height="285" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="269">
	<table width="100%" height="211" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="17" colspan="3" align="center" valign="bottom" class="titulo">&nbsp;</td>
      </tr>
      <tr>
        <td height="48" colspan="3" align="center" valign="bottom" class="titulo"><!--#include file="../MostraRecados.asp"-->&nbsp;</td>
        </tr>
      <tr>
        <td width="23%" height="83" align="center" valign="bottom" class="titulo">&nbsp;</td>
        <td width="50%" align="center" valign="middle" class="titulo">MAT - Matr&iacute;cula </td>
        <td width="27%" align="center" valign="middle" class="titulo"><!--include file="../includes/inc_atendimentoOnline.asp"--></td>
        </tr>
      <tr valign="top">
        <td height="17" colspan="3" align="center" class="titulo">&nbsp; </td>
      </tr>
    </table>
	</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
  </tr>
</table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>