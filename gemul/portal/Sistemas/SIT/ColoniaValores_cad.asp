<%strNomeDaPaginaPortal = "Col&ocirc;nia - Valores"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtVlrDiaria.value == "") {
			alert("O Valor da diaria deve ser informado");
			frm.txtVlrDiaria.focus();
			return false;
		}
	
		frm.action="ColoniaValores_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	
</script>
<%	
	principal			= "principal.asp"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strDescricao		= Trim(Request.Form("txtDescricao"))
	strVlrDiaria 		= Trim(Request.Form("txtVlrDiaria"))
	
	if intCodigo <> "" then 
	
		sql = " SELECT codigo, Descricao, VlrDiaria" 
		sql = sql & " FROM CLU_ColoniaValores" 
		sql = sql & " Where codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
					
		if rs.eof = false then

			strDescricao		=  rs("Descricao")
			
			if rs("VlrDiaria") <> "" then
				strVlrDiaria 		= formatnumber(rs("VlrDiaria"),2)
			end if
			
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
          <td width="20%" height="23"  class="TextoForm">Descri&ccedil;&atilde;o :<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          <td colspan="3"><input name="txtDescricao" class="text" type="text" id="txtDescricao"  value="<%=strDescricao%>" size="60" maxlength="40"></td>
        </tr>
        <tr>
          <td height="25" class="TextoForm">Valor Di&aacute;ria R$ : </td>
          <td width="29%"><span class="TextoForm">
            <input name="txtVlrDiaria" class="text" type="text" id="txtVlrDiaria" size="10" onKeyPress="return currencyFormat(this,event)" value="<%=strVlrDiaria%>" maxlength="5">
          </span></td>
          <td width="14%" class="TextoForm">&nbsp;</td>
          <td width="37%">&nbsp;</td>
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
          <td colspan="4">
		  <%
			cont =0
			sql = " SELECT Codigo, Descricao, VlrDiaria" 
			sql = sql & " FROM CLU_ColoniaValores" 
			sql = sql & " Where CodEmpresa = " & intCodEmpresa
			sql = sql & " Order by codigo"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
			  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
				<tr bgcolor="#E5E5E5">
					<td class="celula"><strong>C&oacute;d.  </strong></td>
					<td width="60%" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
					<td width="33%" height="21" class="celula"><strong>Valor</strong></td>
				</tr>
				<%
				while not rs.eof
				cont = cont + 1		
				%>
					<tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
					<td width="7%" class="celula"><%=rs("Codigo")%></td>
					<td class="celula"><%=rs("Descricao")%>&nbsp;</td>
					<td height="21" class="celula"><%=formatnumber(rs("VlrDiaria"),2)%></td>
					</tr>
				<%				
					rs.movenext
					wend
				%>
				<tr>
					<td height="21" colspan="3" class="celula">Total Registros : <%=cont%> </td>
				</table>
				<%
				end if
				rs.close
			  %></td>
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
