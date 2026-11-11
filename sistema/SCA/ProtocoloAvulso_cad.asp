<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/03/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro Taxa Avulsa
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	
	function Calculo(Qtde){
		var soma=0;
		var valor=0;
		valor =frm.txtValor.value;
		
		if (Qtde != ""){ 
			soma = (parseFloat(valor) *  parseFloat(Qtde));
		}
		
		frm.txtValor.value=soma;
	}

	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
			
		if (frm.cmbTaxa.value == "0") {
			alert("A Taxa deve ser informada!");
			frm.cmbTaxa.focus();
			return false;
		}
		
		if (frm.txtValor.value == "") {
			alert("O Valor deve ser informado !");
			frm.txtValor.focus();
			return false;
		}
	
		frm.action="ProtocoloAvulso_cod.asp?acao=" + acao;
		frm.submit();
		return true;
		
 	}
</script>
<%
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir


	strExecutarSubmitTaxa	= "S"
	strExecutarSubmitDepto	= "S"
	strMostraBotaoFechar	= "S"
	strMostraBotaoCadastroPrincipal = "N"
	strTaxaZerada			= "S"
	strMostraTaxaProtocolo	= "S"
	
	intCodAluno	 			= Trim(Request("codAluno"))
	intCodTaxa	 			= Trim(Request.Form("cmbTaxa"))
	intCodDepartamento		= Session("CodDeptoUsuario")
	strDescDepartamento		= Session("DescDeptoUsuario")
	if intCodDepartamento = "" then intCodDepartamento = 0
	strValor				= Trim(Request.Form("txtValor"))
	strPrazo 				= Trim(Request.Form("txtPrazo"))
	strProtocolo 			= Trim(Request.Form("txtProtocolo"))	
	strDescProtocolo 		= Trim(Request.Form("txtDescProtocolo"))	
	strDataEntrada 			= formatadataAP(date)


	if trim(intCodTaxa) <> "" then
	
		sql = "SELECT Cod_Taxa, Cod_Departamento, Cod_Tipo_Taxa, Descricao, Desc_Abreviada, Valor, Prazo, Mensagem, Protocolo"
		sql = sql & " FROM scf_TAXA"
		sql = sql & " Where Cod_Taxa = " & intCodTaxa
		sql = sql & " And Cod_empresa = " & session("codEmpresa")
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodTaxa	 			= rs("Cod_Taxa")
			intCodDepartamento		= rs("Cod_Departamento")
			intCodTipoTaxa			= rs("Cod_Tipo_Taxa")
			strValor				= formatnumber(rs("Valor"),2)
			intPrazo 				= rs("Prazo")
			strProtocolo			= rs("Protocolo")
			
			strDescProtocolo 		= ""
			if strProtocolo 		= ""  then strDescProtocolo = "Não"
			if strProtocolo 		= "N" then strDescProtocolo = "Não"
			if strProtocolo 		= "S" then strDescProtocolo = "Sim"

			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 	
	'Tipo Taxa
	'codigo      descricao
	'----------- --------------------------------------------------
	'1           SECRETARIA		--Possui validacao Normal sem regras	
	'2           VESTIBULAR		--Possui validacao Normal sem regras	
	'3           BIBLIOTECA
	'4           DISCIPLINA     --Possui validacao - Lista disciplina do Aluno
	'5           EXAME			--Possui validacao - Lista disciplina do Aluno
	'6           QUANTIDADE		--Possui validacao - Faz o calculo do Valor da Taxa X Campo Quantidade
%>
<table width="100%" height="316" border="1"  cellpadding="0" cellspacing="0" bordercolor="#2A2776" class="CorFundo">
  <tr valign="top">
    <td width="100%" height="314" align="center">
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema">Protocolo Avulso </td>
            </tr>
          </table>
		  <table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr bgcolor="#CCCCCC">
            <td class="texto1" colspan="2"><span class="TextoForm"><!--#include file="../includes/inc_sqlDadosEscolaresAluno.asp" --></strong></span></td>
          </tr>
		  <tr>
            <td class="texto1">&nbsp;</td>
            <td><input name="codAluno" type="hidden" id="codAluno" class="text" size="10" value="<%=intCodAluno%>" maxlength="10">
			<input name="txtMatricula" type="hidden" id="txtMatricula" class="text" size="10" value="<%=strMatricula%>" maxlength="10"></td>
          </tr>
          <tr>
            <td class="texto1">Departamento  : </td>
            <td><strong><%=strDescDepartamento%></strong></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Taxa : </td>
            <td><!--#include file="../includes/inc_cmbTaxa.asp" --></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Valor   : </td>
            <td><span class="texto1">
              <input readonly name="txtValor" type="text" class="text" id="txtValor"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=strValor%>">
            </span></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Prazo  : </td>
            <td><input readonly name="txtPrazo" type="text" id="txtPrazo" onKeyPress="return formataCampo(this, 2, 6)" class="text" size="11" value="<%=intPrazo%>" maxlength="5">
              <span class="texto1">dias</span></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Gera Protocolo : </td>
            <td><input readonly name="txtDescProtocolo" type="text" id="txtDescProtocolo" class="text" size="11" value="<%=strDescProtocolo%>" maxlength="5">
              <input readonly name="txtProtocolo" type="hidden" id="txtProtocolo" value="<%=strProtocolo%>"></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Data de Entrada : </td>
            <td><span class="TextoForm">
              <input readonly name="txtDataEntrada" type="text" class="text" id="txtDataEntrada" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataEntrada%>">
            </span></td>
          </tr>
		  <%
		  if intCodTipoTaxa = 4 or intCodTipoTaxa = 5 then%>
          <tr>
            <td class="texto1">Disciplina:</td>
            <td><!--#include file="../includes/inc_cmbDisciplinaAluno.asp" --></td>
          </tr>
		  <%end if%>
		  <%if intCodTipoTaxa = 6 then%>
	      <tr>
            <td class="texto1">Quantidade</td>
            <td><input name="txtQtde" type="text"  onBlur="Calculo(this.value)" onKeyPress="return formataCampo(this, 2, 9)" id="txtQtde" class="text" size="11" value="<%=intQtde%>" maxlength="5"></td>
          </tr>
		  <%end if%>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
</body>
</html>