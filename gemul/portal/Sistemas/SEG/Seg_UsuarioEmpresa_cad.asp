<%strNomeDaPaginaPortal = "Cadastro de Usuários"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_Mascaras.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_criptografia.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script>
	function salvar(acao){
		var frm = document.getElementById("frm");
		if (frm.txtCPF.value == "") {
			alert("O CPF deve ser informado!");
			frm.txtCPF.focus();
			return false;
		} 
		if (frm.txtNome.value == "") {
			alert("O nome deve ser informado!");
			frm.txtNome.focus();
			return false;
		}
		if (frm.cmbSituacaoUsuario.value == "0") {
			alert("Situação deve ser informada!");
			frm.cmbSituacaoUsuario.focus();
			return false;
		}
		frm.action="Seg_UsuarioEmpresa_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function validar_Email() {
		var email = frm.txtEmail.value;
		if (email != ""){
			if (email.indexOf('@') == -1 || email.indexOf('.') == -1) {
				alert ('Este e-mail é inválido');
				frm.txtEmail.value = '';
				frm.txtEmail.focus();
			}
		}  
	}   
</script>

<%  
'codigo fonte em ASP
	strLiberaAlteracao	= "S"
	StrReloadPerfilMenu = "N"
	strCPF				= Trim(Request("txtCPF"))
	strNome     		= request.Form("txtNome")
	strTelefone     	= request.Form("txtTelefone")
	strEmail     		= request.Form("txtEmail")
	strSenha     		= request.Form("txtSenha")
	strSituacaoEmpresa	= request.Form("cmbSituacaoUsuario")
	intCodPerfilEmpresa = request.Form("cmbCodPerfilEmpresa")
	
	mostrarBotaoPrincipal	= "N"
	strDesabilita		 = "" 
	strDesabilitaIncluir = "" 'Hesabilita o botão Incluir
	strDesabilitaAlterar = "" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Habilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar	
	strEstiloCampo 		 = "caixaTexto"
	strDesabilitaPerfilAcesso= "disabled" 
	if trim(strCPF)<>"" then
		strSenha = ""
		strDesabilita = ""

		if trim(strCPF)<>"" then
			
			'acessa o cadastra de senha
			sql = " select nome, senha, situacao, telefone, email, data_ultimo_acesso, data_alteracao_senha, data_ativacao, codDepartamento, codSecao "
			sql = sql & " from SEG_usuarios"
			sql = sql & " left join SEG_usuarios_acesso on SEG_usuarios_acesso.cpf_SEG_usuarios = SEG_usuarios.cpf"
			sql = sql & " where SEG_usuarios_acesso.codEmpresa = " & session("codEmpresa") 
			'sql = sql & " and SEG_usuarios_acesso.cpf_SEG_usuarios not in (select cpf_SEG_usuarios from SEG_usuarios_acesso_master)"
			sql = sql & " and SEG_usuarios.cpf = " & formataCpfBD(strCPF)
			rs.open sql , cnn		
			if not rs.eof then	
				strNome = rs("nome")
				strTelefone = rs("telefone")
				if not isnull(strTelefone) and strTelefone<>"" then
					strTelefone = InsereMascaraFone(strTelefone)
				end if
				strEmail 				= rs("email")
				strSituacaoEmpresa		= trim(rs("situacao"))
				intCodDepartamento		= rs("codDepartamento")
				intSecaoUsuario			= rs("codSecao")
				
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
				strDesabilitaPerfilAcesso= "" 
				intCodPerfilEmpresa = "0"
				sql = "select codigo_SEG_perfil from SEG_usuarios_acesso"
				sql = sql & " WHERE cpf_SEG_usuarios = " & formataCpfBD(strCPF)
				sql = sql & " And codEmpresa = " & session("codEmpresa")
				rsAux.open sql , cnn		
				if not rsAux.eof then
					intCodPerfilEmpresa = rsAux("codigo_SEG_perfil")				
				end if
				rsAux.close
			else
				strDesabilitaIncluir = "" 'Hesabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Habilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar	
				strDesabilitaPerfilAcesso= "disabled" 
			
			end if
			rs.close		
		end if	
			
		'acessa o cadastra de senha
