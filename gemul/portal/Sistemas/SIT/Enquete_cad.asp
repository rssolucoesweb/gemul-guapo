<%strNomeDaPaginaPortal = "Nome do Cadastro"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function abreOpcoesEnquete(codigo){
		var caminho
		caminho = "EnqueteOpcoes_cad.asp?CodEnquete=" + codigo
		window.open(caminho ,"","toolbar=no,status=no,location=no,scrollbars=no,menubar=no,resizable=no,width=600,height=300,top=0,lef=0");
	}

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodEnquete.value=intCodigo
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtPergunta.value == "") {
			alert("A Pergunta da Enquete deve ser informada!");
			frm.txtPergunta.focus();
			return false;
		}
	
		frm.action="Enquete_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
		
</script>
<%
	principal		= "principal.asp"
	intCodEmpresa	= session("codEmpresa")	
	intCodEnquete 	= Trim(Request.Form("txtCodEnquete"))
	strPergunta  	= Trim(Request.Form("txtPergunta"))
	strAtivo		= Trim(request.Form("chkAtivo"))
	strData			= formatadataAP(date)
 		
	if intCodEnquete <> "" then
	
		sql = "SELECT Codigo, Pergunta, Date, Status"
		sql = sql & " FROM SIT_Enquete"
		sql = sql & " Where Codigo = " & intCodEnquete
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
		
			intCodEnquete	= rs("Codigo")
			strPergunta  	= rs("Pergunta")
			strData			= formataDataAP(rs("Date"))
			
			if rs("Status") = "A" then
				strAtivo 	= "A"
			else
				strAtivo 	= "I"
			end if
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoOpcoesEnquete		= "" 'Desabilita o botão Excluir
		
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoOpcoesEnquete		= "disabled" 'Desabilita o botão Excluir
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
          <td class="TextoForm">Pergunta : <input name="txtCodEnquete" type="hidden" class="text" id="txtCodEnquete" size="5" maxlength="5" value="<%=intCodEnquete%>"></td>
          <td><input name="txtPergunta" type="text" class="text" id="txtPergunta" size="50" maxlength="50" value="<%=strPergunta%>"></td>
        </tr>
        <tr>
          <td class="TextoForm">Data :</td>
          <td class="TextoForm"><input name="txtData" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="14" maxlength="11">
              <font color="#999999">ex.: dd/mm/aaaa</font></td>
        </tr>
        <tr>
          <td height="27" class="TextoForm">Situa&ccedil;&atilde;o:</td>
          <td><span class="TextoForm">
            <input name="chkAtivo" type="checkbox" id="chkAtivo" <%if strAtivo ="A" then response.Write("checked")%> value="A">
            <font color="#999999">Ativo</font></span></td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td><span class="texto">
            <input name="cmdOpcoesEnquete" type='button' class='botao' id="cmdOpcoesEnquete" value='Op&ccedil;&otilde;es Enquete' onClick="abreOpcoesEnquete('<%=intCodEnquete%>')"<%=BotaoOpcoesEnquete%>>
          </span></td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm"><%
		   cont =0
			sql = "SELECT Codigo, Pergunta, Date, Status"
			sql = sql & " FROM SIT_Enquete"
			sql = sql & " Where CodEmpresa = " & intCodEmpresa
			sql = sql & " Order by Codigo desc "
			rs.open sql, cnn
							
			if rs.eof = false then
  			%>
            <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr bgcolor="#E5E5E5">
                <td class="celula"><strong>C&oacute;digo</strong></td>
                <td class="celula"><strong>Pergunta</strong></td>
                <td height="21" class="celula"><strong>Data</strong></td>
              </tr>
              <%
				while not rs.eof
					cont = cont + 1	
					%>
		  		<tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                <td width="7%" class="celula"><%=rs("Codigo")%></td>
                <td width="79%" class="celula"><%=trim(rs("Pergunta"))%></td>
                <td width="14%" height="21" class="celula">&nbsp;<%=trim(formatadataAP(rs("Date")))%></td>
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
        <tr>
          <td  width="13%" class="TextoForm">&nbsp;</td>
          <td width="87%">&nbsp;</td>
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
