<%strNomeDaPaginaPortal = "Cadastro de Perfil"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="js/Seg_Perfil_cad.js"></script>
<script src="../../../js/js_funcoes_gerais.js"></script>
   
    <!-- inicio do codigo asp da pagina -->
<%  
	set rs1  = Server.CreateObject("adodb.recordset")
	intCodPerfil		= request.form("txtCodigo")
	intCodTipoAcesso	= request.form("cmbCodTipoAcesso")
	mostrarBotaoPrincipal = "N"
	intCodGrupo				= Trim(Request.form("cmbGrupo"))
	if intCodGrupo = "" then intCodGrupo = "0"	
	intCodEmpresa			= Trim(Request.form("cmbCodEmpresa"))
	if intCodEmpresa = "" then intCodEmpresa = "0"	
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
    
   	<!-- inicio do formulario da pagina-->
    <form id="frm" name="frm" action="seg_perfil_cad.asp" method="post">
    <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodPerfil%>">
    <table width="98%" border="0">
		<tr>
		  <td width="157" class="TextoForm">Descri&ccedil;&atilde;o do Perfil</td>
		  <td width="1032"><input name="txtDescricao" type="text" class="caixaTexto" id="txtDescricao" size="70" maxlength="50" value="<%=strDescricao%>"></td>
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
			sql = "Select SEG_grupo.descricao as grupo, SEG_empresa.codGrupo as codigo_SEG_grupo, SEG_perfil.codigo, SEG_perfil.descricao, SEG_tipo_acesso.descricao as tipoAcesso, SEG_empresa.nomefantazia as empresa"
			sql = sql & " FROM SEG_perfil"
			sql = sql & " INNER JOIN SEG_tipo_acesso ON SEG_tipo_acesso.codigo = SEG_perfil.codigo_SEG_tipo_acesso"
			sql = sql & " INNER JOIN SEG_empresa ON SEG_empresa.codigo = SEG_perfil.codEmpresa"
			sql = sql & " inner join SEG_grupo ON SEG_grupo.codigo = SEG_empresa.codGrupo "
			if session("strUsuarioMaster") = "NAO" then
				sql = sql & " where SEG_grupo.codigo in (" & session("intCodGrupos") & ")"
			elseif session("strUsuarioMaster") = "SIM" then
				sql = sql & " where 1=1" 'terá acesso a todos os grupos
			else
				'sql = sql & " where SEG_grupo.codigo = 0"
			end if	
			'response.Write(sql)
			sql = sql & " order by SEG_grupo.descricao, SEG_perfil.descricao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
			<br>
			<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr class="CabecalhoConsulta"> 
                        <td width="5%" class="celula"><div align="center">Cód.</div></td>
                    <td width="20%"class="celula">Perfil</td>
                    <td width="30%"class="celula">Tipo Acesso</td>
                    <td width="40%"class="celula">Empresa</td>
              </tr>
                    <%
                    cont = 0
					intGrupo = "0"
                    while not rs.eof
                        cont = cont + 1
                        if intGrupo <> rs("codigo_SEG_grupo") then
						%>
                        <tr>
                          <td colspan="4" align="center" class="celula" bgcolor="#BFDFFF"><strong><%=rs("grupo")%></strong></td>
                        </tr>
                        <%
						end if
						%>
                        <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return selPerfil('<%=rs("codigo")%>')"> 
                            <td class="celula" align="center"><%=rs("codigo")%></td>
                            <td align="center" class="celula"><div align="left">&nbsp;<%=rs("Descricao")%></div></td>
                            <td align="center" class="celula"><div align="left">&nbsp;<%=rs("tipoAcesso")%></div></td>
                            <td class="celula"><%=rs("empresa")%></td>
                        </tr>
                  <%
				  		intGrupo = rs("codigo_SEG_grupo") 
                        rs.movenext
                    wend
                rs.close
                %>
                    <tr> 
                    <td class="celula" colspan="4">Total de itens: <%=cont%>&nbsp;</td>
                </tr>
            </table> 
			<%
            end if
            %>

   	<!-- fim do formulario da pagina -->
    <input name="txtHiddenContador" type="hidden" value="<%=cont%>">
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
