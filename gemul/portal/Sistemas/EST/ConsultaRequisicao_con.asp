<%strNomeDaPaginaPortal = "Consultar Solicitações"%>
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
			document.all["imgDescricao"+tipo].src="../../../images/up.jpg";
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../../images/down.jpg";
		}
	}	
	function resultadoConsulta(){
		if (frm.txtNumero.value==""){
			if (frm.txtDataI.value == "") {
				alert("A Data inicial deve ser informada!");
				frm.txtDataI.focus();
				return false;
			}
			if (frm.txtDataF.value == "") {
				alert("A Data final deve ser informada!");
				frm.txtDataF.focus();
				return false;
			}
		}
		frm.submit();
	}

</script>
<%  
	StrReloadSistema	= "S"
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	strNumero			= Trim(Request.Form("txtNumero"))
	intCodSituacaoRequisicao	 		= Trim(Request.Form("cmbSituacaoRequisicao"))
	if intCodSituacaoRequisicao = "" then intCodSituacaoRequisicao = "0"
	intCodDepartamento	 		= Trim(Request.Form("cmbDepartamento"))
	if intCodDepartamento = "" then intCodDepartamento = "0"	
	strConsultar	= request("strConsultar")
	strSubmitDepto = "N"
	strDataI 		= formatadataBD(request("txtDataI"))
	strDataF 		= formatadataBD(request("txtDataF"))

%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <form id="frm" name="frm" action="ConsultaRequisicao_con.asp" method="post">
    <input name="strConsultar" value="s" type="hidden">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td class="TextoForm">C&oacute;d. Solicita&ccedil;&atilde;o</td>
          <td class="TextoForm">
            <input name="txtNumero" type="text" class="text" id="txtNumero" size="7" maxlength="10" value="<%=strNumero%>"  onKeyPress="return formataCampo(this,2,5)">
            </td>
        </tr>
        <tr valign="top">
          <td class="TextoForm">Per&iacute;odo</td>
          <td><input name="txtDataI" id="txtDataI" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataI%>" size="10" maxlength="10">
