<%
	acao = "I"
	strSituacaoManut = ""

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	if intCodigo = "" then intCodigo = Trim(Request.QueryString("cod"))

	strNumeroPatrimonio		= Trim(Request.Form("txtNumeroPatrimonio"))
	strNumeroOrdemServico	= Trim(Request.Form("txtNumeroOrdemServico"))
	strTipoManutencao		= Trim(Request.Form("cmbTipoManutencao"))
	strDataSolicitacao		= Trim(Request.Form("txtDataSolicitacao"))
	strDataEnvio			= Trim(Request.Form("txtDataEnvio"))
	strDataPrevistaRetorno	= Trim(Request.Form("txtDataPrevistaRetorno"))
	strDataRetorno			= Trim(Request.Form("txtDataRetorno"))
	strProblema				= Trim(Request.Form("txtProblema"))
	strServicoRealizado		= Trim(Request.Form("txtServicoRealizado"))
	strPrestadorNome		= Trim(Request.Form("txtPrestadorNome"))
	strNumeroOrcamento		= Trim(Request.Form("txtNumeroOrcamento"))
	strValorOrcamento		= Trim(Request.Form("txtValorOrcamento"))
	strValorServico			= Trim(Request.Form("txtValorServico"))
	strObservacao			= Trim(Request.Form("txtObservacao"))

	strDescricaoBem = ""

	if trim(intCodigo) <> "" then
	
		sql = "SELECT m.codigo, p.numero_patrimonio, p.descricao as descricao_bem, m.numero_ordem_servico,"
		sql = sql & " m.tipo_manutencao, m.data_solicitacao, m.data_envio, m.data_prevista_retorno, m.data_retorno,"
		sql = sql & " m.problema, m.servico_realizado, m.prestador_nome, m.numero_orcamento, m.valor_orcamento,"
		sql = sql & " m.valor_servico, m.observacao, m.situacao"
		sql = sql & " FROM PAT_MANUTENCAO m"
		sql = sql & " INNER JOIN PAT_PATRIMONIO p ON p.codigo = m.cod_patrimonio"
		sql = sql & " where m.codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			strNumeroPatrimonio		= rs("numero_patrimonio")
			strDescricaoBem			= rs("descricao_bem")
			strNumeroOrdemServico	= rs("numero_ordem_servico")
			strTipoManutencao		= rs("tipo_manutencao")
			if not isnull(rs("data_solicitacao")) then strDataSolicitacao = Year(rs("data_solicitacao")) & "-" & Right("0" & Month(rs("data_solicitacao")), 2) & "-" & Right("0" & Day(rs("data_solicitacao")), 2)
			if not isnull(rs("data_envio")) then strDataEnvio = Year(rs("data_envio")) & "-" & Right("0" & Month(rs("data_envio")), 2) & "-" & Right("0" & Day(rs("data_envio")), 2)
			if not isnull(rs("data_prevista_retorno")) then strDataPrevistaRetorno = Year(rs("data_prevista_retorno")) & "-" & Right("0" & Month(rs("data_prevista_retorno")), 2) & "-" & Right("0" & Day(rs("data_prevista_retorno")), 2)
			if not isnull(rs("data_retorno")) then strDataRetorno = Year(rs("data_retorno")) & "-" & Right("0" & Month(rs("data_retorno")), 2) & "-" & Right("0" & Day(rs("data_retorno")), 2)
			strProblema				= rs("problema")
			strServicoRealizado		= rs("servico_realizado")
			strPrestadorNome		= rs("prestador_nome")
			strNumeroOrcamento		= rs("numero_orcamento")
			strValorOrcamento		= rs("valor_orcamento")
			strValorServico			= rs("valor_servico")
			strObservacao			= rs("observacao")
			strSituacaoManut		= rs("situacao")
			
			acao 					= "AE"

		end if 
		rs.close
	end if 

	blnFinalizada = (strSituacaoManut = "CONCLUIDA") or (strSituacaoManut = "NAO_REPARAVEL") or (strSituacaoManut = "CANCELADA")
	blnPodeEditar = (acao = "I") or (not blnFinalizada)
%>

