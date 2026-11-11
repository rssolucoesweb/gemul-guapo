<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
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
	Session("strNomeSistema") 	= "SCA"
	Session("strSistema") 		= "SCA"
	Session("strModulo")		= "SCA" 
	Session("MatriculaInformatizada") =  ""
	
	
%>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<form method="post" id="frm">

<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%" height="269" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td colspan="3" align="center">&nbsp;</td>
        </tr>
      <tr>
        <td height="48" colspan="3" align="center" valign="bottom" class="titulo"><!--#include file="../MostraRecados.asp"-->&nbsp;</td>
        </tr>
      <tr>
        <td width="23%" height="83" align="center" valign="bottom" class="titulo">&nbsp;</td>
        <td width="50%" align="center" valign="middle" class="titulo">SCA - Controle Acad&ecirc;mico</td>
        <td width="27%" align="center" valign="middle" class="titulo"><!--include file="../includes/inc_atendimentoOnline.asp"--></td>
        </tr>
      <tr valign="top">
        <% if Session("CodEmpresa") = "8" then %>
           <td colspan="3" align="center" class="texto1"><a href="../../Diversos/RegimentoInterno.pdf">Download - Regimento Interno&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></td>
        <% else %>   
           <td colspan="3" align="center" class="texto1"></td>
        <% end if %>   
      </tr>
      <tr valign="top">
        <td colspan="3" align="center" class="titulo">&nbsp; </td>
      </tr>
    </table>
	</td>
  </tr>
  <tr valign="top">
    <td><!--#include file="../includes/inc_ListaCalendarioAcademico.asp"-->&nbsp;</td>
  </tr>
</table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>