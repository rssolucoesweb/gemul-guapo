<%strNomeDaPaginaPortal = "Liquida&ccedil;&atilde;o e Despesas"%>
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

	function abreFonteRecurso(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTipo.value == "0") {
			alert("O Tipo deve ser informado !");
			frm.cmbTipo.focus();
			return false;
		}
		if (frm.txtValor.value == "") {
			alert("O Valor deve ser informado !");
			frm.txtValor.focus();
			return false;
		}
		frm.action="LiquidacaoDespesas_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	principal			= "principal.asp"
	strMostraBotaoFonteRecurso = "S"
	intCodEmpresa			= session("CodEmpresa")	
	intCodigo 				= Trim(Request.Form("txtCodigo"))
	strTipo	 				= Trim(Request.Form("cmbTipo"))
	intNumeroProcesso		= Trim(Request.Form("txtNumeroProcesso"))
	intCodTipoDocumento	 	= Trim(Request.Form("cmbTipoDocumento"))
	intNumeroTipoDocumento	= Trim(Request.Form("txtNumeroTipoDocumento"))
	strDataEmissao 			= Trim(Request.Form("txtDataEmissao"))
	intCodGrupo	 			= Trim(Request.Form("cmbGrupo"))
	intCodBeneficiario		= Trim(Request.Form("cmbBeneficiario"))
	strDataVencimento		= Trim(Request.Form("txtDataVencimento"))
	strValor	 			= Trim(Request.Form("txtValor"))
	strobs		 			= Trim(Request.Form("txtObs"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, codEmpresa, codProcesso, tipo, codTipoDocumento, numeroTipoDocumento, "
		sql = sql & " dataEmissao, codGrupo, codBeneficiario, dataVencimento, ValorTotal, obs"
		sql = sql & " FROM SCC_previsao_liquidacao"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo 				= rs("Codigo")
			strTipo	 				= rs("tipo")
			intCodProcesso			= rs("codProcesso")
			intCodTipoDocumento	 	= rs("codTipoDocumento")
			intNumeroTipoDocumento	= rs("numeroTipoDocumento")
			strDataEmissao 			= rs("dataEmissao")
			intCodGrupo	 			= rs("codGrupo")
			intCodBeneficiario		= rs("codBeneficiario")
			strDataVencimento		= rs("dataVencimento")
			strValor	 			= FORMATNUMBER(rs("ValorTotal"),2)
			strobs		 			= rs("obs")

						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			strDesabilitaFonte		= ""
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaFonte   				= "disabled"
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
            <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
              <tr>
          	  <td height="23" class="TextoForm">Codigo:</td>
          	  <td colspan="3" class="TextoForm"><input name="txtCodigo" type="text" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
        	  </tr>
          	<tr>
          	  <td height="23" class="TextoForm">Tipo</td>
          	  <td colspan="3" class="TextoForm"><select name="cmbTipo" class="Combo" id="cmbTipo">
          	    <option value="0">Selecione...</option>
          	    <option value="P" <%if strTipo = "P" then response.Write("selected") %>>Previs&atilde;o</option>
          	    <option value="L" <%if strTipo = "L" then response.Write("selected") %>>Liquida&ccedil;&atilde;o</option>
        	    </select></td>
        	  </tr>
          	<tr>
          	  <td height="23" class="TextoForm">N&uacute;mero Processo</td>
          	  <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbProcesso.asp"--></td>
        	  </tr>
          	<tr>
          	  <td height="23" class="TextoForm">Tipo Documento:</td>
          	  <td width="221" class="TextoForm"><!--#include file="../../../includes/inc_cmbTipoDocumento.asp"--></td>
          	  <td width="64" class="TextoForm">N&uacute;mero:          	    </td>
          	  <td width="431" class="TextoForm"><input name="txtNumeroTipoDocumento" type="text" id="txtNumeroTipoDocumento" class="text" size="10" value="<%=intNumeroTipoDocumento%>" maxlength="10"></td>
        	  </tr>
          	<tr>
          	  <td height="23" class="TextoForm">Data Emiss&atilde;o:              	</td>
          	  <td colspan="3" class="TextoForm"><input name="txtDataEmissao" type="text" class="text" id="txtDataEmissao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataEmissao%>" size="14" maxlength="11"></td>
        	  </tr>
          	<tr>
          	  <td height="23" class="TextoForm">Grupo:</td>
          	  <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbGrupoContrato.asp"--></td>
        	  </tr>
          	<tr>
          	  <td height="23" class="TextoForm">Benefici&aacute;rio:</td>
          	  <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbBeneficiario.asp"--></td>
        	  </tr>
          	<tr>
          	  <td height="23" class="TextoForm">Data de Vencimento:</td>
          	  <td colspan="3" class="TextoForm"><input name="txtDataVencimento" type="text" class="text" id="txtDataVencimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataVencimento%>" size="14" maxlength="11"></td>
        	  </tr>
          	<tr>
          	  <td height="23" class="TextoForm">Valor Total</td>
          	  <td colspan="3" class="TextoForm"><input name="txtValor" type="text" class="text" id="txtValor" value="<%=strValor%>" size="10" maxlength="10"  onKeyPress="return currencyFormat(this,event)"></td>
        	  </tr>
          	<tr>
            <td width="136" height="23" class="TextoForm">Obs:</td>
            <td colspan="3" class="TextoForm"><span class="texto">
              <textarea name="txtObs" cols="69" class="text" id="txtObs"><%=strobs%></textarea>
            </span></td>
            </tr>
          <tr>
            <td height="24" colspan="4" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="4"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="4">
		  <%
					cont =0

					sql = "SELECT SCC_previsao_liquidacao.Codigo, tipo, codTipoDocumento, numeroTipoDocumento, "
					sql = sql & " dataEmissao, codGrupo, codBeneficiario, dataVencimento, ValorTotal, obs, SCC_Beneficiario.razaosocialNome"
					sql = sql & " FROM SCC_previsao_liquidacao"
					sql = sql & " LEFT JOIN SCC_Beneficiario on SCC_Beneficiario.codigo = SCC_previsao_liquidacao.codBeneficiario and SCC_Beneficiario.codEmpresa = SCC_previsao_liquidacao.codEmpresa"
					sql = sql & " Where SCC_previsao_liquidacao.CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " Order by Codigo"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="6%" height="21" class="celula"><strong>Tipo</strong></td>
                        <td width="50%" height="21" class="celula"><strong>Benefici&aacute;rio</strong></td>
                        <td width="39%" height="21" class="celula"><strong>Valor Total</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							tipo = ""
							if rs("tipo")="L" then
								tipo = "Liquida&ccedil;&atilde;o"
							elseif rs("tipo")="P" then
								tipo = "Previs&atilde;o"
							end if
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="5%" class="celula"><%=rs("Codigo")%></td>
                            <td height="21" class="celula"><%=trim(tipo)%></td>
                            <td height="21" class="celula"><%=trim(rs("razaosocialNome"))%>&nbsp;</td>
                            <td height="21" class="celula"><%=formatNumber(rs("ValorTotal"),2)%>&nbsp;</td>
                            </tr>
              				<%				
						rs.movenext
						wend
						%>
              		<tr>
                	<td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
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