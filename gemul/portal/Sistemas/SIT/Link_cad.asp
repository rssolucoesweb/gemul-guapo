<%strNomeDaPaginaPortal = "Cadastro de Links"%>
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição do Link deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtSite.value == "") {
			alert("O Nome do Site deve ser informado !");
			frm.txtSite.focus();
			return false;
		}
		
		frm.action="Link_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	principal			= "principal.asp"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSite		 		= Trim(Request.Form("txtSite"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT  Codigo, Descricao, Site"
		sql = sql & " FROM SIT_Links"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strDescricao		= rs("Descricao")
			strSite				= rs("Site")
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoPDF				= ""

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
            <td width="16%" height="23" class="TextoForm">Descri&ccedil;&atilde;o:<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
            <td width="25" class="TextoForm"><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
            </tr>
          <tr>
            <td height="24" class="TextoForm">Site : </td>
            <td class="TextoForm"><span class="texto">
              <input name="txtSite" type="text" class="text" onKeyUp="mascara(this,site)" id="txtSite"  size="60" maxlength="60" value="<%=strSite%>">
            </span></td>
        </tr>
        <tr valign="top">
          <td  height="15"  class="tituloPrincipal style2"></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="2"><%
				cont =0
					
					sql = "SELECT Codigo, Descricao, Site"
					sql = sql & " FROM SIT_Links"
					sql = sql & " Where CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " Order by Descricao"
				
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
            <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr bgcolor="#E5E5E5">
                <td class="celula"><strong>C&oacute;digo</strong></td>
                <td class="celula"><strong>Descricao</strong></td>
                <td height="21" class="celula"><strong>Site</strong></td>
              </tr>
              <%
						while not rs.eof
							cont = cont + 1	
							%>
              <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                <td width="10%" class="celula"><%=rs("Codigo")%></td>
                <td width="33%" class="celula"><%=trim(rs("Descricao"))%></td>
                <td width="57%" height="21" class="celula">&nbsp;<%=trim(rs("Site"))%></td>
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
