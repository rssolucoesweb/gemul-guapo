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
		var frm = document.getElementById("frm");
		
		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false && frm.optOpcao[2].checked==false) {
			alert("Opção de relatório deve ser informada !");
			frm.optOpcao[0].focus();
			return false;
		}	
		if (frm.optOpcao[0].checked) {
			caminho = "Rel_RequerimentoProvasAnalitico_rel.asp"
		}	
		if (frm.optOpcao[1].checked) {
			caminho = "Rel_RequerimentoProvasSintetico_rel.asp"
		}	
		if (frm.optOpcao[2].checked) {
			caminho = "Rel_RequerimentoProvasAssinatura_rel.asp"
		}	

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
strPaginaTitulo = "Rel_RequerimentoProvasSintetico_con.asp"
	
strExecutarSubmitTurma       = "S"
	
if trim(request.Form("txtDataI")) = "" then
   strDataI 			= formatadataAP(date)
else
   strDataI				= formatadataAP(request.Form("txtDataI"))   
end if
if trim(request.Form("txtDataF")) = "" then
   strDataF			    = formatadataAP(date)
else
   strDataF				= formatadataAP(request.Form("txtDataF"))   
end if
intCodCurso	 			= Trim(Request.Form("cmbCurso"))
intCodTurma 			= Trim(Request.Form("cmbTurma"))
intCodDisciplinaTurma   = Trim(Request.Form("cmbDisciplinaTurma"))
intCodTaxa              = Trim(Request.Form("cmbTaxa"))
strlpp 					= Trim(Request.Form("cmblpp"))
strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
strOpcaoRelatorio		= request.Form("optOpcao")


if intCodTurma = "" then intCodTurma ="0"

%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
<td width="700" align="center" class="tituloSistema"> Requerimento de Provas </td>
</tr>
<tr valign="top">
<td align="center">
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
<tr>
<td width="14%" height="87" class="texto1"><strong>Op&ccedil;&atilde;o de Relat&oacute;rio: </strong></td>
<td width="33%" class="texto1"><p><strong>
  <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0" onChange="submit()">
    Anal&iacute;tico <br>
  <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1" onChange="submit()">
    Sint&eacute;tico<br>
    </strong><strong>
    <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2" onChange="submit()"> 
    Frequ&ecirc;ncia
</strong></p>  </td>
<td width="53%" valign="top" class="texto1">&nbsp;</td>
</tr>
<tr>
  <td class="texto1">Per&iacute;odo de Requerimento: </td>
  <td colspan="3"><span class="texto1">
    <input name="txtDataI" type="text" class="text" id="txtDataI" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataI%>">
a
<input name="txtDataF" type="text" class="text" id="txtDataF" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataF%>">
  </span></td>
</tr>
 <tr>
  <td class="texto1">Curso:</td>
  <td colspan="2"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
</tr>
<tr>
  <td class="texto1">Turma:</td>
  <td colspan="3"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
</tr>
<tr>
  <td class="texto1">Disciplina:</td>
  <td colspan="3"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
</tr>

<tr>
  <td class="texto1">Requerimento:</td>
  <td colspan="3"><!--#include file="../includes/inc_cmbTaxa.asp"--></td>
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
<br>		  
</td>
</tr>
</table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
