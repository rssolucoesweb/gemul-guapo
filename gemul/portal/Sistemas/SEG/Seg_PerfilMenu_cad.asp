<%SESSION.Timeout = 1200%>
<%Server.ScriptTimeOut = 60%>
<%strNomeDaPaginaPortal = "Perfil do Menu"%>
<link type="text/css" rel="stylesheet" href="css/treeView.css">
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="js/Seg_PerfilMenu_cad.js"></script>
<script type="text/javascript" src="js/jquery.treeview.js"></script>
<script type="text/javascript" src="js/treeview.js"></script>
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

<table width="98%" align="center" class="formulario">
<tr>
<td>
<br>
<%
	StrReloadPerfilMenu	= "S"
	StrReloadEmpresa	= "S"
	StrReloadGrupo		= "S"
	mostrarBotaoPrincipal = "N"

	intCodEmpresa 	= request.Form("cmbCodEmpresa")
	if intCodEmpresa = "" then intCodEmpresa = 0
	intCodGrupo				= Trim(Request.form("cmbGrupo"))
	if intCodGrupo = "" then intCodGrupo = "0"
	intCodPerfil 	= request.Form("cmbCodPerfilMenu")
	if intCodPerfil = "" then intCodPerfil = 0
%>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
  <tr>
    <td class="TextoForm"><strong>Grupo</strong></td>
    <td colspan="2"><!--#include file="../../../includes/inc_cmbGrupo.asp"--></td>
  </tr>
  <tr>
    <td class="TextoForm"><strong>Unidade</strong></td>
    <td colspan="2"><!--#include file="../../../includes/inc_cmbEmpresa.asp"--></td>
  </tr>
  <tr>
    <td width="63" class="TextoForm"><strong>Perfil</strong></td>
    <td colspan="2"><input name="txtHiddenCodUnidadeEnsino" id="txtHiddenCodUnidadeEnsino" type="hidden" size="10" maxlength="8" class="caixaTexto" value="<%=intCodSiaOrigem%>">
      <!--#include file="../../../includes/inc_cmbPerfilMenu.asp"--></td>
  </tr>
<% if trim(intCodPerfil) <> "0" then%>
  <tr>
    <td height="40" class="TextoForm"><strong>Menu</strong></td>
    <td width="221" height="40" bgcolor="#CCCCCC" class="TextoForm">
      	<a title="Desmarcar Todos" href="#" onClick="return Marcar('N')"><br>
      	Desmarcar todos</a> | <a title="Selecionar Todos" href="#" onClick="return Marcar('S')">Marcar todos&nbsp;&nbsp;</a>&nbsp;&nbsp;| <div id="treecontrol"> <a title="Recolher Todos" href="#">Recolher todos</a> &nbsp;&nbsp;&nbsp;| <a title="Expandir Todos" href="#">Expandir todos</a> | </div></td>
    <td width="565" class="TextoForm">&nbsp;</td>
  </tr>
<%end if%>  
  <tr>
    <td colspan="3" valign="top" class="TextoForm">

<%  
	
strDesabilitaIncluir 	= "" 			' Habilita o botão Incluir
strDesabilitaAlterar 	= "disabled" 	' Desabilita o botão Alterar
strDesabilitaExcluir 	= "disabled" 	' Desabilita o botão Excluir
strDesabilitaLimpar  	= "" 					
				
intCodUsuario 			= Trim(request.Form("cmbUsuario"))		
'MONTA menu imob
dim codigo

function menu(codigo)
	
	set rs1 = server.CreateObject("adodb.recordset")  
	
	sql="select codigo, descricao, link, imagem, script "
	sql=sql & " from SEG_menu where codigo_SEG_menu=" & codigo
	if session("strUsuarioMaster") = "NAO" then
		sql = sql & " and codigo not in (6,7,8,11)"
	end if	
	sql=sql & " order by ordem, codigo"
	vetMenu = null
	rs1.open sql, cnn
	if not rs1.eof then
		vetMenu = rs1.getRows
	end if
	rs1.close
		
	if isArray(vetMenu) then
		if codigo <> 1 then
			response.write "<ul>" & vbcrlf
		end if	
		controle = 0
		'while not rs.eof
		for i=0 to ubound(vetMenu,2)

			codigoRSMenu  	= vetMenu(0,i)  'rsMenuImob("codigo")
			descricaoRSMenu	= vetMenu(1,i)  'rsMenuImob("descricao")
			
			if codigoRSMenu > codigo then
				strMarcado = ""
				if intCodPerfilMenu <> "0" then
					'consulta e verifica se o menu já foi incluido para o perfil selecionado
					sql = "select codigo_SEG_perfil from SEG_perfil_menu"
					sql = sql & " where codigo_SEG_perfil = " & intCodPerfil
					sql = sql & " and codigo_SEG_menu = " & codigoRSMenu
					rsaux.open sql, cnn 
					if not rsaux.eof then
						strMarcado = "checked"
						strDesabilitaIncluir 	= "disabled" 			' Habilita o botão Incluir
						strDesabilitaAlterar 	= "" 	' Desabilita o botão Alterar
						strDesabilitaExcluir 	= "disabled" 	' Desabilita o botão Excluir
						strDesabilitaLimpar  	= "" 					
						
					end if
					rsaux.close
				end if
				%>
				<li><input <%=strMarcado%> type="checkbox" id="chkMenu" name="chkMenu" value="<%=codigoRSMenu%>"><%=codigoRSMenu%> - <%=descricaoRSMenu%><span>&nbsp;</span>
				<%
				menu(codigoRSMenu)
				%>	
				</li>
				<%
			end if
		next
		'wend
		%>
		</ul>
        <%
	end if
	vetMenu = null
	'rs1.close	
end function
if trim(intCodPerfil) <> "0" then
	intCodigomenu = 1
	response.write "<ul id='red' class='treeview-red'>" & vbcrlf
	menu(intCodigomenu)
	response.write "</ul>" & vbcrlf
end if
%></td>
    </tr>
  <tr>
    <td colspan="3" valign="top"> <hr size="1" color="#CCCCCC"></td>
    </tr>
  <td colspan="3">
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->      </td>
    </tr>
  </table>   </td>
  </tr>
</table>


</td>
</tr>
</table>
<input name="txtHiddenContador" type="hidden" value="<%=cont%>">
<input name="txtSelecionado" type="hidden" value="false">
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