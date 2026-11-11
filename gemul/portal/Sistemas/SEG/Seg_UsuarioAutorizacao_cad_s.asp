<%strNomeDaPaginaPortal = "Cadastro de Usuários"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_Mascaras.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_criptografia.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/Seg_UsuarioAutorizacao_cad.js"></script>
<script>
	function geraSenha(){
	}
</script>

<%  
'codigo fonte em ASP
	strCPF				= Trim(Request("txtCPF"))
	strNome     		= request.Form("txtNome")
	strTelefone     	= request.Form("txtTelefone")
	strEmail     		= request.Form("txtEmail")
	strSenha     		= request.Form("txtSenha")
	strSituacao    		= request.Form("cmbSituacao")
	
	mostrarBotaoPrincipal	= "N"
	strDesabilita		 = "" 
	strDesabilitaIncluir = "" 'Hesabilita o botão Incluir
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Habilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar	
	strEstiloCampo 		 = "caixaTexto"

	if trim(strCPF)<>"" then
		strSenha = ""
		strDesabilita = ""

		if trim(strCPF)<>"" then
			'acessa o cadastra de senha
			sql = " SELECT nome, senha, situacao, telefone, email, data_ultimo_acesso, data_alteracao_senha, data_ativacao, codDepartamento, codSecao "
			sql = sql & " FROM SEG_usuarios" 
			sql = sql & " WHERE cpf = " & formataCpfBD(strCPF)
			rs.open sql , cnn		
			if not rs.eof then	
				strNome = rs("nome")
				strTelefone = rs("telefone")
				if not isnull(strTelefone) and strTelefone<>"" then
					strTelefone = InsereMascaraFone(strTelefone)
				end if
				strEmail 				= rs("email")
				intCodDepartamento		= rs("codDepartamento")
				intSecaoUsuario			= rs("codSecao")
				strSituacao 			= rs("situacao")
				strDataAtivacao			= rs("data_ativacao")
				strDataAlteracaoSenha 	= rs("data_alteracao_senha")
				strDataUltimoAcesso 	= rs("data_ultimo_acesso")
				
				if isnull(rs("senha")) = false then
					strSenha = rs("senha")
					'Descriptografica Senha
					if strSenha <> "" then 
						strSenha0 = FormatCripto(strSenha,True)
						strSenha1 = FormatCripto(strSenha,False)
					end if				
				end if
				
				strDesabilitaIncluir = "disabled" 'Hesabilita o botão Incluir
				strDesabilitaAlterar = "" 'Habilita o botão Alterar
				strDesabilitaExcluir = "" 'Habilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar	
			else
				strDesabilitaIncluir = "" 'Hesabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Habilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar	
			
			end if
			rs.close		
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
      <td width="20%" class="TextoForm">Usu&aacute;rio</td>
      <td colspan="3">
      <input name="txtCPF" type="text" class="caixaTexto" id="txtCPF" onBlur="validaCPF(this); return reload()" onKeyPress="return formataCampo(this, 5, 14)" value="<%=formataCpfAP(strCPF)%>" size="15" maxlength="14">
      <a href="#" onClick="return abreConsulta('Seg_UsuarioAutorizacao_con.asp')"> <img src="../../../images/Consulta_normal.gif" alt="" name="Consulta" width="26" height="26" border="0" align="absmiddle"></a>&nbsp;&nbsp;<strong><%=strNomeServidor%></strong></td>
      </tr>
    <tr>
      <td class="TextoForm">Nome Completo</td>
      <td colspan="3"><input name="txtNome" class="<%=strEstiloCampo%>" type="text" id="txtNome" value="<%=strNome%>" <%=strDesabilita%> size="50" maxlength="80"></td>
      </tr>

    <tr> 
      <td colspan="4"><font size="+2"><%=strSenha1%></font></td>
    </tr>
    <tr> 
      <td colspan="4">
         </td>
      </tr>
    </table>


   	<!-- fim do formulario da pagina-->
    </form>
    
    
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>