<%strNomeDaPaginaPortal = "Alterar Senha"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/Seg_AlterarSenha_cad.js"></script>
<%  
'codigo fonte em ASP

	strCPF				= Trim(session("strUsuario"))
	mostrarBotaoPrincipal	= "N"
	strAcessoBloqueado		= "N"
	strDesabilita		 = "" 
	strDesabilitaIncluir = "disabled" 'Hesabilita o botão Incluir
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Habilita o botão Excluir
	strDesabilitaLimpar  = "disabled" 'Habilita o Botão Limpar	

	if trim(strCPF)<>"" then
		strDataAlteracaoSenha = ""
		strDesabilita = ""

		if trim(strCPF)<>"" then
			'acessa o cadastra de senha
			sql = " SELECT nome, data_alteracao_senha"
			sql = sql & " FROM SEG_usuarios" 
			sql = sql & " WHERE cpf = " & formataCpfBD(strCPF)
			rs.open sql , cnn		
			if not rs.eof then	
				strNome = rs("nome")
				strDataAlteracaoSenha = rs("data_alteracao_senha")
				
				strDesabilitaIncluir = "disabled" 'Hesabilita o botão Incluir
				strDesabilitaAlterar = "" 'Habilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Habilita o botão Excluir
				strDesabilitaLimpar  = "disabled" 'Habilita o Botão Limpar	
				rs.close		
			else
				rs.close		
				%>
				<script>
					alert("Usuário não foi encontrado.");
					window.location='/';
				</script>
				<%			
				response.End()
			end if
		end if		
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

  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr> 
      <td width="21%" class="TextoForm">Usu&aacute;rio</td>
      <td class="TextoForm">
      <input disabled name="txtCPF" type="text" class="caixaTexto" id="txtCPF" value="<%=formataCpfAP(strCPF)%>" size="15" maxlength="14">
      <input type="hidden" name="txtDataAlteracaoSenha" id="txtDataAlteracaoSenha" value="<%=strDataAlteracaoSenha%>">
      &nbsp;&nbsp;<strong><%=strNome%></strong></td>
    </tr>
    <tr>
      <td class="TextoForm">Senha antiga</td>
      <td><input name="txtSenhaAntiga" class="caixaTexto" type="password" value="" id="txtSenhaAntiga" size="25" maxlength="32"></td>
    </tr>
    <tr> 
      <td class="TextoForm">Senha nova</td>
      <td width="79%"><input name="txtSenha" class="caixaTexto" type="password" value="" id="txtSenha" size="25" maxlength="32"></td>
    </tr>
    <tr> 
      <td class="TextoForm">Confirma&ccedil;&atilde;o da senha nova</td>
      <td><input name="txtCSenha" class="caixaTexto" type="password" value="" id="txtCSenha" size="25" maxlength="32"></td>
    </tr>
    <tr> 
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="2"> <!--#include file="../../../includes/inc_botoes_cadastro.asp"--> </td>
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