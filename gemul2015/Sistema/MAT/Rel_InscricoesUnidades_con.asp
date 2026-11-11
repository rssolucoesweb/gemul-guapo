<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 19/11/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Mapa Geral de Inscrições - Matricula 
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
		
		
		if (frm.cmbTipoCurso.value == "0") {
			alert("O  Curso deve ser informado !");
			frm.cmbTipoCurso.focus();
			return false;
		}
	
		caminho = "Rel_InscricoesUnidades_rel.asp"
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
	strPaginaTitulo = "Mapa Geral de Inscrições"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<table width="100%" height="315" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
		  <td height="22" align="center" class="tituloSistema">Mapa Geral de Inscrições</td>
	</tr>
		<tr valign="top">
		  <td align="center">
            <br>
            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr><td width="60%" valign="top" class="texto1">
           	  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr></tr>
              </table>
                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
                  <tr>
                    <td width="7%" height="20" class="texto">Curso:</td>
                  <td width="93%"><span class="titulo1">
                      <!--#include file="../includes/inc_cmbTipoCurso.asp"-->
                    </span></td>
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
