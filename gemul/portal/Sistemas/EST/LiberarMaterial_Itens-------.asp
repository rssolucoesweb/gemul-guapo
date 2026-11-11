<!--#include file="../../../includes/inc_cnn.asp"-->
<!-- execucao -->   
<% 
 
Function RemoveAcentos(ByVal Texto)
		Dim ComAcentos
		Dim SemAcentos
		Dim Resultado
		Dim Cont
		'Conjunto de Caracteres com acentos
		ComAcentos = "ÁÍÓÚÉÄÏÖÜËÀÌÒÙÈÃÕÂÎÔÛÊáíóúéäïöüëàìòùèãõâîôûêÇçº°"
		'Conjunto de Caracteres sem acentos
		SemAcentos = "AIOUEAIOUEAIOUEAOAIOUEaioueaioueaioueaoaioueCc.."
		Cont = 0
		
		Resultado = Texto
		Do While Cont < Len(ComAcentos)
			Cont = Cont + 1
			Resultado = Replace(Resultado, Mid(ComAcentos, Cont, 1), Mid(SemAcentos, Cont, 1))
		Loop
		RemoveAcentos = Resultado
End Function 


codRequisicao = request("id")

%>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
	  <tr>
		<td width="26%" rowspan="2" align="center" class="celula"><STRONG>Material</STRONG></td>
		<td width="6%" rowspan="2" align="center" class="celula"><STRONG>Unidade</STRONG></td>
		<td width="19%" rowspan="2" align="center" class="celula"><STRONG>Tombamento</STRONG></td>
		<td width="22%" rowspan="2" align="center" class="celula"><STRONG>Grupo</STRONG></td>
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
			  intQtdeItens = 0
			sql = "execute EST_ListaProdutos " & codRequisicao & "," & session("CodEmpresa")	
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
				  strExisteTombamento = "N"
				  %>
				  <tr <%=strCorLinha%>>
					<td  class="celula"><%=RemoveAcentos(rsAux("produto"))%></td>
					<td class="celula"><%=RemoveAcentos(ucase(rsAux("unidade")))%>&nbsp;</td>
					<td class="celula" align="center">
                    <%if rsAux("tombamento") = "S" then
						strExisteTombamento = "S"
						%>
                    	<input name="txtTombamento_<%=codRequisicao%>" type="text" class="text" id="txtTombamento_<%=codRequisicao%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>" size="10" maxlength="30" value="" onBlur="salvarQuantidadeAutorizadaAlteracao('<%=rsAux("codigo")%>',this.value,'TOMBAMENTO')">
                    <%else%>
                    	-
                    <%end if%>
                    </td>
					<td class="celula"><%=RemoveAcentos(rsAux("grupo"))%>&nbsp;</td>
					<td class="celula" align="center"><%=rsAux("QTD_ATUAL_ESTOQUE")%></td>
					<td class="celula" align="center"><%=rsAux("QTD_ATUAL_DISPONIVEL")%></td>
					<td class="celula" align="center"><%=rsAux("quantidade")%></td>
					<td class="celula" align="center">
					<input <%=strDesabilitaCampoAutorizacao%> name="txtQuantidadeAutorizadaAlteracao" type="text" class="<%=classCampo%>" id="txtQuantidadeAutorizadaAlteracao" size="7" maxlength="10" value="<%=rsAux("quantidade_autorizada")%>"  onKeyPress="return formataCampo(this,2,10)" onBlur="salvarQuantidadeAutorizadaAlteracao('<%=rsAux("codigo")%>',this.value,'QUANTIDADE')">
					</td>
					<td class="celula" align="center">
					  <input <%=strReadOnly%> name="txtQuantidadeAutorizada_<%=codRequisicao%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>" type="text" class="<%=classCampo%>" id="txtQuantidadeAutorizada_<%=codRequisicao%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>" size="7" maxlength="10" value="<%=rsAux("quantidade_autorizada")%>"  onKeyPress="return formataCampo(this,2,10)">
					</td>
				  </tr>
				   <%
				   intQtdeItens = intQtdeItens + 1
				  rsAux.movenext
				wend
			end if
			rsAux.close
			  %>
			</table>
	   <div align="center"><input <%=strDesabilitaLiberacao%> name="cmbAutorizarRequisicao_<%=codRequisicao%>" id="cmbAutorizarRequisicao_<%=codRequisicao%>" type="button" class="botaoIncluir" value="Clique para Liberar os Materiais e Gerar a Impress&atilde;o da Solicita&ccedil;&atilde;o" onClick="autorizar('<%=codRequisicao%>','<%=strExisteTombamento%>','<%=intQtdeItens%>')"></div>
<script>
document.all["aguarde_<%=codRequisicao%>"].style.display="none";
</script>
		 
