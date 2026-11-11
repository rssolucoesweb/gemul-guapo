<%strNomeDaPaginaPortal = "Relatório de Estoque Mínimo"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function gerar(){
		frm.action = "Rel_EstoqueMinimo_rel.asp";
		frm.submit();
		
		return true;	
	}	
</script>
<%  
	StrReloadSistema	= "S"
	principal			= "principal.asp"
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <form id="frm" name="frm" action="ConsultaRequisicao_con.asp" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
	<%IF Session("CodSecao")="0" THEN %>
        <tr valign="top">
          <td width="15%" height="30" class="TextoForm">Se&ccedil;&atilde;o</td>
          <td width="85%" class="tituloPrincipal style2"><!--#include file="../../../includes/inc_cmbSecaoProduto.asp" --></td>
        </tr>
	<%ELSE%>
    <input name="cmbSecaoProduto" id="cmbSecaoProduto" value="<%=Session("CodSecao")%>" type="hidden">
	<%END IF%>
        <tr valign="top">
          <td width="100%" colspan="2" class="tituloPrincipal style2" height="30"><BR><!--#include file="../../../includes/inc_botoes_geraRelatorio.asp"--></td>
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