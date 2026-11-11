<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_cmdVerificaAvaliacao.asp"-->
<!--#include file=topo.asp-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function gerar(){
		window.open("PortalAluno_Ocorrencias_rel.asp","popup","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=900, height=600, left=0, top=0");			
 	}
</script>
<%
	principal			= "principal.asp"
%>
<table width="100%" height="355" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF">
  <tr valign="top">
    <td align="center">
	<form method="post" id="frm">	
	  <table width="96%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal"><strong>OCORR&Ecirc;NCIAS </strong></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
        </tr>
      </table>
	  </form>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>