'		sql = " select cpf_SEG_usuarios from SEG_usuarios_acesso_master"
'		sql = sql & " where cpf_SEG_usuarios = " & formataCpfBD(strCPF)
'		rs.open sql , cnn		
'		if not rs.eof then
'			strDesabilitaIncluir = "disabled" 'Hesabilita o botão Incluir
'			strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
'			strDesabilitaExcluir = "disabled" 'Habilita o botão Excluir
'			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar	
'		end if
'		rs.close
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
      <td width="15%" class="TextoForm">Usu&aacute;rio</td>
      <td colspan="3">
      <input name="txtCPF" type="text" class="caixaTexto" id="txtCPF" onBlur="validaCPF(this); return reload()" onKeyPress="return formataCampo(this, 5, 14)" value="<%=formataCpfAP(strCPF)%>" size="15" maxlength="14">
      <a href="#" onClick="return abreConsulta('Seg_UsuarioEmpresa_con.asp')"> <img src="../../../images/Consulta_normal.gif" alt="" name="Consulta" width="26" height="26" border="0" align="absmiddle"></a>&nbsp;&nbsp;<strong><%=strNomeServidor%></strong></td>
      </tr>
    <tr>
      <td class="TextoForm">Nome Completo</td>
      <td colspan="3"><input name="txtNome" class="caixaTexto" type="text" id="txtNome" value="<%=strNome%>" <%=strDesabilita%> size="50" maxlength="80"></td>
      </tr>
    <tr>
      <td class="TextoForm">Telefone</td>
      <td colspan="3" class="TextoForm"><input name="txtTelefone" type="text" class="caixaTexto" id="txtTelefone" value="<%=strTelefone%>" size="15" onKeyPress="mascara(this,telefone)" maxlength="14"></td>
    </tr>
    <tr>
      <td class="TextoForm">Email</td>
      <td colspan="3"><input id="txtEmail" name="txtEmail" type="text" class="caixaTexto" value="<%=strEmail%>" onBlur="validar_Email();" size="50" maxlength="50" ></td>
    </tr>
    <tr>
      <td class="TextoForm">Lota&ccedil;&atilde;o</td>
      <td colspan="3"><!--#include file="../../../includes/inc_cmbDepartamentoEstoque.asp"--></td>
    </tr>
    <tr>
      <td class="TextoForm">Se&ccedil;&atilde;o/Almoxarifado</td>
      <td colspan="3"><!--#include file="../../../includes/inc_cmbSecaoUsuario.asp" --></td>
    </tr>
    <tr> 
      <td class="TextoForm">Senha</td>
      <td colspan="3"><input readonly name="txtSenha" class="caixaTextoDesabilitada" type="password" value="<%=strSenha%>" id="txtSenha" size="20" maxlength="32">
        <input name="txtSenhaAtual" type="hidden" value="<%=strSenha%>"></td>
    </tr>
    <tr> 
      <td class="TextoForm">Confirma&ccedil;&atilde;o da senha</td>
      <td colspan="3"><input readonly name="txtCSenha" class="caixaTextoDesabilitada" type="password" value="<%=strSenha%>" id="txtCSenha" size="20" maxlength="32"></td>
      </tr>
    <tr>
      <td class="TextoForm">Senha tempor&aacute;ria</td>
      <td colspan="3" class="TextoForm"><input class="caixaTexto" type=text name="txtSenhaCriada" id="txtSenhaCriada" size="20">
      <span class="style1">&nbsp;(Utilizada para o primeiro acesso) </span></td>
      </tr>
    <tr>
      <td class="TextoForm">Situa&ccedil;&atilde;o</td>
      <td width="17%" class="TextoForm"><!--#include file="../../../includes/inc_cmbSituacaoUsuario.asp"-->
      </td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
      </tr>
    <tr>
      <td class="TextoForm">Data ativa&ccedil;&atilde;o</td>
      <td><input readonly class="caixaTextoDesabilitada" type=text name="txtDataAtivacao" id="txtDataAtivacao" size="20" value="<%=strDataAtivacao%>"></td>
      <td width="15%" class="TextoForm">Data do &uacute;ltimo acesso</td>
      <td width="53%"><input readonly class="caixaTextoDesabilitada" type=text name="txtDataUltimoAcesso" id="txtDataUltimoAcesso" size="20" value="<%=strDataUltimoAcesso%>"></td>
    </tr>
    <tr>
      <td class="TextoForm">Data  altera&ccedil;&atilde;o de senha</td>
      <td><input readonly class="caixaTextoDesabilitada" type=text name="txtDataAlteracaoSenha" id="txtDataAlteracaoSenha" size="20" value="<%=strDataAlteracaoSenha%>"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
    </tr>
        <tr> 
      <td colspan="4">
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
<%strMostraBotaoPerfilAcesso = "S" %>
    <tr>
      <td><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->      </td>
    </tr>
  </table>   
		<%	
		if trim(strCPF) <> "" then
			' Seleciona todos os grupos cadastrados
			sql = " SELECT SEG_usuarios_acesso.codigo_SEG_perfil, SEG_perfil.descricao as perfil, SEG_empresa.codigo, SEG_empresa.nomefantazia as descricao, SEG_empresa.codigo as codigo_empresa "
			sql = sql & "     FROM SEG_empresa "
			sql = sql & "     INNER JOIN (SEG_perfil INNER JOIN SEG_usuarios_acesso ON SEG_perfil.codigo = SEG_usuarios_acesso.codigo_SEG_perfil) ON SEG_empresa.codigo = SEG_usuarios_acesso.codEmpresa"
			sql = sql & "     where SEG_usuarios_acesso.cpf_SEG_usuarios = " & formataCpfBD(strCPF)
			sql = sql & " 	  and SEG_usuarios_acesso.cpf_SEG_usuarios not in (select cpf_SEG_usuarios from SEG_usuarios_acesso_master)"
			sql = sql & " order by 2"
			rs.open sql, cnn
			if rs.eof = false then
			%>
			<br>
			<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr class="CabecalhoConsulta"> 
                    <td width="28%"class="celula">&nbsp;Perfil</td>
                  <td width="60%"class="celula">&nbsp;Acesso</td>
              </tr>
                    <%
                    while not rs.eof
						strEmp = rs("codigo_empresa") & " - "
						IF isnull(rs("codigo_empresa")) = "" then strEmp = ""
						IF rs("codigo_empresa") = "" then strEmp = ""
                        %>
                        <tr> 
                            <td align="left" class="celula">&nbsp;<%=rs("perfil")%></td>
                            <td align="left" class="celula">&nbsp;<%=strEmp%><%=rs("Descricao")%></td>
                        </tr>
                        <%
                        rs.movenext
                    wend
                rs.close
                %>
            </table> 
			<%
            end if
       	end if     
		%> 
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