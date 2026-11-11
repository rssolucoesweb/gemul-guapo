<%strNomeDaPaginaPortal = "Autorização Emergencial"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="js/ajaxutil6.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function carregaMaterial(){	
		var parametros = 'descricao=' + document.getElementById('txtDescricaoMaterial').value + '&tipoAcao=carregaMaterial';
		parametros = parametros + '&CodSecaoProduto=' + document.getElementById('cmbSecaoProduto').value;
		parametros = parametros + '&tipo_usuario=' + document.getElementById('tipo_usuario').value;
		
		//limpa a combo
		document.getElementById('cmbProduto').innerHTML = '';
		var option = document.createElement('option')
		option.value = ""
		option.text = "Selecione"
		document.getElementById('cmbProduto').options[0] = option;			
		
		//Consulta
		var func = function(xmlHttp2)
		{
			var xml = xmlHttp2.responseXML;
			var elementos = xml.getElementsByTagName('elemento_superior')[0];	
			if (getText(elementos.getElementsByTagName('codigo')[0].childNodes[0]) !=""){
				preencheCombo(xmlHttp2.responseXML, document.getElementById('cmbProduto'));
			}
		}
		//window.open('js/ajax.asp?' + parametros)
		ExecAjax(func,'js/ajax.asp?' + parametros,'','');
	}  
	function abreConsulta(){
		window.open("SolicitacaoEmergencial_con.asp", "consulta", "top=0,left=0,height=510,width=750,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
 	}
	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}
	function consultar(intCodigo){
			frm.txtCodRequisicao.value=intCodigo
			frm.submit();
		}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E") {
			var men = 'ATENÇÃO: Deseja realmente excluir TODOS os materiais dessa solicitação, inclusive a solicitação?\n';
			if (confirm(men)) {
				var frm = document.getElementById("frm");
				frm.action="SolicitacaoEmergencial_cod.asp?acao=EXCLUIR&txtCodRequisicao="+frm.txtCodRequisicao.value;
				frm.submit();
				return true;
			}else{
				return false;
			}		

		}else{
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
		}
		frm.action="SolicitacaoEmergencial_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	function excluirMaterial(codigo){
		var men = 'ATENÇÃO: Deseja realmente excluir esse material da solicitação?\n';
		if (confirm(men)) {
			var frm = document.getElementById("frm");
			frm.action="SolicitacaoEmergencial_cod.asp?acao=EM&codigo=" + codigo + "&txtCodRequisicao="+frm.txtCodRequisicao.value;
			frm.submit();
			return true;
		}else{
			return false;
		}		
		
 	}

	function enviar(){
		var men = 'ATENÇÃO: Deseja realmente enviar essa solicitação para autorização, após enviado não poderá mais efetuar alteração nesta requisição?\n';
		if (confirm(men)) {
			var frm = document.getElementById("frm");
			frm.action="SolicitacaoEmergencial_cod.asp?acao=F";
			frm.submit();
			return true;
		}else{
			return false;
		}
		
 	}
