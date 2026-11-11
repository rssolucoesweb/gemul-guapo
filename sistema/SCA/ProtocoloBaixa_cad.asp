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
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
			
		var frm = document.getElementById("frm");
		
		if (frm.txtObs.value == "") {
			alert("Observação deve ser informada!");
			frm.txtObs.focus();
			return false;
		}
	
		frm.action="ProtocoloBaixa_cod.asp?acao=A"
		frm.submit();
		return true;
		
 	}
</script>
<%
	strMostraBotaoFechar	= "S"
	strMostraBotaoCadastroPrincipal = "N"
	
	intCodAluno	 			= Trim(Request("codAluno"))
	strProtocolo 			= Trim(Request("CodProtocolo"))

	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

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
              <td width="100%" align="center" class="tituloSistema">Baixa de Protocolo </td>
            </tr>
          </table>
		  <table width="95%" border="0" cellspacing="0" cellpadding="0">
			 <tr bgcolor="#CCCCCC">
            <td class="texto1" colspan="2"><span class="TextoForm"><!--#include file="../includes/inc_sqlDadosEscolaresAluno.asp" --></strong></span></td>
          </tr>		  
		  <tr>
            <td width="11%" class="texto1">&nbsp;</td>
            <td width="89%"><input name="codAluno" type="hidden" id="codAluno" class="text" size="10" value="<%=intCodAluno%>" maxlength="10"></td>
          </tr>
          <tr>
            <td class="texto1">N&uacute;mero  : </td>
            <td><label>
              <input readonly name="CodProtocolo" type="text" class="text" id="CodProtocolo" value="<%=strProtocolo%>" size="15">
            </label></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Observa&ccedil;&atilde;o : </td>
            <td><label>
              <textarea name="txtObs" cols="80" rows="5" class="text" id="txtObs"><%=strObs%></textarea>
            </label></td>
          </tr>
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