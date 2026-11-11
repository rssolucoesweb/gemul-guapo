<head>
<title><%=session("Titulo")%></title>
<link href="estilo/css.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script src="js/js_funcoes_gerais.js"></script>
</head>
<%
	'Apaga todas as sessions
	session.Contents.removeAll()

	strTituloPagina = "Seja Bem Vindo!"
%>
<!--#include file="topo.asp"-->
<!--#include file="Config.asp"-->
<!--include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<table width="900"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td width="209" height="558" align="center" bgcolor="#003366"><!--#include file="Menu.asp"--></td>
    <td width="691" align="center" bgcolor="#FFFFFF"></td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>