<%strNomeDaPaginaPortal = "Texto Fixo"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="../../../ckeditor/ckeditor.js"></script>
<script src="../../../ckeditor/config.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTipoTexto.value == "0") {
			alert("O Tipo do Texto deve ser informado !");
			frm.cmbTipo.focus();
			return false;
		}
			
		frm.action="TextoFixo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	principal			= "principal.asp"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo			= Trim(Request.Form("txtCodigo"))
	intCodTipoTexto		= Trim(Request("cmbTipoTexto"))
 		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, CodTipoTexto, Texto"
		sql = sql & " FROM SIT_TextoFixo"
		sql = sql & " Where CodTipoTexto = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			intCodTipoTexto		= rs("CodTipoTexto")
			strTexto			= rs("Texto")
					
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
   	<!-- inicio do formulario da pagina-->
	
    <table width="98%" border="0">
        <tr>
          <td class="TextoForm">Tipo Texto:<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          <td class="texto"><span class="TextoForm">
            <!--#include file="../../../includes/inc_cmbTipoTexto.asp"-->
          </span></td>
          </tr>
        <tr>
          <td width="14%" class="TextoForm">&nbsp;</td>
          <td class="texto">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" align="left" bgcolor="#EFEFDE" class="TextoForm"><strong>Descri&ccedil;&atilde;o do Texto </strong></td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm">
           <Textarea class="ckeditor" cols="80" id="txtTexto" name="txtTexto"><%=strTexto%></textarea>
        </td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm">&nbsp;</td>
        </tr>
        <tr>
        <td colspan="2" class="TextoForm">
		  <%
					cont =0
					sql = " SELECT SIT_TextoFixo.Codigo, SIT_TextoFixo.CodTipoTexto, SIT_TipoTexto.Descricao, SIT_TextoFixo.Texto"
					sql = sql & " FROM SIT_TextoFixo "
					sql = sql & " INNER JOIN SIT_TipoTexto ON SIT_TextoFixo.CodTipoTexto = SIT_TipoTexto.Codigo"
					sql = sql & " Where SIT_TextoFixo.CodEmpresa = " & intCodEmpresa
					sql = sql & " Order by SIT_TextoFixo.CodTipoTexto"
					rs.open sql, cnn
					if rs.eof = false then
						
						%>
						<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
							<tr bgcolor="#E5E5E5">
							<td class="celula"><strong>C&oacute;digo</strong></td>
							<td height="21" class="celula"><strong>Tipo Texto</strong></td>
                		</tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
							 <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("CodTipoTexto")%>')">
							 <td width="10%" class="celula"><%=rs("CodTipoTexto")%></td>
							 <td height="21" class="celula"><%=rs("Descricao")%></td>
							 </tr>
              			<%				
						rs.movenext
						wend
						%>
             	 <tr>
                <td height="21" colspan="2" class="celula">Total Registros : <%=cont%></td>
              </table>
            <%
			  end if
			  rs.close%></td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm">&nbsp;</td>
          </tr>
        <tr>
          <td colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
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
