<%strNomeDaPaginaPortal = "Cadastro de SubGrupo"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.cmbGrupoProduto.value == "0") {
			alert("Grupo deve ser informado!");
			frm.cmbGrupoProduto.focus();
			return false;
		}
		
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="SubGrupoProduto_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	strEmpresaSecaoProduto_submit = "S"
	principal			= "principal.asp"
	strOnChangeGrupo	= "S" 
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	intCodGrupoProduto	= Trim(Request("cmbGrupoProduto"))
	intCodEmpresa		= session("CodEmpresa")
	strSituacao	 		= Trim(Request.Form("cmbSituacao"))
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")

	if trim(intCodigo) <> "" then
	
		sql = "SELECT S.CODIGO, S.DESCRICAO,S.Situacao,S.COD_GRUPO_PRODUTO"
		sql = sql & " FROM EST_SUBGRUPO_PRODUTO S"
		sql = sql & " inner join EST_GRUPO_PRODUTO G on G.codigo = S.COD_GRUPO_PRODUTO"
		sql = sql & " Where S.Codigo = " & intCodigo
		sql = sql & " and G.cod_secao = " & intSecaoProduto
		sql = sql & " and G.cod_empresa = " & intCodEmpresa

		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strDescricao		= rs("Descricao")
			intCodGrupoProduto	= rs("COD_GRUPO_PRODUTO")	
			strSituacao			= rs("Situacao")
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoPDF   				= "disabled"
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
    <form id="frm" name="frm" action="subGrupoProduto_cad.asp" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td height="23" class="TextoForm"><span class="texto1">Se&ccedil;&atilde;o:</span></td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbSecaoProduto.asp" --></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Grupo:</td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbGrupoProduto.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Descri&ccedil;&atilde;o:
              <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
            <td class="TextoForm"><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td width="16%" height="23" class="TextoForm">Situa&ccedil;&atilde;o:</td>
            <td width="25" class="TextoForm">
            <select name="cmbSituacao" class="Combo" id="cmbSituacao">
                <option value="0">Selecione...</option>
                <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
            </select>
            </td>
            </tr>
          <tr>
            <td height="24" colspan="2" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="2"><%
				cont =0
					if intCodGrupoProduto = "" then intCodGrupoProduto = "0"
					sql = "SELECT S.Codigo,  S.Descricao, S.Situacao"
					sql = sql & " FROM EST_SUBGRUPO_PRODUTO S"
					sql = sql & " inner join EST_GRUPO_PRODUTO G on G.codigo = S.COD_GRUPO_PRODUTO"
					sql = sql & " where  G.cod_secao = " & intSecaoProduto
					sql = sql & " and G.cod_empresa = " & intCodEmpresa

					sql = sql & " Order by Descricao"
					rs.open sql, cnn
									
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="89%" height="21" class="celula"><strong>Descricao</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                            <td width="11%" class="celula"><%=rs("Codigo")%></td>
                            <td height="21" class="celula"><%=trim(rs("Descricao"))%></td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
              <tr>
                <td height="21" colspan="2" class="celula">Total 
                  Registros : <%=cont%></td>
              </table>
            <%
			  end if
			  rs.close%></td>
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