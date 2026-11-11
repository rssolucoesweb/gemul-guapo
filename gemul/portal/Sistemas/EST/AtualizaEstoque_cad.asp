<%strNomeDaPaginaPortal = "Atualiza Estoque"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
function abreConsulta(){
		window.open("AtualizaEstoque_con.asp", "consulta", "top=0,left=0,height=510,width=750,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
 	}
	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}
	function consultar(intCodigo){
		var frm = document.getElementById("frm");
			frm.txtCodRequisicao.value=intCodigo
			frm.submit();
		}
		
	function consultarPorNumero(){
		var frm = document.getElementById("frm");
			frm.cmbProduto.value=0;
			frm.submit();
		}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		if (frm.txtMotivo.value == "") {
			alert("O motivo deve ser informado !");
			frm.txtMotivo.focus();
			return false;
		}
		if (frm.cmbConferencista.value == "0") {
			alert("Quem fez a conferência deve ser informado !");
			frm.cmbConferencista.focus();
			return false;
		}
		if (frm.cmbProduto.value == "0") {
			alert("O produto deve ser informado !");
			frm.cmbProduto.focus();
			return false;
		}

		if (frm.txtQuantidade.value == "") {
			alert("A quantidade deve ser informada !");
			frm.txtQuantidade.focus();
			return false;
		}
		
		frm.cmbProduto.disabled = false;
		frm.action="AtualizaEstoque_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function enviar(){
		var frm = document.getElementById("frm");
		var men = 'ATENÇÃO: Deseja fechar balanço e atualizar o estoque, esse processo não poderá ser revertido, deseja continuar?\n';
		if (confirm(men)) {
			frm.action="AtualizaEstoque_cod.asp?acao=F";
			frm.submit();
			return true;
		}else{
			return false;
		}
 	}
