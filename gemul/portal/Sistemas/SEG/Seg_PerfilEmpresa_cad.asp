<%strNomeDaPaginaPortal = "Cadastro de Perfil"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/Seg_PerfilEmpresa_cad.js"></script>
<%  
'codigo fonte em ASP
set rs1  = Server.CreateObject("adodb.recordset")
intCodPerfil		= request.form("txtCodigo")
intCodTipoAcesso	= request.form("cmbCodTipoAcesso")
mostrarBotaoPrincipal = "N"
intCodEmpresa			= session("codEmpresa")
strDescricao			= Trim(Request.form("txtDescricao"))

if trim(intCodPerfil) <> "" then
	sql = "SELECT perf.descricao, perf.codigo_SEG_tipo_acesso, perf.codEmpresa, emp.codGrupo as codigo_SEG_grupo "
	sql = sql & " from SEG_perfil perf "
	sql = sql & " inner join SEG_EMPRESA emp on perf.codEmpresa = emp.codigo"
	sql = sql & " inner join SEG_grupo G ON G.codigo = emp.codGrupo "
	sql = sql & " where perf.codigo = " & intCodPerfil
	rs.open sql, cnn
	if rs.eof = false then
		strDescricao 			= rs("descricao")
		intCodTipoAcesso 		= rs("codigo_SEG_tipo_acesso")
		intCodEmpresa 			= rs("codEmpresa")
		intCodGrupo				= rs("codigo_SEG_grupo")

		strDesabilitaIncluir 	= "disabled"
		strDesabilitaExcluir 	= ""
		strDesabilitaAlterar 	= ""
		strDesabilitaLimpar 	= "disabled"
	else
		strDesabilitaIncluir 	= ""
		strDesabilitaExcluir 	= "disabled"
		strDesabilitaAlterar 	= "disabled"
		strDesabilitaLimpar 	= ""		
	end if
	rs.close
else
		strDesabilitaIncluir 	= ""
		strDesabilitaExcluir 	= "disabled"
		strDesabilitaAlterar 	= "disabled"
		strDesabilitaLimpar 	= ""		
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
    <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodPerfil%>">
   	<!-- inicio do formulario da pagina-->

        <table width="100%" border="0">
		<tr>
		  <td width="157" class="TextoForm">Descri&ccedil;&atilde;o do Perfil</td>
		  <td width="1032"><input name="txtDescricao" type="text" class="caixaTexto" id="txtDescricao" size="70" maxlength="50" value="<%=strDescricao%>"></td>
		  </tr>
		<tr>
		  <td class="TextoForm">Tipo Acesso</td>
		  <td><!--#include file="../../../includes/inc_cmbTipoAcesso.asp"--></td>
		  </tr>
          <tr> 
          	<td colspan="4"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
          	<td colspan="4"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
        </table>
	<%	
			' Seleciona todos os grupos cadastrados
			sql = "Select SEG_empresa.codGrupo as codigo_SEG_grupo, SEG_perfil.codigo, SEG_perfil.descricao, SEG_tipo_acesso.descricao as tipoAcesso, SEG_empresa.nomefantazia as empresa"
			sql = sql & " FROM SEG_perfil"
			sql = sql & " INNER JOIN SEG_tipo_acesso ON SEG_tipo_acesso.codigo = SEG_perfil.codigo_SEG_tipo_acesso"
			sql = sql & " INNER JOIN SEG_empresa ON SEG_empresa.codigo = SEG_perfil.codEmpresa"
			sql = sql & " where SEG_perfil.codEmpresa = "& intCodEmpresa
			sql = sql & " order by SEG_empresa.nomefantazia, SEG_perfil.descricao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
			<br>
			<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr class="CabecalhoConsulta"> 
                        <td width="4%" class="celula"><div align="center">Cód.</div></td>
                    <td width="68%"class="celula">Perfil</td>
                    <td width="28%"class="celula">Tipo Acesso</td>
              </tr>
                        <tr>
                          <td colspan="3" align="center" class="celula" bgcolor="#CCFFCC"><strong><%=rs("empresa")%></strong></td>
                        </tr>
                    <%
                    cont = 0
					intGrupo = "0"
                    while not rs.eof
                        cont = cont + 1
						%>
                        <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return selPerfil('<%=rs("codigo")%>')"> 
                            <td class="celula" align="center"><%=rs("codigo")%></td>
                            <td align="center" class="celula"><div align="left">&nbsp;<%=rs("Descricao")%></div></td>
                            <td align="center" class="celula"><div align="left">&nbsp;<%=rs("tipoAcesso")%></div></td>
                        </tr>
                  <%
                        rs.movenext
                    wend
                rs.close
                %>
                    <tr> 
                    <td class="celula" colspan="3">Total de itens: <%=cont%>&nbsp;</td>
                </tr>
            </table> 
			<%
            end if
            %>

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