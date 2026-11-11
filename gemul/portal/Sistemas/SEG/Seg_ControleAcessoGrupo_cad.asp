<%strNomeDaPaginaPortal = "Acesso por Grupo"%>
<!--#include file="topo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../../includes/inc_Mascaras.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/Seg_ControleAcessoGrupo_cad.js"></script>

<%  
'codigo fonte em ASP
	mostrarBotaoPrincipal 		= "N"
	StrReloadPerfilMenu			= "S"
	StrReloadGrupo				= "S"
	strCPF						= Trim(Request("txtCPF"))
	intCodGrupo			= Trim(Request.form("cmbGrupo"))
	if intCodGrupo 		= "" then intCodGrupo = "0"

	if intCodEmpresa = "" then intCodEmpresa = "0"
	
	
	intCodPerfil 				= request.Form("cmbCodPerfilMenu")
	if intCodPerfil 			= "" then intCodPerfil = "0"
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
            	alert("Usuário não foi encontrado.");
            </script>
			<%
		end if
		rs.close
		
		if intCodPerfil<>"0" and trim(intCodGrupo) <> "0" and trim(strCPF)<>"" then
			sql = "select cpf_SEG_usuarios FROM SEG_usuarios_acesso"
			sql = sql & " Where cpf_SEG_usuarios 	= " & formataCpfBD(strCPF)
			sql = sql & " And codigo_SEG_perfil 	= " & intCodPerfil
			sql = sql & " And codigo_seg_grupo		 	= " & intCodGrupo
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
		
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">
    
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
    <td><!--#include file="../../includes/inc_cmbGrupo.asp"--></td>
  </tr>
  <%
  if intCodGrupo <> "0" then
	  	strCodEmpresas = ""
		sql = "select codigo FROM SEG_empresa"
		sql = sql & " Where codigo_SEG_grupo 	= " & intCodGrupo
		rs.open sql, cnn ',3,3
		if not rs.eof then		
			while not rs.eof
				if strCodEmpresas = "" then
					strCodEmpresas = rs("codigo")
				else
					strCodEmpresas = strCodEmpresas & "," & rs("codigo")
				end if
				rs.movenext
			wend
		end if
		rs.close	
  end if
  
  %>
  <tr>
    <td width="71" class="TextoForm">Perfil</td>
    <td width="480"><!--#include file="../../includes/inc_cmbPerfilMenu.asp"--></td>
  </tr>
  <tr>
    <td colspan="2" valign="top"> <hr size="1" color="#CCCCCC"></td>
    </tr>
  <td colspan="2">
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td><!--#include file="../../includes/inc_botoes_cadastro.asp"-->      </td>
    </tr>
  </table>   
  
		<%	
		if trim(strCPF) <> "" then
			' Seleciona todos os grupos cadastrados
			sql = "SELECT SEG_usuarios_acesso.codigo_SEG_perfil, SEG_perfil.descricao, SEG_grupo.codigo as codGrupo, SEG_grupo.descricao as grupo"
			sql = sql & " FROM SEG_grupo INNER JOIN (SEG_perfil INNER JOIN SEG_usuarios_acesso ON SEG_perfil.codigo = SEG_usuarios_acesso.codigo_SEG_perfil) ON SEG_grupo.codigo = SEG_usuarios_acesso.codigo_seg_grupo"
			sql = sql & " where SEG_usuarios_acesso.cpf_SEG_usuarios = " & formataCpfBD(strCPF)
			sql = sql & " order by SEG_perfil.descricao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
			<br>
			<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr class="CabecalhoConsulta"> 
                        <td width="12%" class="celula"><div align="center">Perfil</div></td>
                    <td width="28%"class="celula">Descrição do Perfil</td>
                  <td width="60%"class="celula">Acessos</td>
              </tr>
                    <%
                    while not rs.eof
                        %>
                        <tr > 
                            <td class="celula" align="center"><%=rs("codigo_SEG_perfil")%></td>
                            <td align="left" class="celula">&nbsp;<%=rs("Descricao")%></td>
                            <td align="left" class="celula">&nbsp;<%=rs("grupo")%></td>
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
			%>  </td>
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