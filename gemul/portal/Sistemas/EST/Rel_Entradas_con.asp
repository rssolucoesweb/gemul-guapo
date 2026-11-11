<%strNomeDaPaginaPortal = "Relatório de Entrada de Materiais"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function gerar(){
		if (frm.txtDataI.value == "") {
			alert("A Data inicial deve ser informada!");
			frm.txtDataI.focus();
			return false;
		}
		if (frm.txtDataF.value == "") {
			alert("A Data final deve ser informada!");
			frm.txtDataF.focus();
			return false;
		}
		
		frm.action = "Rel_entradas_rel.asp";
		frm.submit();
		
		return true;	
	}	
</script>
<%  
	strEmpresaSecaoProduto_submit = "S"
	StrReloadSistema	= "S"
	principal			= "principal.asp"
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	
	strDataI = formatadataAP(request("txtDataI"))
	strDataF = formatadataAP(request("txtDataF"))
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <form id="frm" name="frm" action="Rel_entradas_con.asp" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td width="100%" class="tituloPrincipal style2" height="30"><BR>
            <table width="90%" border="0">
              <tr>
                <td><span class="TextoForm">Se&ccedil;&atilde;o</span>:</td>
                <td><span class="TextoForm">
                  <!--#include file="../../../includes/inc_cmbSecaoProduto.asp" -->
                </span></td>
              </tr>
              <tr>
                <td width="13%">Per&iacute;odo:</td>
                <td width="87%"><input name="txtDataI" id="txtDataI" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataI%>" size="10" maxlength="10"> 
                  a 
                    <input name="txtDataF" id="txtDataF" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataF%>" size="10" maxlength="10"></td>
              </tr>
              <tr>
                <td>Produto:</td>
                <td><span class="TextoForm">
                  <!--#include file="../../../includes/inc_cmbProduto.asp"-->
                </span></td>
              </tr>
              <tr>
                <td>Fornecedor:</td>
                <td><!--#include file="../../../includes/inc_cmbFornecedor.asp"--></td>
              </tr>
            </table>
            <BR><!--#include file="../../../includes/inc_botoes_geraRelatorio.asp"--></td>
        </tr>
      </table>
   	<!-- fim do formulario da pagina-->
    </form>
      </td>
            </tr>
        </table>
        <hr size="1" color="#FFFFFF">
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>