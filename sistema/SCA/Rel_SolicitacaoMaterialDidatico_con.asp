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
		if (frm.txtData.value==""){
			alert("A data deve ser informada.");
			frm.txtData.focus();
			return false
		}
		frm.action = "Rel_SolicitacaoMaterialDidatico_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_SolicitacaoMaterialDidatico_con.asp"
	strData	 			= formatadataAP(date)
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")
	
	strCodTempo			= Trim(Request.Form("cmbTempo"))
	
%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">Ano Letivo: </td>
      <td><input name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
      </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
      </tr>
    <tr>
      <td width="12%" class="texto1">Curso:</td>
      <td width="88%"><span class="texto1">
        <!--#include file="../includes/inc_cmdCurso.asp"-->
      </span></td>
      </tr>
    <tr>
      <td class="texto1">Data:</td>
      <td><span class="texto1">
        <input name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>">
      </span></td>
      </tr>
    <tr class="texto1">
      <td class="texto1">Tipo de Impressão:</td>
      <td class="texto1"><select name="cmbTempo" id="cmbTempo" class="combo" style="width:100pt">
		<option <%if strCodTempo="T" then response.Write("selected") %> value="T">Tempo</option>
		<option <%if strCodTempo="A" then response.Write("selected") %> value="A">Aula</option>
      </select>
    </td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
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
