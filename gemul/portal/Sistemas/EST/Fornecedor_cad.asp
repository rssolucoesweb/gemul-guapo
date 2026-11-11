<%strNomeDaPaginaPortal = "Cadastro de Fornecedor"%>
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
		if (frm.cmbSecaoProduto.value == "0") {
			alert("Seção deve ser informada!");
			frm.cmbSecaoProduto.focus();
			return false;
		}
		
		
		if (frm.cmbTipoPessoa.value == "0") {
			alert("O Tipo Pessoa deve ser informado !");
			frm.cmbTipoPessoa.focus();
			return false;
		}
		
		
		if (frm.txtNumero.value == "") {
			alert("O Numero deve ser informado !");
			frm.txtNumero.focus();
			return false;
		}
		
		if (frm.txtRazaoSocialNome.value == "") {
			alert("A Razão Social Nome deve ser informada !");
			frm.txtRazaoSocialNome.focus();
			return false;
		}
		
		if (frm.txtEndereco.value == "") {
			alert("O Endereco deve ser informado !");
			frm.txtEndereco.focus();
			return false;
		}
		
		if (frm.txtTelefone.value == "") {
			alert("O Telefone deve ser informado !");
			frm.txtTelefone.focus();
			return false;
		}
		
		if (frm.txtResponsavel.value == "") {
			alert("O Responsavel deve ser informado !");
			frm.txtResponsavel.focus();
			return false;
		}
		
		frm.action="fornecedor_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	strEmpresaSecaoProduto_submit = "S"
	
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strTipoPessoa 		= Trim(Request.Form("cmbTipoPessoa"))
	strNumero	 		= Trim(Request.Form("txtNumero"))
	strRazaoSocialNome	= Trim(Request.Form("txtRazaoSocialNome"))
	strEndereco	 		= Trim(Request.Form("txtEndereco"))
	strTelefone	 		= Trim(Request.Form("txtTelefone"))
	strResponsavel	 	= Trim(Request.Form("txtResponsavel"))
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, CodEmpresa, TipoPessoa, Numero, RazaoSocialNome, Endereco, Telefone, Responsavel"
		sql = sql & " FROM EST_fornecedor"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		sql = sql & " and cod_secao = " & intSecaoProduto
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strTipoPessoa		= rs("TipoPessoa")
			strNumero			= rs("Numero")
			strRazaoSocialNome	= rs("RazaoSocialNome")
			strEndereco	 		= rs("Endereco")
			strTelefone	 		= rs("Telefone")
			strResponsavel	 	= rs("Responsavel")
						
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
            <td height="23" class="TextoForm"><span class="texto1">Se&ccedil;&atilde;o:</span></td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbSecaoProduto.asp" --></td>
          </tr>
          <tr>
            <td width="16%" height="23" class="TextoForm">Tipo Pessoa:</td>
            <td width="25" class="TextoForm">
            <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
            <select name="cmbTipoPessoa" class="Combo" id="cmbTipoPessoa">
              <option value="0">Selecione...</option>
              <option value="F" <%if strTipoPessoa = "F" then response.Write("selected") %>>F&iacute;sica</option>
              <option value="J" <%if strTipoPessoa = "J" then response.Write("selected") %>>Jur&iacute;dica</option>
            </select></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">CPF/CNPJ:</td>
            <td class="TextoForm"><input name="txtNumero" type="text" class="text" id="txtNumero" size="30" maxlength="30" value="<%=strNumero%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Raz&atilde;o Social/ Nome: </td>
            <td class="TextoForm"><input name="txtRazaoSocialNome" type="text" class="text" id="txtRazaoSocialNome" size="40" maxlength="100" value="<%=strRazaoSocialNome%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Endere&ccedil;o:</td>
            <td class="TextoForm"><input name="txtEndereco" type="text" class="text" id="txtEndereco" size="40" maxlength="100" value="<%=strEndereco%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Telefone:</td>
            <td class="TextoForm"><input name="txtTelefone" type="text" class="text" id="txtTelefone" size="40" maxlength="40" value="<%=strTelefone%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Responsavel:</td>
            <td class="TextoForm"><input name="txtResponsavel" type="text" class="text" id="txtResponsavel" size="40" maxlength="40" value="<%=strResponsavel%>"></td>
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

					sql = "SELECT Codigo, CodEmpresa, TipoPessoa, Numero, RazaoSocialNome"
					sql = sql & " FROM EST_fornecedor"
					sql = sql & " Where CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " and COD_SECAO = "& intSecaoProduto	
					sql = sql & " Order by Codigo"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="89%" height="21" class="celula"><strong>Raz&atilde;o Social / Nome</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="11%" class="celula"><%=rs("Codigo")%></td>
                            <td height="21" class="celula"><%=trim(rs("RazaoSocialNome"))%></td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
              <tr>
                <td height="21" colspan="2" class="celula">Total 
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