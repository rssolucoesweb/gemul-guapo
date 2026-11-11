<%strNomeDaPaginaPortal = "Entrada de Material"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
function calculaValor(totalItem){
	var frm = window.document.forms[0];
	var valor=0;
	var intValorTotal=0;
	
	//*****verifica se um aluno foi selecionado
	for (var i = 1; i <= totalItem; i++) {
		//verifica todos os checkbox
		if (document.getElementById("txtValor"+i).value!=''){
			valor = document.getElementById("txtValor"+i).value;
			valor = valor.replace('.','');
			valor = valor.replace('.','');
			valor = valor.replace('.','');
			valor = valor.replace(',','.');
			intValorTotal = parseFloat(intValorTotal) + parseFloat(valor);
		}
	}
	var totals;
	totals = "";
	totals = intValorTotal.toFixed(2);
	totals = totals.replace('.',',');

	document.getElementById("txtTotalItens").value = FormataValor(totals);
}
	
function FormataValor(valor){
	var posVirgula;
	var tamnhoValor;
	var i, cont;
	var valorFinal;
	var valorInicial; 
	
	valor = valor.replace(".","");
	valorInicial = valor;
	if (valor == "")
		return false;			
	
	posVirgula = valor.indexOf(",");
	tamanhoValor = valor.length;
	
	if (posVirgula == -1){
		valor = valor + ",00";
	}
	else {
		
		if (parseInt(tamanhoValor) - parseInt(posVirgula) ==2){
			valor = valor + "0"
		}
	}
	cont=0;
	valorFinal = "";
	posVirgula = valor.indexOf(",");
	
	for (i=posVirgula-1;i>=0;i--){
		valorFinal = valor.substr(i,1) + valorFinal
		cont ++;
		if (valor.substr(i,1) != "-"){
			if (i>0) {
				if (cont == 3){
					valorFinal = "." + valorFinal;
					cont = 0;
				}
			}
		}
	}
	if (valorFinal=="")
		valorFinal = valorInicial;
	
	valorFinal = valorFinal + valor.substr(posVirgula,3);
	return valorFinal;
}
	function gerarLotes(){
		frm.action='Entrada_cad.asp';
		frm.submit();
	}

	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			var men = 'Deseja realmente excluir essa nota de entrada?\n';
			if (confirm(men)) {
				frm.action="Entrada_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			}else{
				return false;
			}
		}
		else
		{
			if (frm.cmbFornecedor.value == "0") {
				alert("O Fornecedor deve ser informado !");
				frm.cmbFornecedor.focus();
				return false;
			}
			if (frm.txtNumeroNota.value == "0") {
				alert("O Número da Nota deve ser informado !");
				frm.txtNumeroNota.focus();
				return false;
			}
			
			if (frm.txtDataEntrada.value == "") {
				alert("A Data de Entrada deve ser informada!");
				frm.txtDataEntrada.focus();
				return false;
			}
			
			if (frm.txtValorNota.value == "") {
				alert("O Valor da Nota deve ser informao!");
				frm.txtValorNota.focus();
				return false;
			}
			
			if (document.getElementById("txtTotalItens").value!=document.getElementById("txtValorNota").value){
				alert("O Valor da Nota esta diferente dos somantoria dos valores dos itens!");
				frm.txtValorNota.focus();
				return false;
			}
			
			frm.action="Entrada_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
	}
