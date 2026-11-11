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
		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false && frm.optOpcao[2].checked==false && frm.optOpcao[3].checked==false) {
			alert("Opção de relatório deve ser informada !");
			frm.optOpcao[0].focus();
			return false;
		}	
		if (frm.optOpcao[0].checked) {
			caminho = "Rel_CandidatosDatas_rel.asp"
		}	
		if (frm.optOpcao[1].checked) {
			caminho = "Rel_CandidatosAssinaturas_rel.asp"
		}	
		if (frm.optOpcao[2].checked) {
			caminho = "Rel_CandidatosLisa_rel.asp"
		}	
		if (frm.optOpcao[3].checked) {
			caminho = "Rel_CandidatosEnderecos_rel.asp"
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
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "Rel_Candidatos_con.asp"
	intCodVestibular        	= Trim(Request.Form("cmbVestibular"))
	strOrdem                	= Trim(Request.Form("cmbOrdem"))
	
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td width="700" align="center" class="tituloSistema">Rela&ccedil;&atilde;o de Candidatos do Processo Seletivo </td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     <tr>
       <td width="14%" class="texto1"><strong>Op&ccedil;&atilde;o de Relat&oacute;rio: </strong></td>
       <td width="26%" class="texto1"><strong>
         <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">
         Datas&nbsp;&nbsp;&nbsp;&nbsp; <br>
  <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1">
         Assinatura<br>
  <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2">
         Lisa &nbsp;&nbsp;&nbsp;&nbsp; <br>
  <input <% if strOpcaoRelatorio = "3" then response.Write("checked")%> name="optOpcao" type="radio" value="3">
         Endere&ccedil;o e Telefone <br>
  <br>
       </strong></td>
       <td width="60%" valign="top" class="texto1"><strong><br>
         <br>
       </strong></td>
       </tr>
    <tr>
      <td class="texto1">Processo Seletivo </td>
      <td colspan="3"><!--#include file="../includes/inc_cmdVestibular.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Ordem</td>
      <td colspan="3"><select name="cmbOrdem" class="Combo" id="cmbOrdem"  style="width:100pt" >
          <option value="alfabetica" >Alfabetica</option>
          <option value="inscricao" >Inscrição</option>
          <option value="datainscricao" >Data da Inscrição</option>
          <option value="datanascimento" >Data de Nascimento</option>
          </select>      </td>
    </tr>
    
    <tr>
      <td class="texto1"><strong>Classificar de (A..Z)</strong></td>
      <td colspan="2"><span class="texto1">Letra Inicial:
          <input name="txtLetraInicial" type="text" class="text" id="txtLetraInicial" size="3" maxlength="1" value=" "> </span></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="3"><span class="texto1">Letra Final..:
          <input name="txtLetraFinal" type="text" class="text" id="txtLetraFinal" size="3" maxlength="1" value="">
      </span></td>
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