<main id="js-page-content" role="main" class="page-content">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></span></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small><%=descricao_pagina%></small>
		</h1>
	</div>
	<div class="row">
		<div class="col-xl-9">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2><%=pagina%> <span class="fw-300"><i></i></span></h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag"><%=mensagem_alerta_pagina%></div>
						<%end if%>

						<%if acao = "AE" then%>
						<div class="panel-tag">
							<strong>Situação: </strong>
							<%
							Select Case strSituacaoManut
								Case "AGUARDANDO_ORCAMENTO" Response.Write "<span class='badge badge-secondary'>Aguardando Orçamento</span>"
								Case "AGUARDANDO_AUTORIZACAO" Response.Write "<span class='badge badge-warning'>Aguardando Autorização</span>"
								Case "AUTORIZADA" Response.Write "<span class='badge badge-info'>Autorizada</span>"
								Case "EM_MANUTENCAO" Response.Write "<span class='badge badge-primary'>Em Manutenção</span>"
								Case "CONCLUIDA" Response.Write "<span class='badge badge-success'>Concluída</span>"
								Case "NAO_REPARAVEL" Response.Write "<span class='badge badge-dark'>Não Reparável</span>"
								Case "CANCELADA" Response.Write "<span class='badge badge-danger'>Cancelada</span>"
							End Select
							%>
						</div>
						<%end if%>

						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">

							<%if acao = "AE" then%>
							<div class="form-group">
								<label class="form-label">Bem Patrimonial</label>
								<input type="text" class="form-control" value="<%=strNumeroPatrimonio%> - <%=strDescricaoBem%>" readonly>
							</div>
							<%else%>
							<div class="form-group">
								<label class="form-label">Número do Patrimônio</label>
								<div class="input-group">
									<input type="text" id="txtNumeroPatrimonio" name="txtNumeroPatrimonio" class="form-control" value="<%=strNumeroPatrimonio%>">
									<div class="input-group-append">
										<button type="button" class="btn btn-primary" onclick="return abrirConsultaPatrimonio()"><i class="fal fa-search"></i></button>
									</div>
								</div>
							</div>
							<%end if%>

							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Tipo de Manutenção</label>
										<select id="cmbTipoManutencao" name="cmbTipoManutencao" class="form-control" <%if not blnPodeEditar then Response.Write "disabled"%>>
											<%
											arrTipo = Array("CORRETIVA", "PREVENTIVA", "OUTRA")
											arrTipoLabel = Array("Corretiva", "Preventiva", "Outra")
											for i = 0 to UBound(arrTipo)
												selecionado = ""
												if arrTipo(i) = strTipoManutencao then selecionado = "selected"
												if strTipoManutencao = "" and arrTipo(i) = "CORRETIVA" then selecionado = "selected"
												%>
												<option value="<%=arrTipo(i)%>" <%=selecionado%>><%=arrTipoLabel(i)%></option>
												<%
											next
											%>
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Nº Ordem de Serviço</label>
										<input type="text" id="txtNumeroOrdemServico" name="txtNumeroOrdemServico" class="form-control" value="<%=strNumeroOrdemServico%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Data da Solicitação</label>
										<input type="date" id="txtDataSolicitacao" name="txtDataSolicitacao" class="form-control" value="<%=strDataSolicitacao%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
							</div>

							<div class="form-group">
								<label class="form-label">Problema / Descrição do defeito</label>
								<textarea id="txtProblema" name="txtProblema" class="form-control" rows="2" <%if not blnPodeEditar then Response.Write "disabled"%>><%=strProblema%></textarea>
							</div>

							<%if acao = "AE" then%>
							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Prestador / Empresa</label>
										<input type="text" id="txtPrestadorNome" name="txtPrestadorNome" class="form-control" value="<%=strPrestadorNome%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Nº do Orçamento</label>
										<input type="text" id="txtNumeroOrcamento" name="txtNumeroOrcamento" class="form-control" value="<%=strNumeroOrcamento%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Valor do Orçamento</label>
										<input type="text" id="txtValorOrcamento" name="txtValorOrcamento" class="form-control" value="<%=strValorOrcamento%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Data de Envio</label>
										<input type="date" id="txtDataEnvio" name="txtDataEnvio" class="form-control" value="<%=strDataEnvio%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Previsão de Retorno</label>
										<input type="date" id="txtDataPrevistaRetorno" name="txtDataPrevistaRetorno" class="form-control" value="<%=strDataPrevistaRetorno%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Data de Retorno</label>
										<input type="date" id="txtDataRetorno" name="txtDataRetorno" class="form-control" value="<%=strDataRetorno%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Valor do Serviço</label>
										<input type="text" id="txtValorServico" name="txtValorServico" class="form-control" value="<%=strValorServico%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
							</div>

							<div class="form-group">
								<label class="form-label">Serviço Realizado</label>
								<textarea id="txtServicoRealizado" name="txtServicoRealizado" class="form-control" rows="2" <%if not blnPodeEditar then Response.Write "disabled"%>><%=strServicoRealizado%></textarea>
							</div>
							<%end if%>

							<div class="form-group">
								<label class="form-label">Observação</label>
								<textarea id="txtObservacao" name="txtObservacao" class="form-control" rows="2" <%if not blnPodeEditar then Response.Write "disabled"%>><%=strObservacao%></textarea>
							</div>

							<%if blnPodeEditar then%>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
							<%end if%>
						</form>

						<%if acao = "AE" and not blnFinalizada then%>
						<hr>
						<div class="frame-wrap">
							<%if strSituacaoManut = "AGUARDANDO_ORCAMENTO" then%>
								<button type="button" class="btn btn-warning" onclick="return avancarSituacao('AGUARDANDO_AUTORIZACAO', 'Registrar orçamento e enviar para autorização?')">Registrar Orçamento</button>
							<%elseif strSituacaoManut = "AGUARDANDO_AUTORIZACAO" then%>
								<button type="button" class="btn btn-info" onclick="return avancarSituacao('AUTORIZADA', 'Confirma a autorização deste serviço?')">Autorizar</button>
							<%elseif strSituacaoManut = "AUTORIZADA" then%>
								<button type="button" class="btn btn-primary" onclick="return avancarSituacao('EM_MANUTENCAO', 'Confirma o envio do bem para manutenção? A situação do patrimônio será atualizada.')">Enviar para Manutenção</button>
							<%elseif strSituacaoManut = "EM_MANUTENCAO" then%>
								<button type="button" class="btn btn-success" onclick="return avancarSituacao('CONCLUIDA', 'Confirma a conclusão da manutenção? A situação original do patrimônio será restaurada.')">Concluir Manutenção</button>
								<button type="button" class="btn btn-dark" onclick="return avancarSituacao('NAO_REPARAVEL', 'Confirma que o bem não é reparável? Considere providenciar a baixa em seguida.')">Marcar como Não Reparável</button>
							<%end if%>
							<button type="button" class="btn btn-danger" onclick="return cancelarManutencao()">Cancelar</button>
						</div>
						<%end if%>

					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont = 0
	sql = "SELECT m.codigo, p.numero_patrimonio, p.descricao as descricao_bem, m.tipo_manutencao, m.situacao, m.data_solicitacao"
	sql = sql & " FROM PAT_MANUTENCAO m"
	sql = sql & " INNER JOIN PAT_PATRIMONIO p ON p.codigo = m.cod_patrimonio"
	sql = sql & " Order by m.codigo desc"

	rs.open sql, cnn

	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-9">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Manutenções cadastradas</h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag"><span class="fw-300">Para editar clique na linha abaixo.</span></div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>N&ordm; Patrim&ocirc;nio</strong></th>
									<th><strong>Descri&ccedil;&atilde;o</strong></th>
									<th><strong>Tipo</strong></th>
									<th><strong>Data Solicita&ccedil;&atilde;o</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								situacaoLabel = rs("situacao")
								Select Case rs("situacao")
									Case "AGUARDANDO_ORCAMENTO" situacaoLabel = "Aguardando Orçamento"
									Case "AGUARDANDO_AUTORIZACAO" situacaoLabel = "Aguardando Autorização"
									Case "AUTORIZADA" situacaoLabel = "Autorizada"
									Case "EM_MANUTENCAO" situacaoLabel = "Em Manutenção"
									Case "CONCLUIDA" situacaoLabel = "Concluída"
									Case "NAO_REPARAVEL" situacaoLabel = "Não Reparável"
									Case "CANCELADA" situacaoLabel = "Cancelada"
								End Select
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("numero_patrimonio")%></td>
									<td height="20" class="celula"><%=trim(rs("descricao_bem"))%></td>
									<td height="20" class="celula"><%=rs("tipo_manutencao")%></td>
									<td height="20" class="celula"><%=FormatDateTime(rs("data_solicitacao"), 2)%></td>
									<td height="20" class="celula"><%=situacaoLabel%></td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="5" class="celula">Total Registros : <%=cont%></td>
									</tr>
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
	%>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
