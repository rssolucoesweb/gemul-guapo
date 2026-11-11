<%
	response.Expires=0
	Server.ScriptTimeOut = 5000
	response.Buffer = false
%>
<%strNomeDaPaginaPortal = "Liberação das Solicitações Autorizadas"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function Descricao(tipo){
	
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="block";
			document.all["mostraDescricao"+tipo].style.background="#AAFFAA";
			document.all["mostraDescricaoLinhaSolicicao"+tipo].style.background="#AAFFAA";
			document.all["imgDescricao"+tipo].src="../../../images/up.jpg";
			
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../../images/down.jpg";
			document.all["mostraDescricaoLinhaSolicicao"+tipo].style.background="#FFFFFF";
		}
	}	
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	function salvarQuantidadeAutorizadaAlteracao(qtde){
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	
	function salvarQuantidadeAutorizadaAlteracao(codigo, qtde) {
		iframeAlteracao.location.href='LiberarMaterialAlteracao_cod.asp?codigo='+codigo+'&qtde='+qtde;
		return true;
	}
	function autorizar(req){
		var frm = document.getElementById("frm");
		document.getElementById("cmbAutorizarRequisicao_"+req).disabled = true;
		var men = 'ATENÇÃO: Deseja liberar a requisição número ' + req + '?\n';
		if (confirm(men)) {
			
			frm.action="LiberarMaterial_cod.asp?req="+req;
			frm.submit();
			return true;
		}else{
			document.getElementById("cmbAutorizarRequisicao_"+req).disabled = false;
			return false;
		}
 	}
</script>
<iframe name="iframeAlteracao" height="0" width="0"></iframe>
<%  
	strEmpresaSecaoProduto_submit = "S"
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	strUnidade = request("unidade")
	strTop = request("top")
	if strTop = "" then strTop = "5"
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
    <input value="<%=session("strNomeUsuario")%>" id="usuarioAutorizacao" name="usuarioAutorizacao" type="hidden">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td class="tituloPrincipal style2" width="100%"><span class="TextoForm">Se&ccedil;&atilde;o:
              <!--#include file="../../../includes/inc_cmbSecaoProdutoLiberarMaterial.asp" -->
          </span>
            <%
				cont =0

					sql = "select top " & strTop & " _r.codigo, _r.obs,_u.nome as solicitante, _ua.nome as usuario_autorizacao, _r.data_autorizacao, "
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto "	
					sql = sql & " from est_requisicao _r"
					sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante"
					sql = sql & " left join SEG_usuarios _ua on _ua.cpf = _r.usuario_autorizacao"
					sql = sql & " left join EST_departamento _d on _d.codigo = _u.codDepartamento"
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " where _r.codSituacao = 3 "
					sql = sql & " and _r.cod_secao = " & intSecaoProduto
					if strUnidade<>"" then
						sql = sql & " and _d.descricao like '%" & strUnidade & "%'"
					end if
					sql = sql & " order by 1"
					rs.open sql, cnn
					if rs.eof = false then					
						%>
                        <br>
                        <span class="TextoForm"><br>
                        Mostrar as 
                        <input type="text" name="top" id="top" value="<%=strTop%>" class="texto" size="4" onBlur="submit()">
                    </span><span class="TextoForm">Primeiras Unidades</span><br>
                        <span class="TextoForm"><strong>Departamento/Unidade</strong></span> <span class="TextoForm">
                        <input type="text" name="unidade" id="unidade" value="<%=strUnidade%>" class="texto" size="30">
                        </span>
                        <input name="Consultar" type="submit"  class="botao" id="Consultar"  style="cursor:hand"  onClick="enviar()"  value="Consultar" <%=strDesabilitaBotaoAtualizaEstoque%>>
                        <br>
<br>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                          <td align="center" class="celula">&nbsp;</td>
                        <td align="center" class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="34%" align="center" class="celula"><strong>Departamento/Unidade</strong></td>
                        <td width="37%" align="center" class="celula"><strong>Solicitante</strong></td>
                        <td width="21%" height="21" align="center" class="celula"><strong>Autorizado Por</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							
							%>
                            <tr id="mostraDescricaoLinhaSolicicao<%=rs("codigo")%>" style="cursor:hand" onClick="return Descricao('<%=rs("codigo")%>')">
                                <td width="2%" class="celula"><img style="cursor:hand"  id="imgDescricao<%=rs("codigo")%>" src="../../../images/down.jpg"></td>
                                <td width="6%" class="celula" align="center"><strong><%=rs("Codigo")%></strong></td>
                                <td class="celula"><%=trim(rs("depto"))%></td>
                                <td class="celula"><%=trim(rs("solicitante"))%></td>
                                <td height="21" align="center" class="celula"><%=trim(Rs("usuario_autorizacao"))%><br><%=trim(Rs("data_autorizacao"))%></td>
                            </tr>
                            <tr >
                                <td height="24" colspan="5" class="celula" id="mostraDescricao<%=rs("codigo")%>" style="display:none">
                                    <!-- execucao -->
                                     <%if not isnull(rs("obs")) then%>
                                   <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
                                      <tr bgcolor="#FFB7B7">
                                        <td width="26%" rowspan="2" align="center" class="celula"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                                        <td rowspan="2" align="left" class="celula"><%=rs("obs")%>&nbsp;</td>
                                      </tr>
                                  </table>
                                     <%end if%>
                                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
                                      <tr>
                                        <td width="26%" rowspan="2" align="center" class="celula"><STRONG>Material</STRONG></td>
                                        <td width="6%" rowspan="2" align="center" class="celula"><STRONG>Unidade</STRONG></td>
                                        <td width="19%" rowspan="2" align="center" class="celula"><STRONG>Grupo</STRONG></td>
                                        <td width="22%" rowspan="2" align="center" class="celula"><STRONG>Subgrupo</STRONG></td>
                                        <td colspan="2" align="center" class="celula"><strong>Saldo </strong></td>
                                        <td colspan="3" align="center" class="celula"><STRONG>Quantidade</STRONG></td>
                                      </tr>
                                      <tr>
                                        <td width="8%" align="center" class="celula"><strong>Real</strong></td>
                                        <td width="8%" align="center" class="celula"><strong>Dispon&iacute;vel</strong></td>
                                        <td width="10%" align="center" class="celula"><strong>Solicitada</strong></td>
                                        <td width="9%" align="center" class="celula"><strong>Autorizada</strong></td>
                                        <td width="9%" align="center" class="celula"><strong>Liberar</strong></td>
                                      </tr>
                                      <%
									sql = "execute EST_ListaProdutos " & rs("codigo") & "," & intCodEmpresa
									
									rsAux.open sql, cnn
									if not rsAux.eof then
										while not rsAux.eof
									  	  classCampo = "text"
										  strReadOnly = ""
										  '	perfil atuorizacao de requisicao
										  if trim(session("codPerfil")) = "17" then 'or session("strNomeUsuario")="76143139172" then 'responsavel pela liberaçao do material
											  'classCampo = "text"
											  'strReadOnly = ""
											  'strDesabilitaCampoAutorizacao = ""
										  else
										  	  classCampo = "textDesabilitado"
										  	  strReadOnly = "readonly"
											  strDesabilitaCampoAutorizacao = "disabled"											
										  end if

										  if rsAux("quantidade_autorizada") = "0" then
										  	classCampo = "textDesabilitado"
										  	strReadOnly = "readonly"
										  end if
										  if strCorLinha = "" then
										  	 	strCorLinha = "bgcolor='#E8FFE8'"
										  else
											  	strCorLinha = ""
										  end if
										  %>
										  <tr <%=strCorLinha%>>
											<td  class="celula"><%=rsAux("produto")%></td>
											<td class="celula"><%=ucase(rsAux("unidade"))%>&nbsp;</td>
											<td class="celula"><%=rsAux("grupo")%>&nbsp;</td>
											<td class="celula"><%=rsAux("subgrupo")%>&nbsp;</td>
											<td class="celula" align="center"><%=rsAux("QTD_ATUAL_ESTOQUE")%></td>
											<td class="celula" align="center"><%=rsAux("QTD_ATUAL_DISPONIVEL")%></td>
											<td class="celula" align="center"><%=rsAux("quantidade")%></td>
											<td class="celula" align="center">
											<input <%=strDesabilitaCampoAutorizacao%> name="txtQuantidadeAutorizadaAlteracao" type="text" class="<%=classCampo%>" id="txtQuantidadeAutorizadaAlteracao" size="7" maxlength="10" value="<%=rsAux("quantidade_autorizada")%>"  onKeyPress="return formataCampo(this,2,10)" onBlur="salvarQuantidadeAutorizadaAlteracao('<%=rsAux("codigo")%>',this.value)">
                                            </td>
											<td class="celula" align="center">
											  <input <%=strReadOnly%> name="txtQuantidadeAutorizada_<%=rs("codigo")%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>" type="text" class="<%=classCampo%>" id="txtQuantidadeAutorizada_<%=rs("codigo")%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>" size="7" maxlength="10" value="<%=rsAux("quantidade_autorizada")%>"  onKeyPress="return formataCampo(this,2,10)">
											</td>
										  </tr>
										   <%
										  rsAux.movenext
										wend
									end if
									rsAux.close
									  %>
                                    </table>
                               <div align="center"><input <%=strDesabilitaLiberacao%> name="cmbAutorizarRequisicao_<%=rs("codigo")%>" id="cmbAutorizarRequisicao_<%=rs("codigo")%>" type="button" class="botaoIncluir" value="Clique para Liberar os Materiais e Gerar a Impressão da Solicitação" onClick="autorizar('<%=rs("codigo")%>')"></div>
                               </td>
                          </tr>
              				<%				
						rs.movenext
					wend
					%>
              </table>
            <%
			  else
			  %>
			  <div align="center"><br><br><br><br><br>
			  Não existe solicitação para serem  liberadas<br><br><br></div>
			  <%
			  end if
			  rs.close%></td>
        </tr>
        <tr valign="top">
          <td class="tituloPrincipal style2">&nbsp;</td>
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