</script>
<%  
	strLiberaAlteracao		= "S"
	usuarioInclusao			= session("strUsuario")
	intCodEmpresa			= session("codEmpresa")	
	strObs					= request("txtObs")
	strCodigoAutorizacao	= request("txtCodigoAutorizacao")
	strUsuarioAutorizacao	= request("txtUsuarioAutorizacao")
	intCodRequisicao	= Trim(Request("txtCodRequisicao"))
	if strCodigoAutorizacao = "" then strCodigoAutorizacao = "0"
	sql = "select cod_requisicao, situacao"
	sql = sql & " from EST_RequisicaoEmergencialAutorizacao"
	sql = sql & " where codEmpresa = " & intCodEmpresa
	sql = sql & " and solicitante = '"&strUsuarioAutorizacao&"'"
	sql = sql & " and codigo = " & strCodigoAutorizacao
	rs.open sql, cnn
	if not rs.eof then
		liberado = "SIM"
		intCodRequisicao = rs("cod_requisicao")
	end if
	rs.close

	if liberado = "NAO" then
		%>
		<script>
			alert("ATENÇÃO: Não foi encontrada a autorização para a inclusão da solicitação emergencial, favor solicitar uma nova autorização.");
			window.history.back();
		</script>
		<%
		response.End()
	end if
	
	
	if isnull(usuarioInclusao) then usuarioInclusao = ""
	
	if usuarioInclusao="" then
		%>
		<script>
			alert("Usuário esta sem lotação, acesso o modulo de segurança e vinculo o usuário a sua lotação.");
			window.history.back();
		</script>
		<%
		response.End()
	else
		sql = "SELECT _d.Descricao as depto, _d.codigo, _d.tipo  "
		sql = sql & " FROM SEG_usuarios _u"
		sql = sql & " inner join EST_DEPARTAMENTO _d on _d.codigo = _u.codDepartamento"
		sql = sql & " Where _u.cpf = '" & usuarioInclusao & "'"
		rsAux.open sql, cnn
		if rsAux.eof then	
			rsAux.close
			%>
			<script>
				alert("Usuário esta sem lotação, acesso o modulo de segurança e vinculo o usuário a sua lotação.");
				window.history.back();
			</script>
			<%
			response.End()
		else
			tipo_usuario = rsAux("tipo")
			strDepartamento = rsAux("depto")
			intCodDepartamento = rsAux("codigo")
		end if
		rsAux.close		
	end if	
	strEmpresaSecaoProduto_submit = "S"
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intCodigo 			= Trim(Request("txtCodigo"))
	strMostraBotaoEnviarParaAutorizacao = "S"
	strDesabilitaBotaoEnviarParaAutorizacao = "Disabled"
	intCodSituacao = "1"
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	
	if trim(intCodRequisicao) <> "" then
		sql = "select _r.*, _s.descricao as situacao"
		sql = sql & " from est_requisicao _r"
		sql = sql & " inner join est_situacao _s on _s.codigo = _r.codsituacao"
		sql = sql & " where _r.codigo = " & intCodRequisicao
		sql = sql & " And _r.CodEmpresa = " & intCodEmpresa
		if session("bolUsuarioAcessaTodasRequisicoes")="" then 'responsavel pela liberaçao do material
			sql = sql & " and 	_r.solicitante = '" & session("strNomeUsuario") & "'"
		end if
		rs.open sql, cnn
		
		if rs.eof = false then
			strObs				= rs("obs")
			strSolicitante		= rs("solicitante")
			strSituacao			= rs("situacao")
			strDataSolicitacao	= formatadataAP(rs("dataentrada"))
			intCodSituacao		= rs("codsituacao")
						
			strDesabilitaIncluir = "" 'Desabilita o botão Incluir
			strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir
			strDesabilitaBotaoEnviarParaAutorizacao = ""
			rs.close
		else
			rs.close
			%>
			<script>
				alert("ATENÇÃO: Solicitação de material não foi encontrada.");
				window.location='SolicitacaoEmergencial_cad.asp';
			</script>
			<%
			response.End()
		end if 
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
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <form id="frm" name="frm" action="SolicitacaoEmergencial_cad.asp" method="post">
    <input name="tipo_usuario" type="hidden" id="tipo_usuario"  value="<%=tipo_usuario%>">
    <input name="txtCodigoAutorizacao" type="hidden" id="txtCodigoAutorizacao"  value="<%=strCodigoAutorizacao%>">
    <input name="txtUsuarioAutorizacao" type="hidden" id="txtUsuarioAutorizacao"  value="<%=strUsuarioAutorizacao%>">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td height="23" class="TextoForm">C&oacute;digo</td>
            <td width="426" class="TextoForm"><input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="10" maxlength="20" value="<%=intCodigo%>">
              <input readonly class="textDesabilitado" name="txtCodRequisicao" size="10" maxlength="20" type="text" id="txtCodRequisicao" value="<%=intCodRequisicao%>" onBlur="consultar(this.value)"></td>
            <td width="126" class="TextoForm">Situa&ccedil;&atilde;o</td>
            <td width="164" class="TextoForm"><strong><%=strSituacao%></strong>&nbsp;</td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Solicitante</td>
            <td class="TextoForm"><strong><%=session("strUsuarioRodape")%></strong>&nbsp;</td>
            <td class="TextoForm">Data</td>
            <td class="TextoForm"><strong><%=strDataSolicitacao%></strong>&nbsp;</td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Lotação</td>
            <td class="TextoForm"><strong><%=strDepartamento%></strong>&nbsp;</td>
            <td class="TextoForm">&nbsp;</td>
            <td class="TextoForm">&nbsp;</td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Observa&ccedil;&atilde;o</td>
            <td colspan="3" class="TextoForm">
              <textarea name="txtObs" id="txtObs" cols="75" rows="3" class="text"><%=strObs%></textarea></td>
          </tr>
          <tr>
            <td height="23" colspan="4" class="TextoForm"><hr size="1" color="#999999"></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Se&ccedil;&atilde;o</td>
            <td colspan="3" class="TextoForm"><span class="tituloPrincipal style2">
              <!--#include file="../../../includes/inc_cmbSecaoProduto.asp" -->
            </span></td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Material</td>
            <td colspan="3" class="TextoForm"><!--#include file="../../../includes/inc_cmbProdutoSolicitacao.asp"-->
