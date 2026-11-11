<%
	Session("MatriculaInformatizada") =  "SIM"

	dinamico = "N"
	sql = "select PERIODO_DINAMICO, ano_matricula from MAT_configuracoes where cod_grupo=" & session("codGrupo")
	rs.open sql, cnn
	if not rs.eof then
		Session("MatriculaInformatizadaAnoEfetivacao")	= rs("ano_matricula") '***IMPORTANTE ANO DA MATRÍCULA DEVE SER INFORMADO NA TELA DE CONFIGURAÇÕES
	end if
	rs.close

	
	strCod_empresa 		= Session("CodEmpresa")

	intInscricao		= Trim(Request("txtInscricao"))
	strNomealuno 		= Trim(Request.Form("txtNomealuno"))
	strBotaoVoltaTelaAnterior = "N"
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_consultar_solicitacaoCon.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%> - <%=Session("MatriculaInformatizadaAnoEfetivacao")%>
			<small>
				<%=descricao_pagina%> 
			</small>
		</h1>
	</div>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-8" class="panel">
                <div class="panel-hdr">
					<h2>
						<%=pagina%> <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Inscrição:</label>
									<input name="txtInscricao" type="text" class="form-control" id="txtInscricao" value="<%=intInscricao%>" size="20" maxlength="10"  onKeyPress="return formataCampo(this, 2, 10)">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Nome Completo do Aluno:</label>
									<input name="txtNomealuno" type="text" class="form-control" id="txtNomealuno" value="<%=strNomealuno%>" maxlength="200">
								</div>
							</div>
						</div>
						
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_consulta_novo.asp" -->
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%
	cont =0
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	cont = 0
	
	if intInscricao="" and strNomealuno = "" then
	%>
		<div class="alerta info">
			<span class="icone">ℹ️</span>
			<span>Um dos filtros devem ser informado, o número da inscrição ou o nome completo do aluno!</span>
		</div>
	<%
	else
	
		mensagem_alerta_pagina = "Para cancelar a solicitação do aluno, clique no botão [Cancelar]."
		
		sql = "select r.codigo, r.inscricao, r.motivo_exc_cadastro, r.cod_aluno, r.data_hora_alocacao, r.data_exc_cadastro, p.cod_curso, e.NOME_ABREVIADO as unidade, r.cod_empresa_efetivado, r.data_efetivacao, r.data_hora_incl, r.nome, r.cpf, r.data_nascimento, r.mae, p.Descricao as periodo, t.Desc_Turno as turno, r.Celular, r.FoneMae, r.Contato, r.FonePai, tu.NomeTurma, tu.TurmaAluno"
		sql = sql & " from mat_reserva r"
		sql = sql & " left join SCA_TURMA tu on tu.Cod_Turma = r.cod_turma_efetivado"
		sql = sql & " left join seg_empresa e on e.codigo = r.cod_empresa_efetivado"
		sql = sql & " inner join sca_periodo p on p.Cod_Periodo = r.cod_periodo"
		sql = sql & " inner join sca_turno t on t.Cod_Turno = r.cod_turno"

		if intInscricao <> "" then
			sql = sql & " where  r.inscricao = " & intInscricao
		end if
		
		if strNomealuno <> "" then
			sql = sql & " And  r.nome COLLATE Latin1_General_CI_AI = '" & strNomealuno & "'"
		end if
		sql = sql & " order by r.nome"
		rs.open sql, cnn
		if rs.eof then
		%>
			<div class="alerta info">
				<span class="icone">ℹ️</span>
				<span>Não foi encontrado nenhum registro!</span>
			</div>
		<%
		else
		%>
		<div class="row">
			<div class="col-xl-12">
				<div id="panel-1" class="panel">
					<div class="panel-hdr">
						<h2>
							<%if intTipo = "1" then%>
							Lista para <%=pagina%>
							<%elseif intTipo = "2" then%>
							Lista dos alunos efetivados
							<%end if%>
						</h2>
						<div class="panel-toolbar">
							<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
							<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
						</div>
					</div>	
					<div class="panel-container show">
						<div class="panel-content">		
							<%if mensagem_alerta_pagina<>"" then%>
							<%if intTipo = "1" then%>
							<div class="panel-tag">
								<%=mensagem_alerta_pagina%>
							</div>
							<%end if%>
							<%end if%>					
							<div class="table-responsive-lg">
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										
										<th width="2%" ><strong>Insc.</strong></th>
										<th width="15%"><strong>Nome Aluno</strong></th>
										<th width="9%" ><strong>CPF</strong></th>
										<th width="4%" ><strong>Data Nasc.</strong></th>
										<th width="15%"><strong>M&atilde;e</strong></th>
										<th width="15%" ><strong>Unidade</strong></th>
										<th width="8%" ><strong>Período/Turno</strong></th>
										<th width="10%"><strong>Telefone</strong></th>
										<th width="10%"><strong>Situação</strong></th>
									  </tr>
									</thead>
									<tbody>
									
								  <%
										while not rs.eof
											cont = cont + 1
											TELEFONE = ""
											IF NOT ISNULL(rs("CONTATO")) THEN
												TELEFONE = rs("CONTATO")
											ELSEIF NOT ISNULL(rs("CELULAR")) THEN
												TELEFONE = rs("CELULAR")
											ELSEIF NOT ISNULL(rs("FoneMae")) THEN
												TELEFONE = rs("FoneMae")
											ELSEIF NOT ISNULL(rs("FonePai")) THEN
												TELEFONE = rs("FonePai")
											END IF		
											
											classeSituacao = "situacao-aguardando"										
											mostraBotao = "S"
											situacao = "Aguardando vaga"

											if not isnull(rs("cod_empresa_efetivado")) then
												situacao = "Contemplado<br>" & rs("data_hora_alocacao")
												classeSituacao = "situacao-cont"
											end if

											if not isnull(rs("cod_aluno")) then
												situacao = "Efetivado<br>" & rs("data_efetivacao")
												classeSituacao = "situacao-efet"
												mostraBotao = ""
											end if

											if not isnull(rs("data_exc_cadastro")) then
												situacao = "Cancelado<br>" & rs("data_exc_cadastro") & "<br>" & rs("motivo_exc_cadastro")
												classeSituacao = "situacao-canc"
												mostraBotao = ""
											end if
											
											intCodReserva = rs("codigo")
											intCodCurso = rs("cod_curso")

											%>
											  <tr onClick="return Confirmar('<%=rs("codigo")%>')"  style="cursor: pointer;">
												<td align="left"><%=rs("inscricao")%>&nbsp;</td>
												<td align="left"><%=rs("nome")%></td>
												<td align="left"><%=formataCPFAP(rs("cpf"))%></td>
												<td align="left"><%=formatadataAP(rs("data_nascimento"))%>&nbsp;</td>
												<td align="left"><%=rs("mae")%></td>
												<td align="left"><strong><%=rs("unidade")%></strong></td>
												<td align="left"><strong><%=rs("Periodo")%><br><%=rs("turno")%></strong></td>
												<td align="left"><%=TELEFONE%></td>
												<td align="left"><span class="<%=classeSituacao%>"><%=situacao%></span></td>
											  </tr>
											  <%
											  if intCodCurso = "1" then
											  %>
											  <tr>
												<td align="center" colspan="9">
													<table width="60%" class="table table-bordered table-hover m-0">
														<thead class="thead-themed">
														  <tr>
															<th><strong>Item</strong></th>
															<th><strong>Descrição</strong></th>
															<th><strong>Pontos</strong></th>
														  </tr>
														</thead>
														<tbody>
														<%	
														sql = "SELECT po.descricao, po.pontos, po.item"
														sql = sql & " FROM MAT_reserva R"
														sql = sql & " INNER JOIN mat_reserva_pontuacao rp on rp.cod_reserva  = r.codigo"
														sql = sql & " INNER JOIN mat_pontuacao po on po.codigo = rp.cod_pontuacao"
														sql = sql & " WHERE r.codigo = " & intCodReserva
														sql = sql & " order by po.item"
														rsAux.open sql, cnn
														if rsAux.eof = false then
															pontos = 0
															while not rsAux.eof
																pontos = pontos + rsAux("pontos")
																 %>
																 <tr>
																	<td><%=rsAux("item")%>&nbsp;</td>
																	<td><%=rsAux("descricao")%>&nbsp;</td>
																	<td><%=rsAux("pontos")%>&nbsp;</td>
																</tr>
																
																 <%
																 rsAux.movenext
															wend
														end if
														rsAux.close
														  
														  
														sql="set nocount on"
														sql=sql & " IF OBJECT_ID('tempdb..#tempPontuacao') IS NOT NULL DROP TABLE #tempPontuacao;"
														sql=sql & " IF OBJECT_ID('tempdb..#tempOrdemFila') IS NOT NULL DROP TABLE #tempOrdemFila;"
														
														'-- CALCULA A PONTUAÇÃO DOS NÃO EFETIVADOS DA ED. INFANTIL
														sql=sql & " SELECT distinct R.codigo, sum(po.pontos) as pontuacao_total"
														sql=sql & " into #tempPontuacao"
														sql=sql & " FROM MAT_reserva R"
														sql=sql & " INNER JOIN mat_reserva_pontuacao rp on rp.cod_reserva  = r.codigo"
														sql=sql & " INNER JOIN mat_pontuacao po on po.codigo = rp.cod_pontuacao"
														sql=sql & " inner join SCA_PERIODO pe on pe.Cod_Periodo = R.cod_periodo"
														sql=sql & " WHERE r.cod_empresa_efetivado is null"
														sql=sql & " and pe.Cod_Curso = 1"
														sql=sql & " group by R.codigo"
														
														'-- IDENTIFICA A ORDEM NA ESCOLA DA PRIMEIRA OPÇÃO
														sql=sql & " select r.codigo, r.cod_empresa_opcao1, r.cod_periodo, t.pontuacao_total, r.data_hora_incl,"
														sql=sql & " 	ROW_NUMBER() OVER ("
														sql=sql & " 		PARTITION BY r.cod_empresa_opcao1, r.cod_periodo"
														sql=sql & " 		ORDER BY t.pontuacao_total desc, r.cod_periodo, r.data_hora_incl"
														sql=sql & " 	) AS ordem"
														sql=sql & " into #tempOrdemFila"
														sql=sql & " from #tempPontuacao t"
														sql=sql & " inner join MAT_reserva r on t.codigo = r.codigo"
														sql=sql & " order by r.cod_empresa_opcao1, pontuacao_total desc, r.cod_periodo, data_hora_incl "
														
														'-- CONSULTA A ORDEM DA INSCRIÇÃO
														sql=sql & " select * from #tempOrdemFila"
														sql=sql & " where codigo=" & intCodReserva
														rsAux.open sql, cnn
														if rsAux.eof = false then
															ordem = rsAux("ordem")
														end if
														rsAux.close														  
														%>
															<tr>
																<td  align="right" colspan="2"><STRONG>Total de pontos:&nbsp;</STRONG></td>
																<td  align="left"><STRONG><%=pontos%></STRONG></td>
															</tr>
															<tr>
																<td  align="right" colspan="2"><STRONG>Ordem na fila:&nbsp;</STRONG></td>
																<td  align="left"><STRONG><%=ordem%></STRONG></td>
															</tr>															
															</tbody>
														</table>
												</td>
											  </tr>
											  <%
											  end if
											  
											acao = "A"
											rs.movenext
										wend
										%>
									</tbody>
								</table>
								
							</div>
						</div>
					</div>
				</div>
			</div>
		</div> 
		<%
		end if
		rs.close
	end if		
	%>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>