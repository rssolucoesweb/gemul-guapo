<%
	if session("codPerfil") = "16" then
%>
    <script>
		function mostraProduto(cod){
			window.location='produto_cad.asp?txtCodigo='+cod;
		}
	</script>
	<%
    intCodSecao = Session("CodSecao")
	if intCodSecao="" then intCodSecao = "0"
	sql = "execute EST_ListaProdutosEstoqueMinimo " & intCodSecao & "," & Session("CodEmpresa")
	rs.open sql, cnn
	if not rs.eof then %>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
      <tr bgcolor="#E5E5E5">
        <td colspan="5" align="center" class="celula"><strong>Produto no Estoque Mínimo</strong></td>
        </tr>
      <tr bgcolor="#E5E5E5">
        <td width="13%" align="center" class="celula"><strong>C&oacute;digo</strong></td>
        <td width="35%" align="center" class="celula"><strong>Descri&ccedil;&atilde;o<span class="TextoForm"></span></strong></td>
        <td width="13%" align="center" class="celula"><strong>Unidade<span class="TextoForm"></span></strong></td>
        <td width="20%" align="center" class="celula"><strong>Qtd. Estoque Atual<span class="TextoForm"></span></strong></td>
        <td width="20%" align="center" class="celula"><strong>Estoque M&iacute;nimo</strong></td>
      </tr>
	<%
		While not rs.eof
			%>
                 <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="mostraProduto('<%=rs("CODIGO")%>')">
                    <td class="celula"><%=rs("CODIGO")%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("DESCRICAO"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("UNIDADE"))%>&nbsp;</td> 
                    <td class="celula" align="center"><font color="#FF0000"><strong><%=trim(rs("QTD_ATUAL_ESTOQUE"))%></strong></font>&nbsp;</td>
                    <td class="celula" align="center"><%=trim(rs("ESTOQUE_MINIMO"))%>&nbsp;</td> 
                  </tr>
			<%
			rs.movenext
		wend
		%></table>
		<%
	end if
	rs.close
end if
	%>