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
		var caminho;
		caminho = "Rel_Reserva_rel.asp"
		frm.action = caminho;
		frm.submit();
		return true;	
	}
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "Rel_Reserva_rel.asp"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<table width="100%" height="325" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
		  <td height="22" align="center" class="tituloSistema">Rela&ccedil;&atilde;o de Cadastro de Reservas na Matricula <%=year(date)%></td>
	</tr>
		<tr valign="top">
		  <td align="center">
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr><td width="60%" valign="top" class="texto1"><table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr></tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">

        <tr>
          <td width="6%" height="20" class="texto">Ordenação:</td>
          <td width="94%">
        <select name="cmbOrdenacao" class="Combo" id="cmbOrdenacao"  style="width:100pt" >
            <option value="0">Selecione...</option>
            <option value="1" <%if intOrdenacao = "1" then response.Write("selected") %>>Incrição</option>
            <option value="2" <%if intOrdenacao = "2" then response.Write("selected") %>>Nome</option>
            <option value="3" <%if intOrdenacao = "3" then response.Write("selected") %>>Seríe</option>
            <option value="4" <%if intOrdenacao = "4" then response.Write("selected") %>>Bairro</option>
        </select>
          </td>
        </tr>
        <tr>
          <td height="2" colspan="2"><hr size="1" color="#CCCCCC"></td>
        </tr>
        <tr>
          <td colspan="2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
            &nbsp;</td>
        </tr>
      </table>      
      <strong></strong></td>
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
