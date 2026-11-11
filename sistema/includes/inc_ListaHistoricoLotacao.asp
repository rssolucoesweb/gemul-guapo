<script>
	function mostraRelLotacao(codFunc,lotAtual,lotAnterior){
		var caminho = 'Rel_Declaracao_Lotacao_rel.asp?CodColaborador=' + codFunc + '&CodLotacao=' + lotAtual + '&CodLotacaoAnterior=' + lotAnterior
		window.open(caminho,"mostraRelLotacao", "top=0,left=0,height=570,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	
	function mostraRelRemocao(codFunc,lotAtual,lotAnterior){
		var caminho = 'Rel_Declaracao_Remocao_rel.asp?CodColaborador=' + codFunc + '&CodLotacao=' + lotAtual + '&CodLotacaoAnterior=' + lotAnterior
		window.open(caminho,"mostraRelRemocao", "top=0,left=0,height=570,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	

</script>
<%
	IF intCodigo <> "" THEN
	
		sql = " SELECT HL.COD_LOTACAOHISTORICO, HL.COD_LOTACAO, HL.DATA_ALTERACAO, HL.USUA_CODG, E.RAZAOSOCIAL, HL.DataLotacao, C.codLotacao as codLotacaoAtual "
		sql = sql & " FROM SRH_LOTACAOHISTORICO HL "
		sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO = HL.COD_COLABORADOR "
		sql = sql & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = HL.COD_LOTACAO "
		sql = sql & " WHERE HL.COD_COLABORADOR = " & intCodigo
		sql = sql & " ORDER BY HL.COD_LOTACAOHISTORICO DESC "
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%>
        <br />
		<table width="99%" border="0" cellspacing="0" class="tabela" cellpadding="0">
		  <tr style="cursor:hand">
			<td height="18"  align="center"  class="celula"  width="1%"><a href="javascript:mostraLinhaTr(10)">[+]</a></td>
			<td width="99%" bgcolor="#F5F5F5"  align="center"  class="celula"><strong><span class="style1">Hist&oacute;rico de Remo&ccedil;&atilde;o </span></strong></td>
		  </tr>
		  <tr id="tr10" style="display:none">
			<td height="96" colspan="2"  class="celula">
            <br />
            <table width = "96%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
			  <tr bgcolor="#E5E5E5">
			    <td width="8%" align="center" class="celula"><strong>Data Ocorr&ecirc;ncia</strong></td>
			    <td width="8%" align="center" class="celula"><strong>Data Remo&ccedil;&atilde;o</strong></td>
			    <td width="28%" class="celula"><strong>Unidade Escolar </strong></td>
			    <td width="46%" class="celula"><strong>Respons&aacute;vel pela Remo&ccedil;&atilde;o </strong></td>
			    <td width="5%" align="center" class="celula"><strong>Lotação</strong></td>
			    <td width="5%" align="center" class="celula"><strong>Remoção</strong></td>
		      </tr>
			  <%
					WHILE NOT RS.EOF
						%>
			  <tr bgcolor="#FFFFCC">
			    <td align="center" class="celula"><%=formatadataAP(RS("DATA_ALTERACAO"))%>&nbsp;</td>
			    <td align="center" class="celula"><%=formatadataAP(RS("DataLotacao"))%>&nbsp;</td>
			    <td class="celula"><%=RS("RAZAOSOCIAL")%>&nbsp;</td>
			    <td class="celula"><%=RS("USUA_CODG")%>&nbsp;</td>
			    <td align="center" class="celula"><a href="#" onclick="mostraRelLotacao('<%=intCodigo%>','<%=rs("codLotacaoAtual")%>','<%=rs("COD_LOTACAO")%>')"><img border="0" src="../../images/impressora.gif" width="16" height="16" /></a></td>
			    <td align="center" class="celula"><a href="#" onclick="mostraRelRemocao('<%=intCodigo%>','<%=rs("codLotacaoAtual")%>','<%=rs("COD_LOTACAO")%>')"><img border="0" src="../../images/impressora.gif" width="16" height="16" /></a></td>
		      </tr>
			  <%
						RS.MOVENEXT
					WEND
				%>
		    </table></td>
		  </tr>
		</table>
<br />
		<%
		END IF
		RS.CLOSE
	END IF
%>