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
		
		if (frm.cmbRota.value == 0){
			alert("A Rota deve ser informada!");
			frm.cmbRota.focus();
			return false;
		}
		
		frm.action = "Rel_Rota_rel.asp";
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
	strPaginaTitulo 		= "Rel_Rota_con.asp"
	intCodRota 				= Trim(Request.Form("cmbRota"))
	intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
	intDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
%>
<form method="post" id="frm" action="#">
<table width="100%" height="30" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
		  <td width="700" height="18" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
	</tr>
		<tr valign="top">
		  <td height="12" align="center"><table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
            <tr>
              <td width="68" height="29" class="texto1">Rota:</td>
              <td width="1250"><!--#include file="../includes/inc_cmdRotaUnidade.asp"--></td>
            </tr>
            <tr>
              <td class="texto1">Ordem:</td>
              <td><select name="cmbOrdem" class="Combo" id="cmbOrdem"  style="width:100pt" >
                  <option value="alfabetica" >Alfabetica</option>
                  <option value="Turma" >Turma</option>
              </select></td>
            </tr>
            <tr>
              <td height="13" colspan="2"><hr size="1" color="#CCCCCC"></td>
            </tr>
            <tr>
              <td colspan="2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                &nbsp;</td>
            </tr>
          </table></td>
</tr>
</table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
