<%strNomeDaPaginaPortal = "Contrato"%>
<%strMostraMenuPortal = "N"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbFonteRecurso.value == "0") {
			alert("Fonte Recurso deve ser informada!");
			frm.cmbFonteRecurso.focus();
			return false;
		}
		if (frm.txtValor.value == "") {
			alert("Valor deve ser informado!");
			frm.txtValor.focus();
			return false;
		}
		
		
		frm.action="LiquidacaoDespesasFonteRecurso_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	principal							= "principal.asp"
	intCodPrevisaoLiquidacao			= Trim(Request("CodPL"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strBotaoPrincipal 	= "N" 
    strBotaoFechar 		= "S"
	if trim(intCodigo)<>"" then
	
		sql = "SELECT  codigo, 	codfonteRecurso, valorFonte "
		sql = sql & " FROM SCC_previsao_liquidacao_fonte_recurso "
		sql = sql & " where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("Codigo")
			intCodFonteRecurso		= trim(rs("codFonteRecurso"))
			if isnull(rs("valorFonte")) then
				intValor	= ""
			else
				intValor	= formatNumber(rs("valorFonte"),2)
			end if
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		else
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
    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td width="158" height="23" class="TextoForm"><strong> Previs&atilde;o Liquida&ccedil;&atilde;o:</strong></td>
            <td width="215" class="TextoForm"><input readonly name="codPL" type="text" id="codPL" class="textDesabilitado" size="10" value="<%=intCodPrevisaoLiquidacao%>" maxlength="10" ></td>
            <td width="117" class="TextoForm">&nbsp;</td>
            <td width="362" class="TextoForm">&nbsp;</td>
            </tr>
          <tr>
            <td height="10" colspan="4" class="TextoForm"><hr size="1" color="#999999"></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Fonte de Recurso:</td>
            <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbFonteRecurso.asp"--></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Valor</td>
            <td colspan="3" class="TextoForm"><input name="txtValor" type="text" class="text" id="txtValor" value="<%=intValor%>" size="25" maxlength="14"  onKeyPress="return currencyFormat(this,event)"></td>
            </tr>

        <tr valign="top">
          <td  height="15"  class="tituloPrincipal style2"></td>
          <td  height="15"  class="tituloPrincipal style2"></td>
          <td  height="15"  class="tituloPrincipal style2"></td>
          <td  height="15"  class="tituloPrincipal style2"></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="4"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        <tr valign="top">
          <td class="tituloPrincipal style2"  colspan="4"><%
				cont =0

					sql = "SELECT SCC_previsao_liquidacao_fonte_recurso.codigo, SCC_fonte_recurso.descricao, SCC_previsao_liquidacao_fonte_recurso.valorFonte"
					sql = sql & " FROM SCC_previsao_liquidacao_fonte_recurso"
					sql = sql & " LEFT JOIN SCC_fonte_recurso ON SCC_fonte_recurso.CODIGO = SCC_previsao_liquidacao_fonte_recurso.codFonterecurso"
					sql = sql & " where SCC_previsao_liquidacao_fonte_recurso.codPrevisaoLiquidacao = " & intCodPrevisaoLiquidacao
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>Fonte</strong></td>
                        <td width="58%" height="21" class="celula"><strong>Valor</strong></td>
                        </tr>
              			<%
						while not rs.eof
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="42%" class="celula"><%=rs("descricao")%>&nbsp;</td>
                            <td height="21" class="celula"><%=formatnUmber(rs("valorFonte"),2)%>&nbsp;</td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
              </table>
            <%
			  end if
			  rs.close%></td>
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
