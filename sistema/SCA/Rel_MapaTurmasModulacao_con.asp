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

		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false){
			alert("Selecione o filtro para relatório.");
			return false;
		}
		var filtro;
		
		if (frm.optOpcao[0].checked==true) filtro = "T"
		if (frm.optOpcao[1].checked==true) filtro = "A"
		
		frm.action = "Rel_MapaTurmasModulacao_rel.asp?f="+filtro;
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
	strPaginaTitulo = "Rel_MapaTurmas_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strEmpresaGrupo_submit    = "S"
	

	intCodEmpresaGrupo		    = Trim(Request.Form("cmbEmpresaGrupo"))
	intCodEmpresaGrupoUsuario	= Trim(Request.Form("cmdEmpresaGrupoUsuario"))
	intCodCurso	 				= Trim(Request.Form("cmbTodosCursoEmpresas"))
	intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	intCodGrade					= Trim(Request.Form("cmbGrade"))
	strCodTurno		 			= Trim(Request.Form("cmbTurno"))
	strSexo						= Trim(Request.Form("cmbSexo"))
	strIntervaloIdadeInicial 	= Trim(Request.Form("txtIntervaloIdadeInicial"))
	strIntervaloIdadeFinal  = Trim(Request.Form("txtIntervaloIdadeFinal"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

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
    <td align="center" class="tituloSistema">MAPA DE TURMAS - Modulação </td>
    </tr>
    <tr valign="top">
    <td align="center">
    <br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
	  
	  <tr>
	    <td class="texto1">Unidade:</td>
	    <td> <!--#include file="../includes/inc_cmbEmpresaGrupo.asp"--></td>
	    </tr>
	  <tr>
        <td width="13%" class="texto1">Ano Letivo:</td>
	    <td width="87%"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
	    </tr>
	  <tr>
        <td class="texto1">Semestre:</td>
	    <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
	    </tr>
      
      <tr>
        <td class="texto1">Faixa de Idade:</td>
        <td class="texto1"><input  name="txtIntervaloIdadeInicial" type="text" class="text" id="txtIntervaloIdadeInicial" value="<%=strIntervaloIdadeInicial%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,2,3)">
a
  <input  name="txtIntervaloIdadeFinal" type="text" class="text" id="txtIntervaloIdadeFinal" value="<%=strIntervaloIdadeFinal%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,2,3)"></td>
      </tr>
      <tr>
        <td class="texto1">Sexo:</td>
        <td class="texto1"><!--#include file="../includes/inc_cmdSexo.asp" --></td>
      </tr>
      
      <tr>
      <td class="texto1">Filtro:</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td class="texto1"><strong>
        <input <% if strOpcaoRelatorio = "T" then response.Write("checked")%> name="optOpcao" type="radio" value="T"> 
        Todas Turmas
&nbsp;&nbsp;&nbsp;&nbsp; <br>
<input <% if strOpcaoRelatorio = "A" then response.Write("checked")%> name="optOpcao" type="radio" value="A"> 
Somente Turmas Ativas (Alunos vinculados)
</strong></td>
    </tr>
    
      <tr>
        <td height="24" class="texto1">Situa&ccedil;&atilde;o:</td>
        <td><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
      </tr>
      <tr>
        <td height="24" class="texto1">Turno:</td>
        <td>
        <select name="cmbTurno" class="Combo" id="cmbTurno"  style="width:100pt" >
          <option value="0">Selecione...</option>
          <option value="M" <%if strCodTurno = "M" then response.Write("selected") %>>Matutino</option>
          <option value="V" <%if strCodTurno = "V" then response.Write("selected") %>>Vespertino</option>
          <option value="N" <%if strCodTurno = "N" then response.Write("selected") %>>Noturno</option>
          <option value="I" <%if strCodTurno = "I" then response.Write("selected") %>>Integral</option>
        </select>
</td>
      </tr>
      <tr>
        <td class="texto1">&nbsp;</td>
        <td><span class="texto1">
          <input type="checkbox" name="PromoverAnoLetivo" value="S">
          Promover
        ano letivo</span></td>
      </tr>
      <tr>
      <td class="texto1">&nbsp;</td>
      <td><span class="texto1">
        <input type="checkbox" name="SomentoIncosistecia" value="S">
        Somente inconsist&ecirc;ncia</span></td>
    </tr>
    <tr>
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
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
