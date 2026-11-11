<%strNomeDaPaginaPortal = "Receber Protocolo"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbProtocolo.value == "0") {
			alert("Protocolo deve ser informado !");
			frm.cmbProtocolo.focus();
			return false;
		}
		frm.action="Arquivamento_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	strProtocolo_submit = "S"
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodProtocolo		= Trim(Request.Form("cmbProtocolo"))
	intCodDepartamento 	= Trim(Request.Form("cmbDepartamento"))
	if trim(session("codDepartamentoAtual"))="0" or trim(session("codDepartamentoAtual"))="" then
		%>
		<script>
        	alert("ATENÇÃO: Seu usuário não foi vinculado a nenhum departamento. Antes de receber o protocolo você deverá solicitar a inclusão.");
			window.history.back();
        </script>
		<%		
		response.End()
	end if		
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	BotaoPDF   				= "disabled"
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td height="23" class="TextoForm">Protocolo:
             
              </td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbProtocolo.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Situa&ccedil;&atilde;o:</td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbSituacaoProtocoloArquivamento.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Departamento:</td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbDepartamentoDestinoProtocolo.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Arquivo:</td>
            <td class="TextoForm"><input name="txtArquivo" type="text" class="text" id="txtArquivo" size="10" maxlength="30" value="<%=strArquivo%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Pasta:</td>
            <td class="TextoForm"><input name="txtPasta" type="text" class="text" id="txtPasta" size="10" maxlength="30" value="<%=strPasta%>"></td>
          </tr>
          <tr>
            <td height="46" class="TextoForm">Obs:</td>
            <td class="TextoForm"><textarea name="txtObs" id="txtObs" cols="75" rows="5" class="text"><%=strObs%></textarea></td>
          </tr>
          <tr>
            <td height="24" colspan="2" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
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