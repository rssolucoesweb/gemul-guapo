<%strNomeDaPaginaPortal = "Cadastro de Sistemas"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/Seg_Sistema_cad.js"></script>
<%  
'codigo fonte em ASP
	set rs1  = Server.CreateObject("adodb.recordset")
	intCodigo		= request.form("txtCodigo")
	intCodEmpresa		= request.form("cmbCodEmpresa")
	mostrarBotaoPrincipal = "N"

	if trim(intCodigo) <> "" then
		sql = "SELECT descricao "
		sql = sql & " from SEG_sistema "
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			strDescricao 			= rs("descricao")

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
    <form id="frm" name="frm" action="#" method="post">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">

    <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
   	<!-- inicio do formulario da pagina-->

         <table width="100%" border="0">
           <tr>
             <td width="75" class="TextoForm">Descri&ccedil;&atilde;o</td>
             <td width="1235"><input name="txtDescricao" type="text" class="texto id="txtDescricao" size="70" maxlength="50" value="<%=strDescricao%>" onKeyPress="return formataCampo(this,1,50)"></td>
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
			sql = "Select SEG_sistema.codigo, SEG_sistema.descricao"
			sql = sql & " FROM SEG_sistema"
			sql = sql & " order by SEG_sistema.descricao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
         <br>
         <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
           <tr class="CabecalhoConsulta">
             <td width="14%" class="celula"><div align="center">C&oacute;d.</div></td>
             <td width="86%"class="celula">Descri&ccedil;&atilde;o</td>
           </tr>
           <%
                    cont = 0
                    while not rs.eof
                        cont = cont + 1
                        %>
           <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return selSistema('<%=rs("codigo")%>')">
             <td class="celula" align="center"><%=rs("codigo")%></td>
             <td align="center" class="celula"><div align="left">&nbsp;<%=rs("Descricao")%></div></td>
           </tr>
           <%
                        rs.movenext
                    wend
                rs.close
                %>
           <tr>
             <td class="celula" colspan="2">Total de itens: <%=cont%>&nbsp;</td>
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