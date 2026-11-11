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
      <td class="TextoForm">Telefone</td>
      <td colspan="3" class="TextoForm"><input name="txtTelefone" type="text" class="caixaTexto" id="txtTelefone" value="<%=strTelefone%>" size="15" onKeyPress="formatar(this,'## ####-####')" maxlength="12"><span class="style1">&nbsp;(## ####-####) </span></td>
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
      <td colspan="3"><input class="caixaTexto" type=text name="txtSenhaCriada" id="txtSenhaCriada" size="20">
      <input type=button class="botao" value="Gerar Senha" onClick=	"geraSenha()"></td>
      </tr>
    <tr>
      <td class="TextoForm">Situa&ccedil;&atilde;o</td>
      <td width="20%" class="TextoForm">
      <strong>
        <%if trim(strSituacao)="A" then response.Write("<font color='#0000FF'>Ativo</font>")%>
        <%if trim(strSituacao)="I" then response.Write("<font color='#999999'>Inativo</font>")%>
        <%if trim(strSituacao)="B" then response.Write("<font color='#FF0000'>Bloqueado</font>")%>
      </strong>
      </td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
      </tr>
    <tr>
      <td class="TextoForm">Data ativa&ccedil;&atilde;o</td>
      <td><input readonly class="caixaTextoDesabilitada" type=text name="txtDataAtivacao" id="txtDataAtivacao" size="20" value="<%=strDataAtivacao%>"></td>
      <td width="23%" class="TextoForm">Data do &uacute;ltimo acesso</td>
      <td width="37%"><input readonly class="caixaTextoDesabilitada" type=text name="txtDataUltimoAcesso" id="txtDataUltimoAcesso" size="20" value="<%=strDataUltimoAcesso%>"></td>
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

    <tr>
      <td><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->      </td>
    </tr>
  </table>   
		<%	
		if trim(strCPF) <> "" then
			' Seleciona todos os grupos cadastrados
			sql = "SELECT     dbo.SEG_usuarios_acesso.codigo_SEG_perfil, dbo.SEG_perfil.descricao as perfil, dbo.SEG_empresa.codigo AS codEmp, "
			sql = sql & "                       dbo.SEG_empresa.nomefantazia as fantasia, dbo.SEG_grupo.descricao AS grupo, dbo.SEG_empresa.codGrupo as codigo_SEG_grupo"
			sql = sql & " FROM         dbo.SEG_empresa INNER JOIN"
			sql = sql & "                       dbo.SEG_perfil INNER JOIN"
			sql = sql & "                       dbo.SEG_usuarios_acesso ON dbo.SEG_perfil.codigo = dbo.SEG_usuarios_acesso.codigo_SEG_perfil ON "
			sql = sql & "                       dbo.SEG_empresa.codigo = dbo.SEG_usuarios_acesso.codEmpresa INNER JOIN"
			sql = sql & "                       dbo.SEG_grupo ON dbo.SEG_empresa.codGrupo = dbo.SEG_grupo.codigo"
			sql = sql & " WHERE     (dbo.SEG_usuarios_acesso.cpf_SEG_usuarios = " & formataCpfBD(strCPF) & ")"
			if session("strUsuarioMaster") = "NAO" then
				sql = sql & " and SEG_grupo.codigo in (" & session("intCodGrupos") & ")"
			elseif session("strUsuarioMaster") = "SIM" then
			else
				sql = sql & " where SEG_grupo.codigo = 0"
			end if	
			sql = sql & " ORDER BY dbo.SEG_grupo.descricao, dbo.SEG_perfil.descricao"
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
					intGrupo = "0"
                    while not rs.eof
						
                         if intGrupo <> rs("codigo_SEG_grupo") then
						%>
                        <tr>
                          <td colspan="4" align="center" class="celula" bgcolor="#BFDFFF"><strong><%=rs("grupo")%></strong></td>
                        </tr>
                        <%
						end if
						
						%>
                        <tr> 
                            <td align="left" class="celula">&nbsp;<%=rs("perfil")%></td>
                            <td align="left" class="celula">&nbsp;<%=rs("fantasia")%></td>
                        </tr>
                        <%
						intGrupo = rs("codigo_SEG_grupo") 
                        rs.movenext
                    wend
                rs.close
                %>
            </table> 
			<%
            end if
       	end if     
		%>         </td>
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