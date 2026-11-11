<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 12/08/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolcueosweb.com.br
	::	Objetivo Pagina...: Rel Mapa Verificacao Conteudo
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
		
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
		
		frm.action = "Rel_MapaVerificacaoConteudo_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_MapaVerificacaoConteudo_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitTurma	  = "S"


	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")
	strOpcaoRelatorio 		= Trim(Request.Form("optOpcao"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
	  <tr>
        <td width="91" class="texto1">Ano Letivo: </td>
	    <td width="1129"><input name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
	    </tr>
	  <tr>
        <td class="texto1">Semestre:</td>
	    <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
	    </tr>
	  <tr>
	    <td class="texto1">Curso:</td>
	    <td class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
	    </tr>
	  <tr>
	    <td class="texto1">Turma:</td>
	    <td class="texto1"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
	    </tr>
	  <tr>
	    <td class="texto1"><strong>Op&ccedil;&otilde;es:</strong></td>
	    <td class="texto1">
        <input <% if strOpcaoRelatorio = "E" then response.Write("checked")%> name="optOpcao" type="radio" value="E">
        Enviado &nbsp;&nbsp;&nbsp;&nbsp;
        <br>
        <input <% if strOpcaoRelatorio = "N" then response.Write("checked")%> name="optOpcao" type="radio" value="N"> 
        N&atilde;o Enviado
        <br>
        <input <% if strOpcaoRelatorio = "T" then response.Write("checked")%> name="optOpcao" type="radio" value="T"> 
        Todos</td>
	    </tr>
	  
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>    <tr>
      <td colspan="2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
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
