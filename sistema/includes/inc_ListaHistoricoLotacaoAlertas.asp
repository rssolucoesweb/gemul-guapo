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
	IF codEmpresaHistorico<>"" THEN

		sql = " SELECT c.nome, c.codFuncional, HL.COD_LOTACAOHISTORICO, HL.COD_LOTACAO, HL.DATA_ALTERACAO, HL.USUA_CODG, E.RAZAOSOCIAL, HL.DataLotacao, C.codLotacao as codLotacaoAtual, HL.COD_COLABORADOR"
		sql = sql & " FROM SRH_LOTACAOHISTORICO HL "
		sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO = HL.COD_COLABORADOR "
		sql = sql & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = HL.COD_LOTACAO "
		sql = sql & " WHERE C.codLotacao = " & codEmpresaHistorico & " and year(hl.DATA_ALTERACAO) = " & strAno
		sql = sql & " ORDER BY HL.COD_LOTACAOHISTORICO DESC "
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%>
            <div class="panel panel-grey">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-tasks"></i> Históricos do ano <strong><%=strAno%></strong>
                </h3>
            </div>
            <div class="panel-body">
            <table class="table table-bordered" >
		  		<thead>
			  <tr  bgcolor="#E2E2E2">
						<th width="30%">Nome</th>
						<th width="5%" >Matrícula</th>
                        <th width="12%" align="center"><strong>Data Ocorr&ecirc;ncia</strong></td>
                        <th width="35%"><strong>Unidade Escolar </strong></td>
                        <th width="25%"><strong>Respons&aacute;vel pela Remo&ccedil;&atilde;o </strong></td>
                        <th width="5%" align="center" ><strong>Lotação</strong></td>
                        <th width="5%" align="center" ><strong>Remoção</strong></td>
					</tr>
				</thead>
				<%
				while not rs.eof
					%>
					<tr>
						<td><%=RS("nome")%></td>
						<td><%=RS("codFuncional")%></td>
			    		<td align="center" class="celula"><%=formatadataAP(RS("DATA_ALTERACAO"))%>&nbsp;</td>
                        <td class="celula"><%=RS("RAZAOSOCIAL")%>&nbsp;</td>
                        <td class="celula"><%=RS("USUA_CODG")%>&nbsp;</td>
                        <td align="center" class="celula"><button class="btn-u btn-u-sea" onclick="mostraRelLotacao('<%=rs("COD_COLABORADOR")%>','<%=rs("codLotacaoAtual")%>','<%=rs("COD_LOTACAO")%>')" type="button"><i class="fa fa-file-text-o"></i></button></td>
                        <td align="center" class="celula"><button class="btn-u btn-u-sea" onclick="mostraRelRemocao('<%=rs("COD_COLABORADOR")%>','<%=rs("codLotacaoAtual")%>','<%=rs("COD_LOTACAO")%>')" type="button"><i class="fa fa-file-text-o"></i></button></td>
						 
					</tr>
					<%				
					rs.movenext
					wend
    			%>
    		</table>
			</div>
    	</div>
		<%
		END IF
		RS.CLOSE
	END IF
%> 
