<%strNomeDaPaginaPortal = "Cadastro de Modulos"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/Seg_modulo_cad.js"></script>
<%  
'codigo fonte em ASP
	intCodigo		= request.form("txtCodigo")
	intCodSistema	= request.form("cmbCodSistema")
	mostrarBotaoPrincipal = "N"

	if trim(intCodigo) <> "" then
		sql = "SELECT descricao, sigla, codigo_Seg_sistema "
		sql = sql & " from SEG_modulo "
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			strDescricao 			= rs("descricao")
			strSigla 				= rs("sigla")
			intCodSistema 			= rs("codigo_Seg_sistema")

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

<table width="100%" border="0">
		<tr>
		  <td width="94" class="TextoForm">Descri&ccedil;&atilde;o</td>
		  <td width="471"><input name="txtDescricao" type="text" class="caixaTexto" id="txtDescricao" size="70" maxlength="50" value="<%=strDescricao%>" onKeyPress="return formataCampo(this,1,50)"></td>
		  </tr>
		<tr>
		  <td class="TextoForm">Sistema</td>
		  <td><!--#include file="../../../includes/inc_cmbSistema.asp"--></td>
		  </tr>
		<tr>
		  <td class="TextoForm">Sigla</td>
		  <td><input name="txtSigla" type="text" class="caixaTexto" id="txtSigla" size="6" maxlength="5" value="<%=strSigla%>" onKeyPress="return formataCampo(this,1,5)"></td>
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
			sql = "Select SEG_modulo.codigo, SEG_modulo.descricao, SEG_modulo.sigla, SEG_sistema.descricao as sistema"
			sql = sql & " FROM SEG_modulo"
			sql = sql & " INNER JOIN SEG_sistema ON SEG_sistema.codigo = SEG_modulo.codigo_seg_sistema"
			sql = sql & " order by SEG_sistema.descricao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
			<br>
			<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr bgcolor="#CCCCCC" class="CabecalhoConsulta"> 
                  <td width="5%" class="celula"><div align="center">Cód.</div></td>
                    <td width="20%"class="celula">Descri&ccedil;&atilde;o</td>
                    <td width="40%"class="celula">Sistema</td>
                    <td width="20%"class="celula">Sigla</td>
              </tr>
                    <%
                    cont = 0
                    while not rs.eof
                        cont = cont + 1
                        %>
                        <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return selPerfil('<%=rs("codigo")%>')"> 
                            <td class="celula" align="center"><%=rs("codigo")%></td>
                            <td align="center" class="celula"><div align="left">&nbsp;<%=rs("Descricao")%></div></td>
                            <td class="celula"><%=rs("sistema")%></td>
                            <td class="celula"><%=rs("sigla")%></td>
                        </tr>
                  <%
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