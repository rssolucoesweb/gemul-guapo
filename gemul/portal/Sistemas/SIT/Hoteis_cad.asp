<%strNomeDaPaginaPortal = "Cadastro de Hoteis"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtNome.value == "") {
			alert("O Nome do Hotel deve ser informado");
			frm.txtNome.focus();
			return false;
		}
		
		if (frm.txtEndereco.value == "") {
			alert("O Endereço deve ser informado");
			frm.txtEndereco.focus();
			return false;
		}
		
		if (frm.txtCidade.value == "") {
			alert("A Cidade deve ser informada");
			frm.txtCidade.focus();
			return false;
		}
			
		if (frm.txtUF.value == "") {
			alert("O Estado deve ser informado");
			frm.txtUF.focus();
			return false;
		}
		
		if (frm.txtFone.value == "") {
			alert("O Telefone deve ser informado");
			frm.txtFone.focus();
			return false;
		}
	
		frm.action="Hoteis_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}


</script>
<%	
	principal			= "principal.asp"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strNome				= Trim(Request.Form("txtNome"))
	strEndereco 		= Trim(Request.Form("txtEndereco"))
	strCidade  			= Trim(Request.Form("txtCidade"))
	strUF 		 		= Trim(Request.Form("txtUF"))
	strFone				= Trim(Request.Form("txtFone"))
	strVlrDiaria 		= Trim(Request.Form("txtVlrDiaria"))
	strVlrDesc			= Trim(Request.Form("txtVlrDesc"))
	strEmail 			= Trim(Request.Form("txtEmail"))
	strSite 			= Trim(Request.Form("txtSite"))
	
	if intCodigo <> "" then 
	
		sql = " SELECT Codigo, Nome, Endereco, Cidade, UF, Fone, "
		sql = sql & " VlrDiaria, VlrDesconto, Email, Site" 
		sql = sql & " FROM SIT_Hoteis" 
		sql = sql & " Where codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
					
		if rs.eof = false then

			strNome				=  rs("Nome")
			strEndereco 		=  rs("Endereco")
			strCidade  			=  rs("Cidade")
			strUF 		 		=  rs("UF")
			strFone				=  rs("Fone")
			
			if rs("VlrDiaria") <> "" then
				strVlrDiaria 		=  formatnumber(rs("VlrDiaria"),2)
			end if
			
			if rs("VlrDesconto") <> "" then
				strVlrDesc			=  formatnumber(rs("VlrDesconto"),2)
			end if
			
			strEmail 			=  rs("Email")
			strSite 			=  rs("Site")

			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar'
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
				
		end if 
		rs.close

	else
	
		strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar'
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir'
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		
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
	
    <table width="98%" border="0" cellpadding="0" cellspacing="0" >
        <tr>
          <td width="13%" height="23"  class="TextoForm">Nome :<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          <td colspan="3"><input name="txtNome" class="text" type="text" id="txtNome"  value="<%=strNome%>" size="60" maxlength="40"></td>
        </tr>
        <tr>
          <td height="24" class="TextoForm">Endere&ccedil;o : </td>
          <td colspan="3"><input name="txtEndereco" class="text" type="text" id="txtEndereco" value="<%=strEndereco%>" size="60" maxlength="60"></td>
        </tr>
        <tr>
          <td height="28" class="TextoForm" >Cidade</td>
          <td width="20%" class="TextoForm"><input name="txtCidade" class="text" type="text" id="txtCidade" size="20" value="<%=strCidade%>" maxlength="20"></td>
          <td width="13%" class="TextoForm">UF</td>
          <td width="54%" class="TextoForm"><input name="txtUF" class="text" type="text" id="txtUF" size="5" value="<%=strUF%>" maxlength="2"></td>
        </tr>
        <tr>
          <td height="24" class="TextoForm" >Telefone :</td>
          <td colspan="3" class="TextoForm"><input name="txtFone" class="text" type="text" id="txtFone" size="15" value="<%=strFone%>" onKeyPress="mascara(this,telefone)"  maxlength="15">
            <font color="#999999">(xx)xxx-xxxx</font></td>
        </tr>
        <tr>
          <td height="25" class="TextoForm">Valor Di&aacute;ria R$ : </td>
          <td><span class="TextoForm">
            <input name="txtVlrDiaria" class="text" type="text" id="txtVlrDiaria" size="10" onKeyPress="return currencyFormat(this,event)" value="<%=strVlrDiaria%>" maxlength="5">
          </span></td>
          <td class="TextoForm">Valor Desc. R$ : </td>
          <td><span class="TextoForm">
            <input name="txtVlrDesc" class="text" type="text" id="txtVlrDesc" size="10" onKeyPress="return currencyFormat(this,event)" value="<%=strVlrDesc%>" maxlength="5">
          </span></td>
        </tr>
        <tr>
          <td height="26" class="TextoForm">E-mail:</td>
          <td colspan="3"><input name="txtEmail" class="text" type="text" id="txtEmail" value="<%=strEmail%>" size="60" maxlength="60"></td>
        </tr>
        <tr>
          <td class="TextoForm">Site:</td>
          <td colspan="3"><input name="txtSite" class="text" type="text" id="txtSite" value="<%=strSite%>" size="60" maxlength="60"></td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>

        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4"><%
					
						cont =0
						sql = " SELECT Codigo, Nome" 
						sql = sql & " FROM SIT_Hoteis" 
						sql = sql & " Where CodEmpresa = " & intCodEmpresa
						sql = sql & " Order by codigo"
						
						rs.open sql, cnn
										
						if rs.eof = false then
						%>
                          <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                            <tr bgcolor="#E5E5E5">
                              <td class="celula"><strong>C&oacute;d. Hotel </strong></td>
                              <td height="21" class="celula"><strong>Nome</strong></td>
                            </tr>
                            <%
							while not rs.eof
							cont = cont + 1		
							%>
                            <tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                              <td width="14%" class="celula"><%=rs("Codigo")%></td>
                              <td height="21" class="celula"><%=rs("Nome")%></td>
                            </tr>
                            <%				
								rs.movenext
								wend
							%>
                            <tr>
                            	<td height="21" colspan="2" class="celula">Total Registros : <%=cont%> </td>
                            </table>
                            <%
						  	end if
							rs.close
						  %>
            	</td>
        	</tr>
        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;</td>
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