</script>
<%  
	strEmpresaSecaoProduto_submit = "S"
	principal					= "principal.asp"
	strBotaoLimpa				= "S"
	strPagina					= "Entrada_cad.asp"
	
	intCodigo 					= Trim(Request("txtCodigo"))
	intCodEmpresa				= session("CodEmpresa")	
	intFornecedor				= Trim(Request.Form("cmbFornecedor"))
	strNumeroNota				= Trim(Request.Form("txtNumeroNota"))
	strDataEntrada				= Trim(Request.Form("txtDataEntrada"))
	strValorNota				= Trim(Request.Form("txtValorNota"))
	strObs						= replace(Trim(Request.Form("txtObservacao")),"'","")
	
	strItens 				= Trim(Request("txtItens"))
	strItensBanco			= 0

	strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
	strDesabilitaImprimir		= "disabled"
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")

	if trim(intCodigo) <> "" then
	
		sql = " SELECT Codigo, CodEmpresa, CodFornecedor, Numero, Data_Entrada, Valor_Total, excluida, obs"
		sql = sql & " FROM EST_Entrada "
		sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
		sql = sql & " And Codigo = " & intCodigo
		rs.open sql, cnn

		if rs.eof = false then
			
			intCodigo 					= rs("Codigo")
			intFornecedor				= rs("CodFornecedor")
			strObs						= rs("obs")
			strNumeroNota				= rs("Numero")
			strDataEntrada				= formataDataAP(rs("Data_Entrada"))
			strValorNota				= formatnumber(rs("Valor_Total"),2)
			strTipoExecucao 			= "A"
			excluida					= rs("excluida")
			strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "" 'Desabilita o botão Excluir
			strDesabilitaImprimir		= ""

			
		end if 
		rs.close
		sql = " Select count(*) as qtde "
		sql = sql & " from EST_EntradaItens"
		sql = sql & " where CodEntrada = " & intCodigo
		rs.open sql, cnn
		if not rs.eof then
			strItens = rs("qtde")
			strItensBanco = rs("qtde")
		end if
		rs.close
	else
	
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strTipoExecucao 		= "I"
		
	end if 
	strMsnExluida=""
	if excluida = "S" then
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		
		sql = " select o.usuario_incl, o.data_incl, u.nome"
		sql = sql & " from [EST_Ocorrencias] o"
		sql = sql & " inner join SEG_usuarios u on u.cpf = o.usuario_incl"
		sql = sql & " where o.cod_tela = " & intCodigo
		rs.open sql, cnn
		if not rs.eof then
			strMsnExluida = "<br>Por: " & rs("nome") & " em: " & rs("data_incl")
		end if
		rs.close
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
                
            <form id="frm" name="frm" action="Entrada_cad.asp" method="post">
            <!-- inicio do formulario da pagina-->
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td height="26" colspan="2" bgcolor="#CCCCCC" class="texto1"><strong>Dados Entrada</strong></td>
                    </tr>
                  <tr>
                    <td colspan="2" class="texto1">&nbsp;</td>
                    </tr>
                  <tr>
                    <td class="texto1">Se&ccedil;&atilde;o:</td>
                    <td><span class="TextoForm">
                      <!--#include file="../../../includes/inc_cmbSecaoProduto.asp" -->
                    </span></td>
                  </tr>
                  <tr>
                    <td class="texto1">Fornecedor:</td>
                    <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                      <!--#include file="../../../includes/inc_cmbFornecedor.asp"-->
                    <a href="#" onClick="return Consulta('Entrada_con.asp')"><img  src="<%=session("strCaminhoRaiz")%>/images/Consulta_normal.gif" name="Image1311" width="26" height="26" border="0" align="absmiddle" id="Image"></a></td>
                  </tr>
                  <tr>
                    <td class="texto1">N/Nota:</td>
                    <td><input name="txtNumeroNota" type="text" class="text" id="txtNumeroNota" size="50" maxlength="50" value="<%=strNumeroNota%>"></td>
                  </tr>
                  <tr>
                    <td class="texto1">Data de Entrada:</td>
                     <td width="707"><input name="txtDataEntrada" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataEntrada%>" size="10" maxlength="10"></td>
                  </tr>         
                  <tr>
                    <td width="162" class="texto1">Valor Nota:</td>
                    <td width="707"><input name="txtValorNota" type="text" class="text" id="txtValorNota" size="10" maxlength="10" value="<%=strValorNota%>"  onKeyPress="return currencyFormat(this,event)">
                    </td>
                  </tr>
                  <tr>
                    <td class="texto1">Observa&ccedil;&atilde;o:</td>
                    <td><input name="txtObservacao" type="text" class="text" id="txtObservacao" size="100" maxlength="100" value="<%=strObs%>"></td>
                  </tr>
                  <tr>
                    <td class="texto1">&nbsp;</td>
                    <td></td>
                  </tr>
                  <tr>
                    <td height="26" bgcolor="#CCCCCC"  class="texto1"><strong>Itens Entrada</strong></td>
                    <td height="26" align="center" bgcolor="#CCCCCC"  class="texto1"><%if excluida = "S" then%><strong><FONT color="#FF0000">NOTA DE ENTRADA REMOVIDA<%=strMsnExluida%></FONT></strong><%elseif intCodigo <> "" then%><strong><FONT color="#0033FF">NOTA DE ENTRADA ADICIONADA AO ESTOQUE</FONT></strong><%end if%></td>
                    </tr>
                  <tr>
                    <td colspan="2" class="texto1">&nbsp;</td>
                    </tr>
                  <tr>
                    <td class="texto1"><span class="TextoForm">Qtde. de Itens:</span></td>
                    <td><span class="TextoForm">
                    <%
                    
                     if strTipoExecucao = "A" then
                      
                        sql = " Select Codigo, CodEntrada, CodProduto, Quantidade, Valor_unitario "
                        sql = sql & " From EST_EntradaItens "
                        sql = sql & " Where CodEntrada = " & intCodigo
                        rsAux.open sql, cnn
                        
                        vetItens = null
                        qtdeItens = 0
                        
                        rs.open sql, cnn
                        if not rs.eof then
                            vetItens = rs.getRows
                        end if
                        rs.close
                        
                        if isArray(vetItens) then
                            for i=0 to ubound(vetItens,2)
                                qtdeItens 			= qtdeItens + 1
                            next
                        end if
                        
                    end if
                    %>
                    <%if strTipoExecucao = "I" then%>
                        <input name="txtItens" type="text" class="<%if strTipoExecucao = "I" then response.write "text" else response.write "textDesabilita"%>" id="txtItens" <%if strTipoExecucao = "A" then%> readonly <%end if%> value="<%=strItens%>" size="5" maxlength="50"  onKeyPress="return formataCampo(this,2,15)">
                        <input type="button" name="button" class="botao" id="button" value="Gerar Itens" onClick="gerarLotes()">
                    <%else
                        response.Write(strItens)
                      end if%>
                    </span></td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto1">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto1">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0">
                      <tr>
                        <td height="20" width="5%" align="center" class="texto" bgcolor="#CCCCCC"><strong>Item.</strong></td>
                        <td width="71%" class="texto" bgcolor="#CCCCCC"><strong>Produto:</strong></td>
                        <td width="11%" align="center" class="texto" bgcolor="#CCCCCC"><strong>Qtde</strong></td>
                        <td width="13%" align="center" bgcolor="#CCCCCC" class="texto"><strong>Valor Total</strong></td>
                        </tr>
                      <%
                  strTotalItens		= 0
                  
                if strItens <> "" then	
                    if strTipoExecucao = "A" then
                        sql = " Select i.Codigo, i.CodEntrada, i.CodProduto, i.Quantidade, i.Valor_unitario, p.COD_SECAO"
                        sql = sql & " from EST_EntradaItens i "
                        sql = sql & " inner join EST_produto p on p.codigo = i.codProduto"
                        sql = sql & " where i.CodEntrada = " & intCodigo
                        vetItens = null
                        rs.open sql, cnn,3,1
                        if not rs.eof then
                            vetItens = rs.getRows
                        end if
                        rs.close
                    end if
                    qtdeItens = strItens
                    for i=1 to qtdeItens 
        
                        id = i
                        intCodProduto				= "0"
                        strQtde 					= ""
                        strValor					= ""
                    
                        if cInt(i)<=cInt(strItensBanco) and strTipoExecucao = "A" then
                            intCodProduto  		= vetItens(2,i-1)
                            strQtde 			= vetItens(3,i-1)
                            strValor  			= formatnumber(vetItens(4,i-1),2) 
                            strTotalItens		= strTotalItens + vetItens(4,i-1)
                            intSecaoProduto		= vetItens(5,i-1)
                        end if
                        
                        %>
                        
                      <tr>
                        <td align="center"><%=i%></td>
                        <td><!--#include file="../../../includes/inc_cmbProdutoEntrada.asp"--></td>
                        <td align="center"><input name="txtQtde<%=i%>" type="text" class="text" id="txtQtde<%=i%>" size="10" maxlength="20" value="<%=strQtde%>" onKeyPress="return formataCampo(this, 2, 10)"></td>
                        <td align="center"><input name="txtValor<%=i%>" type="text" class="text" id="txtValor<%=i%>" size="10" maxlength="20" value="<%=strValor%>" onBlur="calculaValor('<%=qtdeItens%>')" onKeyPress="return currencyFormat(this,event)"></td>
                      </tr>
                       
                       
                       
                       <%next %>
                   <%end if%>    
                      <tr>
                        <td height="20" colspan="3" align="right" class="texto" ><strong>Total dos itens&nbsp;&nbsp;</strong></td>
                        <td align="center" class="texto" ><input readonly name="txtTotalItens" type="text" class="textDesabilitado" id="txtTotalItens" size="10" maxlength="10" value="<%=formatNumber(strTotalItens,2)%>" ></td>
                      </tr>
                    </table></td>
                    </tr>
                  <tr>
                    <td width="162" class="texto1">&nbsp;</td>
                    <td width="707">
                      </td>
                  </tr>
                  <tr>
                    <td colspan="2"><!--#include virtual="/includes/inc_botoes_cadastro.asp" --></td>
                  </tr>
                  <tr>
                    <td colspan="2">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="2">&nbsp;</td>
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
<script>
	mostraItens();
</script>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>