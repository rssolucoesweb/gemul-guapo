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
<script>
	function gerar(){
		
		var caminho;
		var frm = document.getElementById("frm");
		
		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false && frm.optOpcao[2].checked==false && frm.optOpcao[3].checked==false && frm.optOpcao[4].checked==false && frm.optOpcao[5].checked==false && frm.optOpcao[6].checked==false && frm.optOpcao[7].checked==false && frm.optOpcao[8].checked==false) {
			alert("Opção de relatório deve ser informada !");
			frm.optOpcao[0].focus();
			return false;
		}	
		if (frm.optOpcao[0].checked) {
			caminho = "Rel_AlunoDatas_rel.asp"
		}	
		if (frm.optOpcao[1].checked) {
			caminho = "Rel_AlunoAssinaturaPaiMae_rel.asp"
		}	
		if (frm.optOpcao[2].checked) {
			caminho = "Rel_AlunoLisa_rel.asp"
		}	
		if (frm.optOpcao[3].checked) {
			caminho = "Rel_AlunoEndereco_rel.asp"
		}	
		if (frm.optOpcao[4].checked) {
			caminho = "Rel_AlunoPai_rel.asp"
		}	
		if (frm.optOpcao[5].checked) {
			caminho = "Rel_AlunoMae_rel.asp"
		}	
		if (frm.optOpcao[6].checked) {
			caminho = "Rel_AlunoIdade_rel.asp"
		}	
		if (frm.optOpcao[7].checked) {
			caminho = "Rel_AlunoAssinatura_rel.asp"
		}	
		if (frm.optOpcao[8].checked) {
			caminho = "Rel_AlunoAtendimentoEspecial_rel.asp"
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
<!--#include file="../../js/Calendario/Calendario.asp"-->
<%
	strPaginaTitulo = "Rel_OrdemAlfabetica_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	
	strDataINasc			= formatadataAP(request.Form("txtDataINasc"))   
    strDataFNasc			= formatadataAP(request.Form("txtDataFNasc"))   
	strDataIAfast			= formatadataAP(request.Form("txtDataIAfast"))   
    strDataFAfast			= formatadataAP(request.Form("txtDataFAfast"))   
	strDataIMat				= formatadataAP(request.Form("txtDataIMat"))   
    strDataFMat				= formatadataAP(request.Form("txtDataFMat"))   

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))

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
		  <td align="center" class="tituloSistema">Alunos</td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     <tr>
       <td width="17%" class="texto1"><strong>Op&ccedil;&atilde;o de Relat&oacute;rio: </strong></td>
       <td width="30%" class="texto1"><strong>
         <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">
         Datas&nbsp;&nbsp;&nbsp;&nbsp; <br>
         
         
  <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1">
         Assinatura Aluno (Pai e M&atilde;e)         &nbsp;&nbsp;<br>
  <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2">
  Simplificada ( Matr&iacute;cula e nome do aluno )         &nbsp;&nbsp;&nbsp;&nbsp; <br>
  <input <% if strOpcaoRelatorio = "3" then response.Write("checked")%> name="optOpcao" type="radio" value="3">
         Endere&ccedil;o e Telefone <br>
  <br>
       </strong></td>
       <td width="53%" valign="top" class="texto1"><p><strong>
         <input <% if strOpcaoRelatorio = "4" then response.Write("checked")%> name="optOpcao" type="radio" value="4">
         Pai e Telefone <br>
                <input <% if strOpcaoRelatorio = "5" then response.Write("checked")%> name="optOpcao" type="radio" value="5">
         M&atilde;e, Data de Nacimento e Telefone <br>
                <input <% if strOpcaoRelatorio = "6" then response.Write("checked")%> name="optOpcao" type="radio" value="6">
         Data de Nascimento e Idade</strong><br>
         <strong>
           <input <% if strOpcaoRelatorio = "7" then response.Write("checked")%> name="optOpcao" type="radio" value="7">
           Assinatura </strong><br>
           <strong>
<input <% if strOpcaoRelatorio = "8" then response.Write("checked")%> name="optOpcao" type="radio" value="8">
Atendimento Especial</strong></p>         </td>
       </tr>
    <tr>
      <td class="texto1">Sexo:</td>
      <td colspan="3"><span class="texto1">
        <!--#include file="../includes/inc_cmdSexo.asp" -->
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"-->
        <span class="texto1">
        <input type="checkbox" name="AlunoSemSituacao" value="S">
        &nbsp; - Somente alunos sem situa&ccedil;&atilde;o Acad&ecirc;mica</span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo de Nascimento:</td>
      <td colspan="3"><span class="texto1">
        <input name="txtDataINasc" type="text" class="text" id="txtDataINasc" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataINasc%>" title="Click aqui para visualizar o calend&aacute;rio">
a
<input name="txtDataFNasc" type="text" class="text" id="txtDataFNasc" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataNascF%>" title="Click aqui para visualizar o calend&aacute;rio">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo de Afastamento:</td>
      <td colspan="3"><span class="texto1">
        <input name="txtDataIAfast" type="text" class="text" id="txtDataIAfast" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataIAfast%>" title="Click aqui para visualizar o calend&aacute;rio">
a
<input name="txtDataFAfast" type="text" class="text" id="txtDataFAfast" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFAfast%>" title="Click aqui para visualizar o calend&aacute;rio">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo de Matr&iacute;cula:</td>
      <td colspan="3"><span class="texto1">
        <input name="txtDataIMat" type="text" class="text" id="txtDataIMat" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataIMat%>" title="Click aqui para visualizar o calend&aacute;rio">
a
<input name="txtDataFMat" type="text" class="text" id="txtDataFMat" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFMat%>" title="Click aqui para visualizar o calend&aacute;rio">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Ordem:</td>
      <td colspan="3"><select name="cmbOrdem" class="Combo" id="cmbOrdem"  style="width:100pt" >
          <option value="alfabetica" >Alfabetica</option>
          <option value="matricula" >Matr&iacute;cula</option>
          <option value="datamatricula" >Data da Matricula</option>
          <option value="dataafastamento" >Data de Afastamento</option>
          <option value="idade" >Idade</option>
          <option value="bairro" >Bairro</option>
        </select>      </td>
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
