<%strNomeDaPaginaPortal = "Cadastro de Conv&ecirc;nios"%>
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
		
		if (frm.txtNome.value == "") {
			alert("O Nome deve ser informado !");
			frm.txtNome.focus();
			return false;
		}
		
		if (frm.txtEndereco.value == "") {
			alert("O Endereço deve ser informado!");
			frm.txtEndereco.focus();
			return false;
		}
	
		frm.action="Convenios_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%	
	principal			= "principal.asp"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strNome  			= Trim(Request.Form("txtNome"))
	strEndereco 		= Trim(Request.Form("txtEndereco"))
	strTelefone 		= Trim(Request.Form("txtTelefone"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	
	if intCodigo <> "" then 
	
		sql = " SELECT Codigo, Nome, Endereco, Telefone, Descricao"
		sql = sql & " FROM SIT_Convenios" 
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
					
		if rs.eof = false then

			strNome			= trim(rs("Nome"))
			strEndereco 	= trim(rs("Endereco"))
			strTelefone  	= trim(rs("Telefone"))
			strDescricao  	= trim(rs("Descricao"))
			
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
          <td width="13%"  class="TextoForm">Nome : <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          <td width="87%"><input name="txtNome" class="text" type="text" id="txtNome" onKeyPress="return formataCampo(this,4,100)"  value="<%=strNome%>" size="60" maxlength="60"></td>
        </tr>
        <tr>
          <td class="TextoForm">Endere&ccedil;o : </td>
          <td><input name="txtEndereco" class="text" type="text" id="txtEndereco" value="<%=strEndereco%>" size="60" maxlength="60"></td>
        </tr>
        <tr>
          <td class="TextoForm" >Telefone :</td>
          <td class="TextoForm"><input name="txtTelefone" class="text" type="text" id="txtTelefone" size="15" value="<%=strTelefone%>" maxlength="15"></td>
        </tr>
        <tr>
          <td class="TextoForm" >Descri&ccedil;ao :</td>
          <td class="TextoForm"><textarea name="txtDescricao" cols="60" rows="5" class="text" id="txtDescricao"><%=strDescricao%></textarea>          </td>
        </tr>
        <tr>
          <td class="texto">&nbsp;</td>
          <td class="texto">obs: para cada linha na descri&ccedil;ao use &lt;br&gt;</td>
        </tr>

        <tr>
          <td colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2"><%
					
						cont =0
			
						sql = " SELECT Codigo, Nome, Endereco, Telefone, Descricao"
						sql = sql & " FROM SIT_Convenios" 
						sql = sql & " Where CodEmpresa = " & intCodEmpresa
						sql = sql & " Order by Codigo"
						rs.open sql, cnn
										
						if rs.eof = false then
						%>
              <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td class="celula"><strong>C&oacute;d. </strong></td>
                  <td width="64%" class="celula"><strong>Nome</strong></td>
                  <td width="22%" height="21" class="celula"><strong>Telefone</strong></td>
                </tr>
                <%
							while not rs.eof
							cont = cont + 1		
							%>
                <tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                  <td width="14%" class="celula"><%=rs("Codigo")%></td>
                  <td class="celula"><%=rs("Nome")%></td>
                  <td height="21" class="celula"><%=rs("Telefone")%>&nbsp;</td>
                </tr>
                <%				
								rs.movenext
								wend
							%>
                <tr>
                  <td height="21" colspan="3" class="celula">Total 
                    Registros : <%=cont%> </td>
              </table>
            <%
						  	end if
						rs.close
						  %>          </td>
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