<input name="txtDescricaoMaterial" type="text" class="text" id="txtDescricaoMaterial" size="30" maxlength="100" value="<%=strDescricaoMaterial%>" >
<input type="button" name="cmdFiltrar"  style="cursor:hand"  value="Filtrar Material"  class="botao"  onClick="carregaMaterial()"></td>
            </tr>
          <tr>
            <td width="136" height="23" class="TextoForm">Quantidade</td>
            <td colspan="3" class="TextoForm"><input name="txtQuantidade" type="text" class="text" id="txtQuantidade" size="10" maxlength="20" value="<%=intQuantidade%>"  onKeyPress="return formataCampo(this,2,10)"></td>
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

					sql = "SELECT _R.Codigo, _R.CODPRODUTO, _P.DESCRICAO,  _U.DESCRICAO AS UNIDADE, _R.quantidade"
					sql = sql & " FROM EST_RequisicaoProduto _R"
					sql = sql & " INNER JOIN EST_PRODUTO _P ON _P.CODIGO = _R.CODPRODUTO"
					sql = sql & " INNER JOIN EST_UNIDADE_PRODUTO _U ON _U.CODIGO = _P.COD_UNIDADE"
					sql = sql & " where _r.codRequisicao = " & intCodRequisicao
					sql = sql & " Order by _P.DESCRICAO"
					rs.open sql, cnn
					if rs.eof = false then
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td class="celula"><strong>Material</strong></td>
                        <td width="10%" height="21" class="celula"><strong>Unidade</strong></td>
                        <td width="28%" class="celula"><strong>Quantidade</strong></td>
                        <td width="2%" align="center" class="celula"><strong>Excluir</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" >
                            <td width="60%" class="celula"><%=trim(rs("DESCRICAO"))%></td>
                            <td height="21" class="celula"><%=trim(rs("unidade"))%></td>
                            <td height="21" class="celula" ><%=trim(rs("quantidade"))%></td>
                            <td align="center" class="celula"><%if strDesabilitaBotaoEnviarParaAutorizacao="" then%><a href="#" onClick="excluirMaterial('<%=rs("Codigo")%>')"><img src="../../../images/botao_vermelho_normal.gif" width="26" height="26" alt="Clique para excluir esse material" border="0"></a><%else%>&nbsp;<%end if%></td>
                            </tr>
              				<%				
					rs.movenext
					wend
					%>
              <tr>
                <td height="21" colspan="4" class="celula">Total 
                  Produtos: <%=cont%></td>
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