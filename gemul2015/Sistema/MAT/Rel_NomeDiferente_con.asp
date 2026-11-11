<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 22/12/2016
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.b
	::	Objetivo Pagina...: Nomes Diferentes
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
		caminho = "Rel_NomeDiferente_rel.asp"
		frm.action = caminho;
		frm.submit();
		return true;	
	}
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_NomeDiferente_con.asp"
	
	
	intCodEmpresaUsuario 		= request.Form("cmdEmpresaUsuario")
	intQtde		 				= request.Form("txtQtde")
	strAnoLetivo	= session("strAnoLetivo")
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<table width="100%" height="325" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
		  <td height="22" align="center" class="tituloSistema">Rela&ccedil;&atilde;o de  Matrícula </td>
	</tr>
		<tr valign="top">
		  <td align="center">
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr><td width="60%" valign="top" class="texto1"><table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr></tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
        <tr>
          <td width="14%" height="20" class="texto">Unidade:</td>
          <td width="86%"><!--#include file="../includes/inc_cmdEmpresaUsuario.asp" --></td>
        </tr>
		<tr>
            <td height="20" class="texto">Ano Letivo:</td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>        
        <tr>
          <td height="20" class="texto">Filtro:</td>
          <td class="texto"><input name="txtQtde" type="text" class="text" id="txtQtde" value="<%=intQtde%>" size="5" maxlength="5" >
            caracteres iniciais ser&atilde;o comparados</td>
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