a
  <input name="txtDataF" id="txtDataF" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataF%>" size="10" maxlength="10"></td>
        </tr>
        <tr valign="top">
          <td class="TextoForm">Depto./Unidade</td>
          <td><!--#include file="../../../includes/inc_cmbDepartamentoEstoque.asp"--></td>
        </tr>
        <tr valign="top">
          <td width="14%" class="TextoForm">Situa&ccedil;&atilde;o</td>
          <td width="86%"><!--#include file="../../../includes/inc_cmbSituacaoRequisicao.asp"--></td>
        </tr>
        <tr valign="top">
          <td colspan="2" class="TextoForm"><br>            <input name="Submit" type="button" onClick="resultadoConsulta()" class="botao" id="button" value="   Consultar Solicita&ccedil;&otilde;es   "></td>
          </tr>
        <tr valign="top">
          <td class="TextoForm">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr valign="top">
          <td colspan="2" class="tituloPrincipal style2">
		  <%
		  		if strConsultar="s" then
					cont =0

					sql = "select _r.codigo, _r.obs, _u.nome as usuario_solicitante, _r.dataEntrada, "
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto, "	
					sql = sql & " 	_s.descricao as situacao, _uaa.nome as usuario_autorizacao, _r.data_autorizacao, _ua.nome as usuario_liberacao, _r.data_liberacao, _r.codSituacao"
					sql = sql & " from est_requisicao _r"
					sql = sql & " LEFT join SEG_usuarios _u on _u.cpf = _r.solicitante"
					sql = sql & " LEFT join SEG_usuarios _ua on _ua.cpf = _r.usuario_liberacao"
					sql = sql & " LEFT join SEG_usuarios _uaa on _uaa.cpf = _r.usuario_autorizacao"
					sql = sql & " LEFT join EST_departamento _d on _d.codigo = _u.codDepartamento"
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " LEFT join EST_situacao _s on _s.codigo = _r.codSituacao"
					sql = sql & " where 1=1"
					sql = sql & " and _r.CodEmpresa = " & session("CodEmpresa")	
					if intCodDepartamento<>"0" then
						sql = sql & " and _d.codigo = " & intCodDepartamento
					end if
					if intCodSituacaoRequisicao<>"0" then
						sql = sql & " and _r.codSituacao = " & intCodSituacaoRequisicao
					end if
					if strNumero<>"" then
						sql = sql & " and _r.codigo = " & strNumero
					end if
					if strDataI<>"" and strDataF<>"" then
						sql = sql & " and _r.dataEntrada between '" & strDataI & "' and '" & strDataF & "'"
					end if
					sql = sql & " order by _r.data_liberacao, _r.data_autorizacao, _r.codigo"
					rs.open sql, cnn
					if rs.eof = false then
						
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                          <td align="center" class="celula">&nbsp;</td>
                        <td align="center" class="celula"><strong>C&oacute;d.</strong></td>
                        <td width="20%" align="center" class="celula"><strong>Departamento/Unidade</strong></td>
                        <td width="20%" align="center" class="celula"><strong>Solicitante</strong></td>
                        <td width="15%" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                        <td width="15%" align="center" class="celula"><strong>Autorizado Por</strong></td>
                        <td width="15%" height="21" align="center" class="celula"><strong>Liberada Por</strong></td>
                        <td width="15%" align="center" class="celula"><strong>Emitir</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" >
                                <td width="2%" class="celula" onClick="return Descricao('<%=rs("codigo")%>')"><img style="cursor:hand"  id="imgDescricao<%=rs("codigo")%>" src="../../../images/down.jpg"></td>
                                <td width="5%" class="celula" align="center"onClick="return Descricao('<%=rs("codigo")%>')" ><strong><%=rs("Codigo")%></strong></td>
                                <td class="celula" onClick="return Descricao('<%=rs("codigo")%>')"><%=trim(rs("depto"))%></td>
                                <td class="celula" onClick="return Descricao('<%=rs("codigo")%>')"><%=trim(rs("usuario_solicitante"))%><br><%=trim(Rs("dataEntrada"))%></td>
                                <td align="center" class="celula" onClick="return Descricao('<%=rs("codigo")%>')"><%=trim(rs("situacao"))%></td>
                                <td align="center" class="celula" onClick="return Descricao('<%=rs("codigo")%>')"><%=trim(rs("usuario_autorizacao"))%><br><%=trim(Rs("data_autorizacao"))%></td>
                                <td height="21" align="center" class="celula" onClick="return Descricao('<%=rs("codigo")%>')"><%=trim(rs("usuario_liberacao"))%><br><%=trim(Rs("data_liberacao"))%></td>
                                <td align="center" class="celula" valign="middle">&nbsp;
                                <%if rs("codSituacao")="4" then%>
                                <input class="botao" type="button" name="button2" id="button2" value="Imprimir" onClick="window.location='Rel_SolicitacaoAutorizada_rel.asp?req=<%=rs("codigo")%>'">
                                <%end if%>&nbsp;
                                </td>
                            </tr>
                            <tr >
                                <td height="4" colspan="8" class="celula" width="100%" align="center">
                                    <!-- execucao -->
                                    
                                    
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela" id="mostraDescricao<%=rs("codigo")%>" style="display:none">
                                      <tr>
                                        <td>
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
                                        <td colspan="3" align="center" class="celula"><STRONG>Quantidade</STRONG></td>
                                      </tr>
                                      <tr>
                                        <td width="10%" align="center" class="celula"><strong>Solicitada</strong></td>
                                        <td width="10%" align="center" class="celula"><strong>Autorizada</strong></td>
                                        <td width="10%" align="center" class="celula"><strong>Liberada</strong></td>
                                      </tr>
                                      <%
									sql = "  select	_p.DESCRICAO as produto,_rp.codigo, _rp.codProduto,_up.descricao as unidade,_s.descricao as secao, _g.DESCRICAO as grupo,_sg.DESCRICAO as subgrupo,_rp.quantidade,"
									sql = sql & " 	_rp.quantidade_autorizada, _rp.quantidade_liberada,"
									sql = sql & " 		_p.QTD_ATUAL_ESTOQUE"									
									sql = sql & " from EST_RequisicaoProduto _rp"
									sql = sql & " inner join EST_PRODUTO _p on _p.codigo = _rp.codProduto"
									sql = sql & " left join EST_UNIDADE_PRODUTO _up on _up.codigo = _p.COD_UNIDADE"
									sql = sql & " left join EST_SUBGRUPO_PRODUTO _sg on _sg.codigo = _p.COD_SUBGRUPO"
									sql = sql & " left join EST_GRUPO_PRODUTO _g on _g.codigo = _sg.COD_GRUPO_PRODUTO"
									sql = sql & " left join EST_SECAO_PRODUTO _S on _S.codigo = _P.COD_SECAO AND _S.COD_EMPRESA = _P.COD_EMPRESA"
									sql = sql & " where _rp.codRequisicao = "& rs("codigo")
									IF Session("CodSecao")<>"0" THEN
										sql = sql & " and _p.COD_SECAO = "& Session("CodSecao")
									END IF
									sql = sql & " order by 1"
									rsAux.open sql, cnn
									if not rsAux.eof then
										while not rsAux.eof
									  	  classCampo = "text"
										  readOnly = ""
										  if rsAux("quantidade_autorizada") = "0" then
										  	classCampo = "textDesabilitado"
										  	readOnly = "readonly"
										  end if
										  
										  if rs("codSituacao")="1" then
											  quantidade_autorizada = ""
											  quantidade_liberada = ""
										  elseif rs("codSituacao")="2" then
											  quantidade_autorizada = rsAux("quantidade_autorizada")
											  quantidade_liberada = ""
										  else
											  quantidade_autorizada = rsAux("quantidade_autorizada")
											  quantidade_liberada = rsAux("quantidade_liberada")
										  end if
										  
										  %>
										  <tr>
											<td  class="celula"><%=rsAux("produto")%></td>
											<td class="celula"><%=rsAux("unidade")%>&nbsp;</td>
											<td class="celula"><%=rsAux("grupo")%>&nbsp;</td>
											<td class="celula"><%=rsAux("subgrupo")%>&nbsp;</td>
											<td class="celula" align="center"><%=rsAux("quantidade")%>&nbsp;</td>
											<td class="celula" align="center"><%=quantidade_autorizada%>&nbsp;</td>
											<td class="celula" align="center"><%=quantidade_liberada%>&nbsp;</td>
										  </tr>
										   <%
										  rsAux.movenext
										wend
									end if
									rsAux.close
									  %>
                                    </table>
                                        
                                        </td>
                                      </tr>
                                     </table>
                                    
                                   
                               
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
			  Não existe solicitação<br><br><br></div>
			  <%
			  end if
			  rs.close
			  
			end if%>
              </td>
        </tr>
        <tr valign="top">
          <td colspan="2" class="tituloPrincipal style2">&nbsp;</td>
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
<!--include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>