</script>
<%  
	intCodEmpresa		= session("CodEmpresa")	
	
	sql = "SELECT CODIGO"
	sql = sql & " FROM EST_BALANCO"
	sql = sql & " Where situacao = 'A'"
	sql = sql & " And Cod_Empresa = " & intCodEmpresa
	rs.open sql, cnn
	if rs.eof then
		%>
		<script>
			alert("O balanço não foi aberto!\n\nO balanço do estoque não pode ser iniciado.");
			window.location='AbrirBalanco_cad.asp';
		</script>
		<%
	else
		codBalanco = rs("CODIGO")
	end if 
	rs.close

	strEmpresaSecaoProduto_submit = "S"
	StrReloadProduto = "S"
	principal			= "principal.asp"
	intCodigo 			= Trim(Request("txtCodigo"))
	intCodRequisicao	= Trim(Request("txtCodRequisicao"))
	strMotivo			= Trim(Request("txtMotivo"))
	strMostraBotaoAtualizaEstoque = "S"
	strDesabilitaBotaoAtualizaEstoque = "Disabled"
	intCodSituacao = "1"
	desabilitaProduto		= ""
	intSecaoProduto			= Trim(Request("cmbSecaoProduto"))
	intCodProduto			= Trim(Request.Form("cmbProduto"))
	intNumeroProduto			= Trim(Request.Form("txtCodProduto"))
	intCodConferencista			= Trim(Request("cmbConferencista"))
	if intCodConferencista = "" then intCodConferencista = 0
	if intCodProduto = "" then intCodProduto = 0
	
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	if trim(intCodigo) <> "" then
	
		sql = "select _p.codigo, _r.motivo, _r.codigo as codAtualizacaoEstoque, _p.codconferencista, _pr.cod_Secao, _r.dataentrada, _r.usuario, _p.saldoExistente as quantidade, _p.codproduto,  _r.codSituacao"
		sql = sql & " from EST_ATUALIZACAO_ESTOQUE _r"
		sql = sql & " inner join EST_ATUALIZACAO_ESTOQUE_produto _p on _p.codAtualizacaoEstoque = _r.codigo"
		sql = sql & " inner join EST_produto _pr on _p.codProduto = _pr.codigo"
		sql = sql & " where _p.codigo = " & intCodigo
		sql = sql & " And _r.CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodigo	 		= rs("codigo")
			intCodRequisicao	= rs("codAtualizacaoEstoque")
			strSolicitante		= rs("usuario")
			intCodProduto		= rs("codproduto")
			intCodConferencista = rs("codconferencista")
			desabilitaProduto   = "disabled"
			intQuantidade		= rs("quantidade")
			strSituacao 		= "Em Aberto"
			intCodSituacao		= rs("codsituacao")
			strMotivo			= rs("motivo")
			intSecaoProduto		= rs("cod_Secao")
			strDataSolicitacao	= formatadataAP(rs("dataentrada"))
						
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar = "" 'Desabilita o botão Excluir
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir
			strDesabilitaBotaoAtualizaEstoque = ""
			if intCodSituacao = "2" then
				strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaBotaoAtualizaEstoque = "disabled"
				strSituacao = "Atualizado"
			end if
		end if 
		rs.close
	elseif trim(intCodRequisicao) <> "" then
		sql = "select *"
		sql = sql & " from EST_ATUALIZACAO_ESTOQUE _r"
		sql = sql & " where _r.codigo = " & intCodRequisicao
		sql = sql & " And _r.CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strSolicitante		= rs("usuario")
			strSituacao			= "Em Aberto"
			strDataSolicitacao	= formatadataAP(rs("dataentrada"))
			intCodSituacao		= rs("codsituacao")
			strMotivo			= rs("Motivo")			
			strDesabilitaIncluir = "" 'Desabilita o botão Incluir
			strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			strDesabilitaBotaoAtualizaEstoque = ""
			if intCodSituacao = "2" then
				strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaBotaoAtualizaEstoque = "disabled"
				strSituacao = "Atualizado"
			end if

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if intCodSituacao <> "1" then
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaBotaoEnviarParaAutorizacao = "disabled"
	end if
	
	if intCodProduto = "" then intCodProduto = "0"
	bloqDigitacao = ""
	if intCodProduto <> "0" then
		if intCodRequisicao <> "" then
			sql = "select codigo, SaldoExistente, codConferencista"
			sql = sql & " from EST_ATUALIZACAO_ESTOQUE_PRODUTO _r"
			sql = sql & " where codAtualizacaoEstoque = " & intCodRequisicao
			sql = sql & " And codProduto = " & intCodProduto
			rs.open sql, cnn
			if rs.eof = false then
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
				intCodigo				= rs("codigo")
				intQuantidade			= rs("SaldoExistente")
				intCodConferencista		= rs("codConferencista")
			end if
			rs.close
		end if
		
		sql = "select codigo, QTD_ATUAL_ESTOQUE, isnull(QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO,0) as QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO, isnull(BALANCO,'N') as BALANCO "
		sql = sql & " from EST_PRODUTO"
		sql = sql & " where codigo = " & intCodProduto
		sql = sql & " And Cod_Empresa = " & intCodEmpresa
		rs.open sql, cnn
		if rs.eof = false then
			intNumeroProduto		= rs("codigo")
			strEstoqueAtual		= rs("QTD_ATUAL_ESTOQUE")
			strEstoqueAnterior		= rs("QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO")
			if trim(rs("BALANCO")) = "S" then
				'bloqDigitacao = "disabled"
			end if
		end if
		rs.close
	elseif intNumeroProduto <> "" then
		if intCodRequisicao <> "" then
			sql = "select codigo, SaldoExistente, codConferencista"
			sql = sql & " from EST_ATUALIZACAO_ESTOQUE_PRODUTO _r"
			sql = sql & " where codAtualizacaoEstoque = " & intCodRequisicao
			sql = sql & " And codProduto = " & intNumeroProduto
			rs.open sql, cnn
			if rs.eof = false then
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
				intCodigo				= rs("codigo")
				intQuantidade			= rs("SaldoExistente")
				intCodConferencista		= rs("codConferencista")
			end if
			rs.close
		end if

		sql = "select codigo, cod_Secao, QTD_ATUAL_ESTOQUE, isnull(QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO,0) as QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO, isnull(BALANCO,'N') as BALANCO "
		sql = sql & " from EST_PRODUTO"
		sql = sql & " where codigo = " & intNumeroProduto
		sql = sql & " And Cod_Empresa = " & intCodEmpresa
		rs.open sql, cnn
		if rs.eof = false then
			intCodProduto		= rs("codigo")
			intSecaoProduto		= rs("cod_Secao")
			strEstoqueAtual		= rs("QTD_ATUAL_ESTOQUE")
			strEstoqueAnterior		= rs("QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO")
			if trim(rs("BALANCO")) = "S" then
				'bloqDigitacao = "disabled"
			end if
		end if
		rs.close
	end if	
	strMensagemBalanco = ""
	if bloqDigitacao = "disabled" then
		'strMensagemBalanco = "Produto já foi atualizado em balanço anterior, não poderá ser alterado!"
		'strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		'strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		'strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
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
    <form id="frm" name="frm" action="AtualizaEstoque_cad.asp" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td height="23" class="TextoForm">C&oacute;digo</td>
            <td width="481" class="TextoForm"><input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="10" maxlength="20" value="<%=intCodigo%>">
            <input name="codBalanco" type="hidden" class="text" id="codBalanco" size="10" maxlength="20" value="<%=codBalanco%>">
              <input class="text" name="txtCodRequisicao" size="10" maxlength="20" type="text" id="txtCodRequisicao" value="<%=intCodRequisicao%>" onBlur="consultar(this.value)">
              <a href="#" onClick="abreConsulta()"><img src="../../../images/Consulta_normal.gif" alt="Consultar" name="Image3" width="26" height="26" border="0" align="absbottom"></a></td>
            <td width="81" class="TextoForm">Situa&ccedil;&atilde;o</td>
            <td width="156" class="TextoForm"><strong><%=strSituacao%></strong>&nbsp;</td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Usu&aacute;rio</td>
            <td class="TextoForm"><strong><%=session("strUsuarioRodape")%></strong>&nbsp;</td>
            <td class="TextoForm">Data</td>
            <td class="TextoForm"><strong><%=strDataSolicitacao%></strong>&nbsp;</td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Motivo</td>
            <td colspan="3" class="TextoForm"><textarea name="txtMotivo" id="txtMotivo" cols="60" rows="6"><%=strMotivo%></textarea></td>
          </tr>
          <tr>
            <td height="23" colspan="4" class="TextoForm"><hr size="1" color="#999999"></td>
          </tr>
            <tr valign="top">
              <td width="134" valign="middle" class="TextoForm">Se&ccedil;&atilde;o</td>
              <td colspan="3" class="tituloPrincipal style2"><!--#include file="../../../includes/inc_cmbSecaoProduto.asp" --></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Produto</td>
            <td colspan="3" class="TextoForm"><input name="txtCodProduto" type="text" class="text" id="txtCodProduto" size="10" maxlength="10" value="<%=intNumeroProduto%>" onBlur="consultarPorNumero()"  onKeyPress="return formataCampo(this,2,10)"><!--#include file="../../../includes/inc_cmbProduto.asp"--></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Conferido Por</td>
            <td colspan="3" class="TextoForm"><span class="tituloPrincipal style2">
              <!--#include file="../../../includes/inc_cmbConferencista.asp" -->
            </span></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Estoque Atual</td>
            <td colspan="3" class="TextoForm"><input readonly name="txtEstoqueAtual" type="text" class="textDesabilitado" id="txtEstoqueAtual" size="10" maxlength="20" value="<%=strEstoqueAtual%>"  onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td width="134" height="23" class="TextoForm">Estoque Conferido</td>
            <td colspan="3" class="TextoForm"><input name="txtQuantidade" type="text" class="text" id="txtQuantidade" size="10" maxlength="20" value="<%=intQuantidade%>"  onKeyPress="return formataCampo(this,2,10)"><strong><font color="#FF0000"><%=strMensagemBalanco%></font></strong></td>
          </tr>
          <tr>
            <td height="24" colspan="4" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="4"><!--#include file="../../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="4"><%
					cont =0
					if intCodRequisicao <>"" then

					sql = "SELECT _R.Codigo, _R.CODPRODUTO, _P.DESCRICAO, _U.DESCRICAO AS UNIDADE, _R.saldoExistente as quantidade, _C.nome"
					sql = sql & " FROM EST_ATUALIZACAO_ESTOQUE_produto _R"
					sql = sql & " INNER JOIN EST_PRODUTO _P ON _P.CODIGO = _R.CODPRODUTO"
					sql = sql & " INNER JOIN EST_UNIDADE_PRODUTO _U ON _U.CODIGO = _P.COD_UNIDADE"
					sql = sql & " left JOIN EST_conferencista _C ON _C.CODIGO = _R.codconferencista"
					sql = sql & " where _r.codAtualizacaoEstoque = " & intCodRequisicao
					sql = sql & " Order by _P.DESCRICAO"
					rs.open sql, cnn
					if rs.eof = false then
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                          <td class="celula">Cod</td>
                        <td class="celula"><strong>Produto</strong></td>
                        <td width="6%" height="21" class="celula"><strong>Unidade</strong></td>
                        <td width="11%" align="center" class="celula"><strong>Estoque Conferido<br>Quantidade Atual</strong></td>
                        <td width="16%" class="celula"><strong>Conferido Por</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                              <td width="4%" class="celula"><%=trim(rs("CODPRODUTO"))%></td>
                            <td width="63%" class="celula"><%=trim(rs("DESCRICAO"))%></td>
                            <td height="21" class="celula"><%=trim(rs("unidade"))%></td>
                            <td height="21" class="celula" align="center"><font color="#0000FF"><strong><%=trim(rs("quantidade"))%></strong></font></td>
                            <td class="celula"><%=trim(rs("nome"))%></td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
              <tr>
                <td height="21" colspan="5" class="celula">Total Produtos: <%=cont%></td>
              </table>
            <%
			  end if
			  rs.close
			  end if%></td>
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