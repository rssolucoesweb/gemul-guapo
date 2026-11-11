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
		
		if (frm.cmbProjetoSociais.value == 0){
			alert("O Projeto Social deve ser informado!");
			frm.cmbRota.focus();
			return false;
		}

		if (frm.txtMesInicial.value > frm.txtMesFinal.value ) {
			alert("Intervalo não permitido.");
			frm.txtMesInicial.focus();
			return false
		}
		
		if (frm.txtMesInicial.value > 12) {
			alert("Mês não permitido.");
			frm.txtMesInicial.focus();
			return false
		}

		if (frm.txtMesFinal.value > 12) {
			alert("Mês não permitido.");
			frm.txtMesFinal.focus();
			return false
		}

		
		frm.action = "Rel_ProjetosSociais_rel.asp";
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
	strPaginaTitulo 		= "Rel_ProjetosSociais_con.asp"
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")

	intCodProjetoSociais 	= Trim(Request.Form("cmbProjetoSociais"))
	strMesInicial			= Trim(Request.Form("txtMesInicial"))
	strMesFinal				= Trim(Request.Form("txtMesFinal"))
	   
%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
          <tr>
            <td width="143" class="texto1">Ano Letivo:</td>
            <td width="815"><span class="texto1">
              <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
            </span></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Semestre:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdSemestre.asp" -->
            </span></td>
          </tr>
	  <tr>
        <td width="213" class="texto1">Projetos Sociais: </td>
	    <td width="975" colspan="2"><!--#include file="../includes/inc_ProjetosSociais.asp"--></td>
	    </tr>
     
      <tr>
        <td class="texto1">Per&iacute;odo Mensal de Fr&ecirc;quencia:</td>
        <td colspan="2"><span class="texto1">
          <input  name="txtMesInicial" type="text" class="text" id="txtMesInicial" value="<%=strMesInicial%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,2,3)">
a
<input  name="txtMesFinal" type="text" class="text" id="txtMesFinal" value="<%=strMesFinal%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,2,3)">
        </span></td>
      </tr>
      <tr>
      <td class="texto1">Ordem:</td>
      <td colspan="2"><select name="cmbOrdem" class="Combo" id="cmbOrdem"  style="width:100pt" >
        <option value="alfabetica" >Alfabetica</option>
        <option value="Turma" >Turma</option>
      </select></td>
    </tr>
    <tr>
      <td height="13" colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
  </td>
</tr>
</table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
