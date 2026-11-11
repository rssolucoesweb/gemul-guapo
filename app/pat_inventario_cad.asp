<%
	acao = "I"
	strSituacaoInvent = ""

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	if intCodigo = "" then intCodigo = Trim(Request.QueryString("cod"))

	strNumeroInventario		= Trim(Request.Form("txtNumeroInventario"))
	intAnoReferencia		= Trim(Request.Form("txtAnoReferencia"))
	intCodEmpresa			= Trim(Request.Form("cmbEmpresa"))
	intCodLocal				= Trim(Request.Form("cmbLocal"))
	strDataInicio			= Trim(Request.Form("txtDataInicio"))
	intCodColaboradorResp	= Trim(Request.Form("cmbColaboradorResponsavel"))
	strObservacao			= Trim(Request.Form("txtObservacao"))
	
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT codigo, numero_inventario, ano_referencia, cod_empresa, cod_local, data_inicio,"
		sql = sql & " data_fim, cod_colaborador_responsavel, observacao, situacao"
		sql = sql & " FROM PAT_INVENTARIO"
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			strNumeroInventario		= rs("numero_inventario")
			intAnoReferencia		= rs("ano_referencia")
			intCodEmpresa			= rs("cod_empresa")
			intCodLocal				= rs("cod_local")
			if not isnull(rs("data_inicio")) then strDataInicio = Year(rs("data_inicio")) & "-" & Right("0" & Month(rs("data_inicio")), 2) & "-" & Right("0" & Day(rs("data_inicio")), 2)
			intCodColaboradorResp	= rs("cod_colaborador_responsavel")
			strObservacao			= rs("observacao")
			strSituacaoInvent		= rs("situacao")
			
			acao 					= "AE"

		end if 
		rs.close
	end if 

	blnPodeEditar = (acao = "I") or (strSituacaoInvent = "ABERTO")
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
		<div class="col-xl-8">
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
							if strSituacaoInvent = "ABERTO" then Response.Write "<span class='badge badge-secondary'>Aberto</span>"
							if strSituacaoInvent = "EM_ANDAMENTO" then Response.Write "<span class='badge badge-primary'>Em Andamento</span>"
							if strSituacaoInvent = "FINALIZADO" then Response.Write "<span class='badge badge-success'>Finalizado</span>"
							if strSituacaoInvent = "CANCELADO" then Response.Write "<span class='badge badge-danger'>Cancelado</span>"
							%>
						</div>
						<%end if%>

						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">

							<%if acao = "AE" then%>
							<div class="form-group">
								<label class="form-label">Número do Inventário</label>
								<input type="text" class="form-control" value="<%=strNumeroInventario%>" readonly>
							</div>
							<%else%>
							<div class="panel-tag">
								<span class="fw-300">O número do inventário será gerado automaticamente ao salvar.</span>
							</div>
							<%end if%>

							<div class="row">
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Ano de Referência</label>
										<input type="number" id="txtAnoReferencia" name="txtAnoReferencia" class="form-control" value="<%=intAnoReferencia%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Unidade (Sede/Escola)</label>
										<%
										strCmbId = "cmbEmpresa"
										strCmbName = "cmbEmpresa"
										strCmbSelecionado = intCodEmpresa
										strCmbAtributos = "onchange=""this.form.submit()""" : if not blnPodeEditar then strCmbAtributos = "disabled"
										%>
										<!--#include file="includes/inc_cmbEmpresaPat.asp"-->
									</div>
								</div>
								<div class="col-md-5">
									<div class="form-group">
										<label class="form-label">Local específico (opcional)</label>
										<%
										strCmbId = "cmbLocal"
										strCmbName = "cmbLocal"
										strCmbSelecionado = intCodLocal
										strCmbFiltroEmpresa = intCodEmpresa
										strCmbOpcaoVazia = "Toda a unidade"
										strCmbAtributos = "" : if not blnPodeEditar then strCmbAtributos = "disabled"
										%>
										<!--#include file="includes/inc_cmbLocalPat.asp"-->
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Data de Início</label>
										<input type="date" id="txtDataInicio" name="txtDataInicio" class="form-control" value="<%=strDataInicio%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-8">
									<div class="form-group">
										<label class="form-label">Responsável (opcional)</label>
										<%
										strCmbId = "cmbColaboradorResponsavel"
										strCmbName = "cmbColaboradorResponsavel"
										strCmbSelecionado = intCodColaboradorResp
										strCmbFiltroEmpresa = intCodEmpresa
										strCmbAtributos = "" : if not blnPodeEditar then strCmbAtributos = "disabled"
										%>
										<!--#include file="includes/inc_cmbColaboradorPat.asp"-->
									</div>
								</div>
							</div>

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

						<%if acao = "AE" then%>
						<hr>
						<%if strSituacaoInvent = "ABERTO" then%>
						<div class="frame-wrap">
							<button type="button" class="btn btn-primary" onclick="return gerarItens()">Gerar Itens do Inventário</button>
						</div>
						<div class="panel-tag">
							<span class="fw-300">Isso vai listar automaticamente todos os bens ativos da unidade (e local, se especificado) para conferência.</span>
						</div>
						<%elseif strSituacaoInvent = "EM_ANDAMENTO" then%>
						<%
						sql = "SELECT COUNT(*) as total, SUM(CASE WHEN status_conferencia = 'AGUARDANDO_CONFERENCIA' THEN 1 ELSE 0 END) as pendentes"
						sql = sql & " FROM PAT_INVENTARIO_ITEM WHERE cod_inventario = " & intCodigo
						rs.open sql, cnn
						intTotalItens = rs("total")
						intPendentes = rs("pendentes")
						rs.close
						%>
						<div class="panel-tag">
							<strong><%=intTotalItens%></strong> itens no total, <strong><%=intPendentes%></strong> aguardando conferência.
						</div>
						<div class="frame-wrap">
							<a href="pat_inventario_itens.asp?cod=<%=intCodigo%>" class="btn btn-primary">Conferir Itens</a>
							<button type="button" class="btn btn-success" onclick="return finalizarInventario(<%=intPendentes%>)">Finalizar Inventário</button>
							<button type="button" class="btn btn-danger" onclick="return cancelarInventario()">Cancelar</button>
						</div>
						<%end if%>
						<%end if%>

					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont = 0
	sql = "SELECT i.codigo, i.numero_inventario, i.ano_referencia, i.data_inicio, i.situacao,"
	sql = sql & " e.RAZAOSOCIAL as nome_empresa"
	sql = sql & " FROM PAT_INVENTARIO i"
	sql = sql & " INNER JOIN SEG_EMPRESA e ON e.CODIGO = i.cod_empresa"
	sql = sql & " Order by i.codigo desc"

	rs.open sql, cnn

	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-8">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Inventários cadastrados</h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag"><span class="fw-300">Para editar/conferir clique na linha abaixo.</span></div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>N&ordm;</strong></th>
									<th><strong>Ano</strong></th>
									<th><strong>Unidade</strong></th>
									<th><strong>In&iacute;cio</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								situacaoLabel = rs("situacao")
								if rs("situacao") = "ABERTO" then situacaoLabel = "Aberto"
								if rs("situacao") = "EM_ANDAMENTO" then situacaoLabel = "Em Andamento"
								if rs("situacao") = "FINALIZADO" then situacaoLabel = "Finalizado"
								if rs("situacao") = "CANCELADO" then situacaoLabel = "Cancelado"
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("numero_inventario")%></td>
									<td height="20" class="celula"><%=rs("ano_referencia")%></td>
									<td height="20" class="celula"><%=trim(rs("nome_empresa"))%></td>
									<td height="20" class="celula"><%=FormatDateTime(rs("data_inicio"), 2)%></td>
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
