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
		
		if (frm.txtAnoLetivo.value=="" && frm.cmbGradeagrupamento.value=="0" ){
			alert("O Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
		if (frm.cmbSemestre.value=="0" && frm.cmbGradeagrupamento.value=="0" ){
			alert("O Semestre deve ser informado.");
			frm.cmbSemestre.focus();
			return false
		}
		if (frm.cmbCurso.value=="0" && frm.cmbGradeagrupamento.value=="0" ){
			alert("O curso deve ser informado.");
			frm.cmbCurso.focus();
			return false
		}
		frm.action = "Rel_GradeCurricular_rel.asp";
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
	strPaginaTitulo = "Rel_GradeCurricular_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	
	intGradeagrupamento	 	= Trim(Request.Form("cmbGradeagrupamento"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intAno		 			= Trim(Request.Form("txtAno"))


	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodSemestre = "" then intCodSemestre = "0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

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
	    <td class="texto1">Grupo:</td>
	    <td width="88%"><span class="texto1"><!--#include file="../includes/inc_cmdGradeCurricularGrupos.asp"--></span></td>
	    </tr>
	  <tr>
        <td class="texto1">Ano Letivo:</td>
	    <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
	    </tr>
	  <tr>
        <td class="texto1">Semestre:</td>
	    <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
	    </tr>
     <tr>
      <td width="12%" class="texto1">Curso:</td>
      <td width="88%"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o:</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="2" class="texto1">
	  <select name="cmbSituacao" class="Combo" id="cmbSituacao"  style="width:100pt" >
      <option value="A" >Ativas</option>
	  <option value="T" >Todas</option>
      <option value="I" >Inativas</option>
      </select></td>
    </tr>
    <tr>
      <td class="texto1">Mostrar Equival&ecirc;ncia:</td>
      <td colspan="2"><span class="texto1">
        <input type="checkbox" name="MostrarEquivalencia" value="S">
        &nbsp;</span></td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
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
