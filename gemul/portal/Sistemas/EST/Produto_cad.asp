<%strNomeDaPaginaPortal = "Cadastro de Produto"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	function carregaGrupo(){
		frm.action = "Produto_cad.asp?gp=s";
		frm.submit();
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		if (frm.cmbSecaoProduto.value == "0") {
			alert("Seção deve ser informada!");
			frm.cmbSecaoProduto.focus();
			return false;
		}

		if (frm.txtDescricaoProduto.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricaoProduto.focus();
			return false;
		}
		if (frm.cmbUnidadeProduto.value == "0") {
			alert("A Unidade deve ser informada !");
			frm.cmbUnidadeProduto.focus();
			return false;
		}
/*		if (frm.cmbGrupoProduto.value == "0") {
			alert("A grupo deve ser informado!");
			frm.cmbGrupoProduto.focus();
			return false;
		}
		if (frm.cmbSubGrupoProduto.value == "0") {
			alert("A subgrupo deve ser informado!");
			frm.cmbSubGrupoProduto.focus();
			return false;
		}*/
		if (frm.txtEstMinimo.value == "") {
			alert("Estoque mínimo deve ser informado!");
			frm.txtEstMinimo.focus();
			return false;
		}
		if (frm.txtEstMaximo.value == "") {
			alert("Estoque máximo deve ser informad!");
			frm.txtEstMaximo.focus();
			return false;
		}
		
		
		frm.action="Produto_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	strTombamentoSim = ""
	strTombamentoNao = " checked "
	principal			= "principal.asp"
	strOnChangeGrupo	= "S" 
	strEmpresaSecaoProduto_submit = "S"
	intCodigo 			= Trim(Request("txtCodigo"))
	strDescricaoProduto			= Trim(Request.Form("txtDescricaoProduto"))
	intUnidadeProduto			= Trim(Request.Form("cmbUnidadeProduto"))
	intCodGrupoProduto			= Trim(Request.Form("cmbGrupoProduto")) 
	intCodSubGrupoProduto		= Trim(Request.Form("cmbSubGrupoProduto")) 
	intEstMinimo		 		= Trim(Request.Form("txtEstMinimo"))
	intEstMaximo		 		= Trim(Request.Form("txtEstMaximo"))
	strQtdAtualEst		 		= Trim(Request.Form("txtQtdAtualEst"))
	strPrecoCusto		 		= Trim(Request.Form("txtPrecoCusto"))
	strMargemLucro		 		= Trim(Request.Form("txtMargemLucro"))
	strPrecoVenda		 		= Trim(Request.Form("txtPrecoVenda"))
	intSecaoProduto				= Trim(Request("cmbSecaoProduto"))
	strReferProduto		 		= Trim(Request.Form("txtReferProduto"))
	intEAN				 		= Trim(Request.Form("txtEAN"))
	intCodMArca		 			= Trim(Request.Form("cmbMarcaProduto"))
	strObsProduto		 		= Trim(Request.Form("txtObsProduto"))
	strSituacao	 				= Trim(Request.Form("cmbSituacao"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	strAcessoProdutoAdm			= "S" 
	if trim(intCodigo) <> "" then
	
		sql = " SELECT  _p.CODIGO, _p.DESCRICAO, _ga.acesso, _p.tipoAcesso, COD_MARCA, COD_UNIDADE,isnull(_p.COD_SUBGRUPO,0) as COD_SUBGRUPO, isnull(_g.COD_GRUPO_produto,0) as COD_GRUPO_produto, ESTOQUE_MINIMO, ESTOQUE_MAXIMO, QTD_ATUAL_ESTOQUE, PRECO_CUSTO, MARGEM_LUCRO, PRECO_VENDA, COD_SECAO, REFERENCIA, CODG_BARRAS, OBSERVACAO, _p.tombamento "
		sql = sql & "  FROM EST_PRODUTO _p "
		sql = sql & " left join EST_SUBGRUPO_PRODUTO _g on _g.codigo = _p.COD_SUBGRUPO"
		sql = sql & " left join EST_PRODUTO_ACESSO _ga on _ga.cod_produto =  _p.CODIGO"
		sql = sql & " WHERE _p.CODIGO = " & intCodigo
		sql = sql & " and _p.cod_secao = " & intSecaoProduto
		rs.open sql, cnn
		
		if rs.eof = false then
			strDescricaoProduto		    = rs("DESCRICAO")	
			strAcessoProduto		    = rs("tipoAcesso")	
			strTombamento			    = rs("tombamento")			
			if strTombamento = "S" then 
				strTombamentoSim = " checked "
				strTombamentoNao = ""
			else
				strTombamentoSim = ""
				strTombamentoNao = " checked "
			end if
			
			intUnidadeProduto		= rs("COD_UNIDADE")
			if request("gp") = "" then
				intCodGrupoProduto			= rs("COD_GRUPO_produto")
				intCodSubGrupoProduto			= rs("COD_SUBGRUPO")
			end if
			
			intEstMinimo				= rs("ESTOQUE_MINIMO")
			intEstMaximo				= rs("ESTOQUE_MAXIMO")
			strQtdAtualEst				= rs("QTD_ATUAL_ESTOQUE")
			strPrecoCusto				= formatNumber(rs("PRECO_CUSTO"),2)
				
			strMargemLucro				= formatNumber(rs("MARGEM_LUCRO"),2)
			strPrecoVenda				= formatNumber(rs("PRECO_VENDA"),2)
			
			if Trim(Request.Form("cmbSecaoProduto")) = "0" or Trim(Request.Form("cmbSecaoProduto")) = "" then
				intSecaoProduto			= rs("COD_SECAO")
			end if
			
			strReferProduto				= rs("REFERENCIA")
			intEAN						= rs("CODG_BARRAS")
			
			if Trim(Request.Form("cmbMarcaProduto")) = "0" or Trim(Request.Form("cmbMarcaProduto")) = "" then
				intCodMarca			= rs("COD_MARCA")
			end if
			strObsProduto				= rs("OBSERVACAO")
			
			strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 		= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "" 'Desabilita o botão Excluir

			strAcessoProdutoAdm			= "S" 
			strAcessoProdutoUE			= "" 
			strAcessoProdutoCMEIS		= ""
			strAcessoProdutoEMEI		= ""
			
			 
			strAcessoProdutoSec			= ""
			while not rs.eof
				if rs("acesso") = "SECRETARIA" 		then strAcessoProdutoSec	= "S" 
				if rs("acesso") = "ADMINISTRACAO" 	then strAcessoProdutoAdm	= "S" 
				if rs("acesso") = "UNIDADE_ESCOLA" 	then strAcessoProdutoUE		= "S" 
				if rs("acesso") = "CMEIS" 			then strAcessoProdutoCMEIS	= "S" 
				if rs("acesso") = "EMEI" 			then strAcessoProdutoEMEI	= "S" 
				rs.movenext
			wend
			
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
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
    <form id="frm" name="frm" action="Produto_cad.asp" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">Se&ccedil;&atilde;o:</td>
            <td><!--#include file="../../../includes/inc_cmbSecaoProduto.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Descri&ccedil;&atilde;o do Produto:</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              <input name="txtDescricaoProduto" type="text" class="text" id="txtDescricaoProduto" size="60" maxlength="100" value="<%=strDescricaoProduto%>"></td>
          </tr>
          <tr style="display:none">
            <td class="texto1">Marca:</td>
            <td><!--#include file="../../../includes/inc_cmbMarcaProduto.asp"--></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Unidade:</td>
             <td width="707"><!--#include file="../../../includes/inc_cmbUnidadeProduto.asp"--></td>
          </tr>         
          <tr>
            <td height="25" width="162" class="texto1">Grupo:</td>
            <td width="707"><!--#include file="../../../includes/inc_cmbGrupoProduto.asp"-->
            </td>
          </tr>
           <tr>
             <td height="25" class="texto1">SubGrupo:</td>
             <td><!--#include file="../../../includes/inc_cmbSubGrupoProduto.asp"--></td>
           </tr>
          <tr>
            <td height="25" class="texto1">Acesso ao Produto:</td>
            <td>
              	<input name="chkAcessoProduto" type="hidden" value="ADMINISTRACAO"	>
                <input disabled <%if strAcessoProdutoAdm 	= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="ADMINISTRACAO"	>Administra&ccedil;&atilde;o&nbsp;&nbsp;
              	<input <%if strAcessoProdutoSec 	= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="SECRETARIA"		>Secretaria Municipal&nbsp;&nbsp;
            	<input <%if strAcessoProdutoUE 		= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="UNIDADE_ESCOLA"	>Unidade Escolares&nbsp;&nbsp;
            	<input <%if strAcessoProdutoCMEIS 	= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="CMEIS"			>CMEIS          
				<input <%if strAcessoProdutoEMEI 	= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="EMEI"			>EMEI          
            </td>
          </tr>
           <tr>
            <td height="25" width="162" class="texto1">Estoque M&iacute;nimo:</td>
            <td width="707">
            	 <input name="txtEstMinimo" type="text" class="text" id="txtEstMinimo" size="40" maxlength="40" value="<%=intEstMinimo%>"  onKeyPress="return formataCampo(this, 2, 8)">
            </td>
          </tr>
           <tr>
            <td height="25" width="162" class="texto1">Estoque M&aacute;ximo:</td>
           	 <td width="707">
             <input name="txtEstMaximo" type="text" class="text" id="txtEstMaximo" size="40" maxlength="40" value="<%=intEstMaximo%>"  onKeyPress="return formataCampo(this, 2, 8)">
            </td>
          </tr>
           <tr>
            <td width="162" class="texto1">Qtd. Atual em Estoque:</td>
             <td width="707"> 
             <input name="txtQtdAtualEst" type="textDesabilitado" class="text" id="txtQtdAtualEst" size="40" maxlength="40" value="<%=strQtdAtualEst%>" disabled >
            </td>
          </tr>
            <tr style="display:none">
            <td width="162" class="texto1">Pre&ccedil;o de Custo:</td>
            <td width="707" class="texto1">
           	R$&nbsp;<input name="txtPrecoCusto" type="text" class="text" id="txtPrecoCusto" size="20" maxlength="10" value="<%=strPrecoCusto%>"  onKeyPress="return currencyFormat(this,event)">
            </td>
            <%
				' if strPrecoVenda <> "" and strPrecoVenda <> "0" then
            	'	strMargemLucro =  round((((strPrecoVenda - strPrecoCusto) * 100) /strPrecoCusto),4)
				' end if
			%>
          </tr>
            <tr style="display:none">
            <td width="162" class="texto1">Margem de Lucro: </td>
            <td width="707" class="texto1">
            %&nbsp;&nbsp;<input name="txtMargemLucro" type="text" class="text" id="txtMargemLucro" size="20" maxlength="10" value="<%=strMargemLucro%>" onBlur="submit()"  onKeyPress="return currencyFormat(this,event)">
            </td>
            <%		
				if strMargemLucro<>"" and strPrecoCusto<>"" then
				strPrecoVenda = formatNumber(round((((strMargemLucro * strPrecoCusto)/100) + strPrecoCusto),2),2)
				end if
				'end if
			%>
          </tr>
            <tr style="display:none">
            <td width="162" class="texto1">Pre&ccedil;o de Venda:</td>
            <td width="707" class="texto1">
            R$&nbsp;<input name="txtPrecoVenda" type="text" class="text" id="txtPrecoVenda" size="20" maxlength="10" value="<%=strPrecoVenda%>"  onKeyPress="return currencyFormat(this,event)">
            </td>
            
          </tr>
          <tr style="display:none">
            <td width="162" class="texto1">Refer&ecirc;ncia:</td>
            <td width="707">
              <input name="txtReferProduto" type="text" class="text" id="txtReferProduto" size="40" maxlength="40" value="<%=strReferProduto%>">
              </td>
          </tr>
          <tr style="display:none">
            <td width="162" class="texto1">C&oacute;digo de Barras:</td>
            <td width="707">
            <input name="txtEAN" type="text" class="text" id="txtEAN" size="40" maxlength="40" value="<%=intEAN%>">
            </td>
          </tr>
           <tr>
             <td width="162" class="texto1">Observa&ccedil;&otilde;es:</td>
             <td width="707">
               <input name="txtObsProduto" type="text" class="text" id="txtObsProduto" size="40" maxlength="40" value="<%=strObsProduto%>">
               </td>
           </tr>
          <tr>
            <td width="162" height="31" class="texto1">Tombamento:</td>
            <td width="707"><input type="radio" <%=strTombamentoSim%>  name="tombamento" id="tombamento" value="S">
              Sim&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="radio" <%=strTombamentoNao%> name="tombamento" id="tombamento" value="N">
N&atilde;o</td>
          </tr>
          <tr>
            <td height="19" class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			cont =0
			sql = " select _P.CODIGO, _P.DESCRICAO, _P.QTD_ATUAL_ESTOQUE, _g.descricao as grupo, _sg.descricao as subgrupo, _P.PRECO_CUSTO, _P.PRECO_VENDA, _Up.DESCRICAO AS UNIDADE, _S.DESCRICAO AS SECAO "
			sql = sql & " from EST_PRODUTO _P "
			sql = sql & " left join EST_UNIDADE_PRODUTO _up on _up.codigo = _p.COD_UNIDADE"
			sql = sql & " left join EST_SUBGRUPO_PRODUTO _sg on _sg.codigo = _p.COD_SUBGRUPO"
			sql = sql & " left join EST_GRUPO_PRODUTO _g on _g.codigo = _sg.COD_GRUPO_PRODUTO"
			sql = sql & " LEFT JOIN EST_SECAO_PRODUTO _S ON _S.CODIGO = _P.COD_SECAO and _S.COD_EMPRESA = _P.COD_EMPRESA"
			sql = sql & " where _P.COD_EMPRESA = '"& Session("CodEmpresa") &"'"	
			sql = sql & " and _P.COD_SECAO = "& intSecaoProduto
			sql = sql & " Order by _P.DESCRICAO "

			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="5%" align="center" class="celula"><strong>C&oacute;digo</strong></td>
                    <td width="29%" align="center" class="celula"><strong>Descri&ccedil;&atilde;o<span class="TextoForm"></span></strong></td>
                    <td width="6%" align="center" class="celula"><strong>Unidade<span class="TextoForm"></span></strong></td>
                    <td width="13%" align="center" class="celula"><strong>Grupo</strong></td>
                    <td width="9%" align="center" class="celula"><strong>Subgrupo</strong></td>
                    <td width="9%" align="center" class="celula"><strong>Qtd. Estoque Atual<span class="TextoForm"></span></strong></td>
                    </tr>
                  <%
				  
				
				while not rs.eof
					
					cont = cont + 1	
					if (rs("CODIGO")) <> "" then intCod = intCodProduto
					  	 
					%>
                 <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">
                    <td class="celula"><%=rs("CODIGO")%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("DESCRICAO"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("UNIDADE"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("grupo"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("subgrupo"))%>&nbsp;</td> 
                    <td class="celula"><%=trim(rs("QTD_ATUAL_ESTOQUE"))%>&nbsp;</td>
                    </tr>
                  <%	
				  		
					rs.movenext
					
				wend
				  %>
                  <tr>
                    <td height="21" colspan="6" class="celula">Total Registros : <%=cont%></td>
                   
                  </table>
              <%
		   end if
		   rs.close

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