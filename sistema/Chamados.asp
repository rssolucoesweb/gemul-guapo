<style>
	.tabela 
{ 
	border-top: 1px solid #CCCCCC; 
	border-left: 1px solid #CCCCCC; 
	border-bottom: 1px solid #FFFFFF; 
	border-right: 1px solid #FFFFFF 
}

.celula 
{ 
	border-top: 1px solid #FFFFFF; 
	border-left: 1px solid #FFFFFF; 
	border-bottom: 1px solid #CCCCCC; 
	border-right: 1px solid #CCCCCC;
}
	
</style>
<%
		
		
		strGestorSuporte = ""
		sql = "select ISNULL(GESTOR_SUPORTE,'N') as GESTOR_SUPORTE From SEG_USUARIOS_SISTEMA"
		sql = sql & " where usua_stat = 'A' AND Usua_Codg = '"& Trim(session("UsuarioWeb")) & "'"
		rs.open sql, cnn
		if rs.eof = false then
           strGestorSuporte = trim(rs("GESTOR_SUPORTE"))
		end if
		rs.close
	
		strResponsavelAbertura	= Trim(session("UsuarioWeb"))
		
		IF strGestorSuporte = "S" THEN
			sql = "SELECT 1, Codigo, Cod_empresa, DataAbertura, DataAndamento, DataExecucao ,Ocorrencias,sequencia_desenvolvimento,replace(pedido_por,'|','<br>') as pedido_por,"
			sql = sql & " Cod_Usuario_Abertura, Cod_Usuario_Destino, ISNULL(Visto_Gestor,'N') as Visto_Gestor, " 
			sql = sql & " Situacao, Prioridade, observacao "
			sql = sql & " FROM SCH_CHAMADO "
			sql = sql & " where Situacao not in ('F','E') "
			sql = sql & " union SELECT 2, Codigo, Cod_empresa, DataAbertura, DataAndamento, DataExecucao ,Ocorrencias,sequencia_desenvolvimento,replace(pedido_por,'|','<br>') as pedido_por,"
			sql = sql & " Cod_Usuario_Abertura, Cod_Usuario_Destino, ISNULL(Visto_Gestor,'N') as Visto_Gestor, " 
			sql = sql & " Situacao, Prioridade, observacao "
			sql = sql & " FROM SCH_CHAMADO "
			sql = sql & " where Situacao in ('E')  order by 1, sequencia_desenvolvimento, DataAndamento desc, codigo"
			
			'response.write sql
	
			rs.open sql, cnn
			cont=0
			if rs.eof = false then
			%>
			 <div class="panel panel-grey">
				<div class="panel-heading">
					<h3 class="panel-title"><i class="fa fa-tasks"></i> Situação Chamado </h3>
				</div>
				
				<table class="tabela" border="0">
					<thead>
						<tr>
							<th class="celula" width="1%" bgcolor="#95A5A6">N.</th>
							<th class="celula" width="5%" bgcolor="#95A5A6">Data</th>
							<th class="celula" width="5%" bgcolor="#95A5A6">Criado por</th>
							<th class="celula" width="5%" bgcolor="#95A5A6">Enc. para</th>
							<th class="celula" width="35%" bgcolor="#95A5A6">Ocorr&ecirc;ncia</th>
							<th class="celula" width="5%" bgcolor="#95A5A6">Pedido</th>
							<th class="celula" width="5%" bgcolor="#95A5A6">Seq.</th>
							<th class="celula" width="5%" bgcolor="#95A5A6">Prioridade</th>
							<th class="celula" width="5%" bgcolor="#95A5A6">Situação</th>
							<th class="celula" width="30%" bgcolor="#95A5A6">Parecer T&eacute;cnico</th>
							<th class="celula" width="5%" bgcolor="#95A5A6" align="center">Andamento</th>
							<th class="celula" width="5%" bgcolor="#95A5A6" align="center">Execução</th>
							<th class="celula" width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
						</tr>
					</thead>
					<%
					while not rs.eof
						cont = cont + 1	
						strcor = "#FFFFCC"

						if trim(RS("Prioridade")) = "A" then
							strPrioridade = "Alta"
						end if
						
						if trim(RS("Prioridade")) = "B" then
							strPrioridade = "Baixa"
						end if
						
						if trim(RS("Prioridade")) = "M" then
							strPrioridade = "Media"
						end if
						
						if trim(RS("Situacao")) = "A" then
							strSituacao = "Ativo"
						end if
						
						if trim(RS("Situacao")) = "F" then
							strSituacao = "Fechada"
						end if
						
						if trim(RS("Situacao")) = "P" then
							strSituacao = "Pendente"
							strcor = "#FFCAB0"
						end if
						
						if trim(RS("Situacao")) = "S" then
							strSituacao = "Suspença"
						end if
						
						if trim(RS("Situacao")) = "E" and trim(RS("Visto_Gestor")) = "S" then
							strSituacao = "Executada"
						end if
						
						
						if trim(RS("Situacao")) = "E" and trim(RS("Visto_Gestor")) = "S" then
							strcor = "#66FF66"
						end if	
						
						if trim(RS("Situacao")) = "E" and trim(RS("Visto_Gestor")) = "N" then
							strSituacao = "Verificação"
						end if
						
						if trim(RS("Situacao")) = "E" and trim(RS("Visto_Gestor")) = "N" then
							strcor = "#FFFF66"
						end if	
						%>
						<tr bgcolor="<%=strcor%>" >
							<td class="celula"><%=ZeroLeft(RS("Codigo"),3)%></td>
							<td class="celula"><%=formataDataAP(RS("DataAbertura"))%></td>
							<td class="celula"><%=replace(RS("Cod_Usuario_Abertura"),"FERNANDO.DOMINGOS","FERNANDO")%></td>
							<td class="celula"><%=replace(RS("Cod_Usuario_Destino"),"FERNANDO.DOMINGOS","FERNANDO")%></td>
							<td class="celula"><%=RS("Ocorrencias")%></td>
							<td class="celula"><%=RS("pedido_por")%>&nbsp;</td>
							<td class="celula" align="center"><font color="#0000FF"><strong><%=RS("sequencia_desenvolvimento")%></strong></font></td>
							<td class="celula"><%=strPrioridade%></td>
							<td class="celula"><%=strSituacao%></td>
							<td class="celula"><%=RS("observacao")%></td>
							<td class="celula" align="center" >&nbsp;<%=RS("DataAndamento")%></td>
							<td class="celula" align="center" >&nbsp;<%=RS("DataExecucao")%></td>
							<td class="celula" align="center" ><button class="btn-u btn-u-sea" onClick="FechamentoChamando(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button></td> 
						</tr>
						<%				
						rs.movenext
						wend
					%>
				</table>
				
			</div>
	<%
		end if
		rs.close
	END IF
	%>
<script>
	function FechamentoChamando(CodChamado){
		window.open("FechamentoChamado_cad.asp?CodChamado="+CodChamado,"consulta", "top=0,left=0,height=550,width=600,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
</script>
