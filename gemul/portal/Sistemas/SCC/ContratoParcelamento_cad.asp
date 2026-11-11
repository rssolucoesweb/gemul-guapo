<%strNomeDaPaginaPortal = "Parcelamento do Contrato"
strMostraMenuPortal = "N"%>
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
		
		if (frm.txtData.value == "") {
			alert("A data deve ser informada !");
			frm.txtData.focus();
			return false;
		}
		if (frm.txtValor.value == "") {
			alert("O valor deve ser informado !");
			frm.txtValor.focus();
			return false;
		}		
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="ContratoParcelamento_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodigo			= Trim(Request("txtCodigo"))
	intCodContrato		= Trim(Request("txtCodContrato"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSituacao	 		= Trim(Request.Form("cmbSituacao"))
	strBotaoPrincipal	= "N"
	strBotaoFechar 		= "S" 
	sql = "SELECT  totalContrato"
	sql = sql & " FROM SCC_contrato "
	sql = sql & " where Codigo = " & intCodContrato
	sql = sql & " And CodEmpresa = " & intCodEmpresa
	rs.open sql, cnn
	if rs.eof = false then
		intTotalContrato	= formatNumber(rs("totalContrato"),2)
		intValor			= intTotalContrato
	end if 
	rs.close


	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM SCC_contrato_parcela"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			strParcela		= rs("parcela")
			intValor		= formatNumber(rs("valor"),2)
			strData			= formatadataAP(rs("data"))
			strSituacao		= rs("Situacao")
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

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
    <input name="txtValorContrato" type="hidden" id="txtValorContrato" value="<%=intTotalContrato%>" >
    <input name="txtCodContrato" type="hidden" id="txtCodContrato" value="<%=intCodContrato%>" >
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
      		<%if intCodigo<>"" then%>
          <tr>
            <td height="23" class="TextoForm">Parcela:
              <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
            <td class="TextoForm"><input name="txtParcela" type="text" id="txtParcela" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strParcela%>" maxlength="4" ></td>
          </tr>
          <%else%>
           <tr>
            <td height="23" class="TextoForm">Qtde:
              <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
            <td class="TextoForm"><input name="txtQtde" type="text" id="txtQtde" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strQtde%>" maxlength="4" ></td>
          </tr>
           <%end if%>
          <tr>
            <td height="23" class="TextoForm">Data:</td>
            <td class="TextoForm"><input name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="14" maxlength="11"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Valor:</td>
            <td class="TextoForm"><input name="txtValor" type="text" class="text" id="txtValor" value="<%=intValor%>" size="25" maxlength="14"  onKeyPress="return currencyFormat(this,event)"></td>
          </tr>
          <tr>
            <td width="16%" height="23" class="TextoForm">Situa&ccedil;&atilde;o:</td>
            <td width="25" class="TextoForm">
            <select name="cmbSituacao" class="Combo" id="cmbSituacao">
                <option value="0">Selecione...</option>
                <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Em Aberto</option>
                <option value="P" <%if strSituacao = "P" then response.Write("selected") %>>Quitado</option>
            </select>
            </td>
            </tr>
          <tr>
            <td height="24" colspan="2" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="2"><%
				cont =0

					sql = "SELECT *"
					sql = sql & " FROM SCC_contrato_parcela"
					sql = sql & " Where CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " And CodContrato	= " & intCodContrato
					sql = sql & " Order by Parcela"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "80%" border="1" align="left" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td align="center" class="celula"><strong>Parcela</strong></td>
                        <td width="18%" height="21" align="center" class="celula"><strong>Data</strong></td>
                        <td width="23%" align="center" class="celula"><strong>Valor</strong></td>
                        <td width="49%" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                        </tr>
              			<%
						Total = 0
						while not rs.eof
							cont = cont + 1	
							if rs("situacao") = "A" then
								strSituacao = "Em Aberto"
								strCorFonte = "#EB012B"
							elseif rs("situacao") = "P" then
								strSituacao = "Quitada"
								strCorFonte = "#00E800"
							end if
							%>
                            <tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="10%" align="center" class="celula"><%=rs("parcela")%></td>
                            <td height="21" align="center" class="celula"><%=formatadataAP(trim(rs("data")))%></td>
                            <td height="21" align="right" class="celula"><%=formatNumber(rs("valor"),2)%></td>
                            <td height="21" align="center" class="celula"><font color="<%=strCorFonte%>"><%=strSituacao%></font></td>
                            </tr>
              				<%				
							Total = Total + rs("valor")
							rs.movenext
					wend
					%>
                            <tr bgcolor="#E5E5E5">
                              <td height="21" colspan="2" align="center" class="celula"><strong>Valor Total</strong></td>
                              <td height="21" align="right" class="celula"><strong><%=formatNumber(Total,2)%></strong></td>
                              <td height="21" align="center" class="celula">&nbsp;</td>
                            </tr>
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