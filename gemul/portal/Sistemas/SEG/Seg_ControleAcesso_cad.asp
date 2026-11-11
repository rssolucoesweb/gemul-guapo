<%strNomeDaPaginaPortal = "Controle de Acesso - Empresa"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<!--#include file="../../../includes/inc_Mascaras.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/Seg_ControleAcesso_cad.js"></script>
<%  
'codigo fonte em ASP
	StrReloadPerfilMenu			= "S"
	mostrarBotaoPrincipal 		= "N"
	strMostraBotaoLimparLocation = "S"
	strPagina = "Seg_ControleAcesso_cad.asp"
	strCPF						= Trim(Request("txtCPF"))
	intCodGrupo				= Trim(Request.form("cmbGrupo"))
	if intCodGrupo = "" then intCodGrupo = "0"
	intCodEmpresa				= Trim(Request.form("cmbCodEmpresa"))
	if intCodEmpresa = "" then intCodEmpresa = "0"
	intCodPerfil 				= request.Form("cmbCodPerfilMenu")
	if intCodPerfil = "" then intCodPerfil = "0"
	strNome						= ""
	strDesabilitaIncluir 		= "disabled" 	' Habilita o botão Incluir
	strDesabilitaAlterar 		= "disabled" 	' Desabilita o botão Alterar
	strDesabilitaExcluir 		= "disabled" 	' Desabilita o botão Excluir
	strDesabilitaLimpar  		= "" 	
	
	if trim(strCPF)<>"" then
		'valida dados do servidor
		sql = "select nome FROM SEG_usuarios"
		sql = sql & " Where cpf = " & formataCpfBD(strCPF)
		rs.open sql, cnn ',3,3
		if not rs.eof then		
			strNome = rs("nome")
		else
			strCPF 	= ""
			strNome	= ""
			%>
			<script>
            	alert("O usuário selecionado não está cadastrado como usuário do sistema.\nPara cadastrar um perfil para um usuário é necessário, primeiro, cadastrá-lo como usuário do sistema.");
            </script>
			<%
		end if
		rs.close
		
		if intCodPerfil<>"0" and trim(intCodEmpresa) <> "" and trim(strCPF)<>"" then
			sql = "select cpf_SEG_usuarios FROM SEG_usuarios_acesso"
			sql = sql & " Where cpf_SEG_usuarios 	= " & formataCpfBD(strCPF)
			sql = sql & " And codigo_SEG_perfil 	= " & intCodPerfil
			sql = sql & " And codEmpresa = " & intCodEmpresa
			rs.open sql, cnn ',3,3
			if not rs.eof then		
				strDesabilitaIncluir 	= "disabled" 	' Habilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 	' Desabilita o botão Alterar
				strDesabilitaExcluir 	= "" 	' Desabilita o botão Excluir
				strDesabilitaLimpar  	= "" 	
			else
				strDesabilitaIncluir 	= "" 	' Habilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 	' Desabilita o botão Alterar
				strDesabilitaExcluir 	= "disabled" 	' Desabilita o botão Excluir
				strDesabilitaLimpar  	= "" 	
			end if
			rs.close
		end if
	end if
	StrReloadEmpresa	= "S"
	StrReloadGrupo		= "S"
		
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
    <td class="TextoForm">CPF</td>
    <td class="TextoForm"><input name="txtCPF" type="text" class="caixaTexto" id="txtCPF" onBlur="validaCPF(this); return reload()" onKeyPress="return formataCampo(this, 5, 14)" value="<%=formataCpfAP(strCPF)%>" size="15" maxlength="14">
        <a href="#" onClick="return abreConsulta('Seg_UsuarioAutorizacao_con.asp')"> <img src="../../../images/Consulta_normal.gif" alt="" name="Consulta" width="26" height="26" border="0" align="absmiddle"></a>&nbsp;&nbsp;<strong><%=strNome%></strong></td>
  </tr>
  <tr>
    <td class="TextoForm">Grupo</td>
    <td><!--#include file="../../../includes/inc_cmbGrupo.asp"--></td>
  </tr>
  <tr>
    <td class="TextoForm">Unidade</td>
    <td><!--#include file="../../../includes/inc_cmbEmpresa.asp"--></td>
  </tr>
  <tr>
    <td width="90" class="TextoForm">Perfil</td>
    <td width="469"><!--#include file="../../../includes/inc_cmbPerfilMenu.asp"--></td>
  </tr>
  <tr>
    <td colspan="2" valign="top"> <hr size="1" color="#CCCCCC"></td>
    </tr>
  <td colspan="2">
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->      </td>
    </tr>
  </table>   
  
		<%	
		if trim(strCPF) <> "" then
			' Seleciona todos os grupos cadastrados
			
			sql = "SELECT     dbo.SEG_usuarios_acesso.codigo_SEG_perfil, dbo.SEG_perfil.descricao, dbo.SEG_empresa.codigo AS codEmp, "
			sql = sql & "                       dbo.SEG_empresa.nomeFantazia as fantasia, dbo.SEG_grupo.descricao AS grupo, dbo.SEG_empresa.codGrupo"
			sql = sql & " FROM         dbo.SEG_empresa INNER JOIN"
			sql = sql & "                       dbo.SEG_perfil INNER JOIN"
			sql = sql & "                       dbo.SEG_usuarios_acesso ON dbo.SEG_perfil.codigo = dbo.SEG_usuarios_acesso.codigo_SEG_perfil ON "
			sql = sql & "                       dbo.SEG_empresa.codigo = dbo.SEG_usuarios_acesso.codEmpresa INNER JOIN"
			sql = sql & "                       dbo.SEG_grupo ON dbo.SEG_empresa.codGrupo = dbo.SEG_grupo.codigo"
			sql = sql & " WHERE     (dbo.SEG_usuarios_acesso.cpf_SEG_usuarios = " & formataCpfBD(strCPF) & ")"
			if session("strUsuarioMaster") = "" then
				sql = sql & " and SEG_grupo.codigo in (" & session("CodGrupo") & ")"
			end if	
			sql = sql & " ORDER BY dbo.SEG_grupo.descricao, dbo.SEG_perfil.descricao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
			<br>
			<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr class="CabecalhoConsulta"> 
                        <td width="12%" class="celula"><div align="center">Perfil</div></td>
                    <td width="28%"class="celula">Descrição do Perfil</td>
                  <td width="60%"class="celula">Unidade</td>
              </tr>
                    <%
                    while not rs.eof
                         if intGrupo <> rs("codGrupo") then
						%>
                        <tr>
                          <td colspan="4" align="center" class="celula" bgcolor="#BFDFFF"><strong><%=rs("grupo")%></strong></td>
                        </tr>
                        <%
						end if
						%>
                        <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return selPerfil('<%=rs("codigo_SEG_perfil")%>','<%=rs("codEmp")%>','<%=rs("codGrupo")%>')"> 
                            <td class="celula" align="center"><%=rs("codigo_SEG_perfil")%></td>
                            <td align="left" class="celula">&nbsp;<%=rs("Descricao")%></td>
                            <td align="left" class="celula">&nbsp;<%=rs("codEmp")%> - <%=rs("fantasia")%></td>
                        </tr>
                        <%
						intGrupo = rs("codGrupo") 
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
        <hr size="1" color="#FFFFFF">
 
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>