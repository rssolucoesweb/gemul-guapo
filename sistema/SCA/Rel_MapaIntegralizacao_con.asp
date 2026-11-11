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
		var caminho;
		caminho = "Rel_MapaIntegralizacao_rel.asp"

		if (frm.txtIntervaloPercInicial.value == "") {
			alert("O percentual para a classificação deverá ser informado!");
			frm.txtIntervaloPercInicial.focus();
			return false;
		}

		if (frm.txtIntervaloPercFinal.value == "") {
			alert("O percentual para a classificação deverá ser informado!");
			frm.txtIntervaloPercFinal.focus();
			return false;
		}


		frm.action = caminho;
		frm.submit();
		return true;	
	}
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%

	strPaginaTitulo = "Rel_OrdemAlfabetica_con.asp"

	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strCursoSigla			= Trim(Request.Form("cmbCursoSigla"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = "disabled"
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td width="700" align="center" class="tituloSistema">Mapa de Integraliza&ccedil;&atilde;o</td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     
    <tr>
      <td width="277" class="texto1">&nbsp;</td>
      <td width="989" colspan="3">&nbsp;</td>
    </tr>
    
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"-->
        <span class="texto1">
        <input type="checkbox" name="AlunoSemSituacao" value="S">
        &nbsp; - Somente alunos sem situa&ccedil;&atilde;o Acad&ecirc;mica</span></td>
    </tr>
    
    <tr>
      <td class="texto1">Cassificar Percentual de Integraliza&ccedil;&atilde;o:</td>
      <td colspan="3"><span class="texto1">
        <input  name="txtIntervaloPercInicial" type="text" class="text" id="txtIntervaloPercInicial" value="<%=strIntervaloPercInicial%>" size="3" maxlength="3">
a
<input  name="txtIntervaloPercFinal" type="text" class="text" id="txtIntervaloPercFinal" value="<%=strIntervaloPercFinal%>" size="3" maxlength="3">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Curso:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdCursoSigla.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Linhas por P&aacute;gina: </td>
      <td colspan="3"><!--#include file="../includes/inc_cmbLinhaPorPagina.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Tamanho da Fonte:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="3">&nbsp;</td>
    </tr>
    
    <tr>
      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="4"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
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
