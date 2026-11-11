<%strNomeDaPaginaPortal = "Cadastro de Processo"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
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
		
		if (frm.cmbAssunto.value == "0") {
			alert("O Assunto deve ser informado !");
			frm.cmbAssunto.focus();
			return false;
		}
		
		if (frm.cmbModalidade.value == "0") {
			alert("A Modalidade deve ser informada !");
			frm.cmbModalidade.focus();
			return false;
		}
		
		if (frm.txtNumero.value == "") {
			alert("O Número deve ser informado !");
			frm.txtNumero.focus();
			return false;
		}
		
		if (frm.txtObjeto.value == "") {
			alert("O Objeto deve ser informado !");
			frm.txtObjeto.focus();
			return false;
		}
		
		if (frm.txtData.value == "") {
			alert("A Data deve ser informada !");
			frm.txtData.focus();
			return false;
		}
		
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="Processo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	intCodAssunto		= Trim(Request.Form("cmbAssunto"))
	intCodModalidade	= Trim(Request.Form("cmbModalidade"))
	strNumero			= Trim(Request.Form("txtNumero"))
	strObjeto 			= Trim(Request.Form("txtObjeto"))
	strData 			= Trim(Request.Form("txtData"))
	strSituacao	 		= Trim(Request.Form("cmbSituacao"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, CodEmpresa, codAssunto, codModalidade, Numero, objeto, dataCadastro, Situacao"
		sql = sql & " FROM SCC_processo"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			intCodAssunto		= rs("codAssunto")
			intCodModalidade	= rs("codModalidade")
			strNumero			= rs("Numero")
			strObjeto			= rs("objeto")
			strData				= formatadataAP(rs("dataCadastro"))
			strSituacao			= rs("Situacao")
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoPDF   				= "disabled"
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
            <td height="23" class="TextoForm">Assunto:</td>
            <td class="TextoForm"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              <!--#include file="../../../includes/inc_cmbAssunto.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Modalidade:</td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbModalidade.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">N&uacute;mero:</td>
            <td class="TextoForm"><input name="txtNumero" type="text" class="text" id="txtNumero" size="40" maxlength="40" value="<%=strNumero%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Objeto</td>
            <td class="TextoForm"><input name="txtObjeto" type="text" class="text" id="txtObjeto" size="40" maxlength="40" value="<%=strObjeto%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Data:              </td>
            <td class="TextoForm"><input name="txtData" type="text" class="text" id="txtData"  onBlur="validaData(this);" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="11" maxlength="11"></td>
          </tr>
          <tr>
            <td width="16%" height="23" class="TextoForm">Situa&ccedil;&atilde;o:</td>
            <td width="25" class="TextoForm">
            <select name="cmbSituacao" class="Combo" id="cmbSituacao">
                <option value="0">Selecione...</option>
                <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
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
          <td class="tituloPrincipal style2" colspan="2">
		  <%
					cont =0
				
					sql = "SELECT Codigo, CodEmpresa, codAssunto, codModalidade, objeto, dataCadastro, Situacao, numero"
					sql = sql & " FROM SCC_processo"
					sql = sql & " Where CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " Order by Codigo"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="24%" class="celula"><strong>N&uacute;mero</strong></td>
                        <td width="70%" height="21" class="celula"><strong>Objeto</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="6%" class="celula"><%=rs("Codigo")%></td>
                            <td class="celula"><%=rs("numero")%></td>
                            <td height="21" class="celula"><%=trim(rs("objeto"))%></td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
              <tr>
                <td height="21" colspan="3" class="celula">Total 
                  Registros : <%=cont%></td>
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