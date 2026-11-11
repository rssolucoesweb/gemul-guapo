<%
	acao = "I"
	strSituacaoTransf = ""

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	if intCodigo = "" then intCodigo = Trim(Request.QueryString("cod"))

	strNumeroTransferencia	= Trim(Request.Form("txtNumeroTransferencia"))
	strDataTransferencia	= Trim(Request.Form("txtDataTransferencia"))
	intCodEmpresaOrigem	= Trim(Request.Form("cmbEmpresaOrigem"))
	intCodEmpresaDestino	= Trim(Request.Form("cmbEmpresaDestino"))
	intCodLocalDestino		= Trim(Request.Form("cmbLocalDestino"))
	intCodColaboradorDestino = Trim(Request.Form("cmbColaboradorDestino"))
	strMotivo				= Trim(Request.Form("txtMotivo"))
	strObservacao			= Trim(Request.Form("txtObservacao"))
	
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT codigo, numero_transferencia, data_transferencia, cod_empresa_origem, cod_empresa_destino,"
		sql = sql & " cod_local_destino, cod_colaborador_destino, motivo, observacao, situacao"
		sql = sql & " FROM PAT_TRANSFERENCIA"
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 				= rs("codigo")
			strNumeroTransferencia		= rs("numero_transferencia")
			if not isnull(rs("data_transferencia")) then strDataTransferencia = Year(rs("data_transferencia")) & "-" & Right("0" & Month(rs("data_transferencia")), 2) & "-" & Right("0" & Day(rs("data_transferencia")), 2)
			intCodEmpresaOrigem		= rs("cod_empresa_origem")
			intCodEmpresaDestino		= rs("cod_empresa_destino")
			intCodLocalDestino			= rs("cod_local_destino")
			intCodColaboradorDestino	= rs("cod_colaborador_destino")
			strMotivo					= rs("motivo")
			strObservacao				= rs("observacao")
			strSituacaoTransf			= rs("situacao")
			
			acao 					= "AE"

		end if 
		rs.close
	end if 

	blnPodeEditar = (acao = "I") or (strSituacaoTransf = "EM_ELABORACAO")
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
		<div class="col-xl-10">
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
							if strSituacaoTransf = "EM_ELABORACAO" then Response.Write "<span class='badge badge-warning'>Em Elaboração</span>"
							if strSituacaoTransf = "CONCLUIDA" then Response.Write "<span class='badge badge-success'>Concluída</span>"
							if strSituacaoTransf = "CANCELADA" then Response.Write "<span class='badge badge-danger'>Cancelada</span>"
							%>
						</div>
						<%end if%>

						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">

							<%if acao = "AE" then%>
							<div class="form-group">
								<label class="form-label">Número da Transferência</label>
								<input type="text" class="form-control" value="<%=strNumeroTransferencia%>" readonly>
							</div>
							<%else%>
							<div class="panel-tag">
								<span class="fw-300">O número da transferência será gerado automaticamente ao salvar.</span>
							</div>
							<%end if%>

							<div class="row">
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Data</label>
										<input type="date" id="txtDataTransferencia" name="txtDataTransferencia" class="form-control" value="<%=strDataTransferencia%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Unidade de Origem</label>
										<%
										strCmbId = "cmbEmpresaOrigem"
										strCmbName = "cmbEmpresaOrigem"
										strCmbSelecionado = intCodEmpresaOrigem
										strCmbAtributos = "" : if not blnPodeEditar then strCmbAtributos = "disabled"
										%>
										<!--#include file="includes/inc_cmbEmpresaPat.asp"-->
									</div>
								</div>
								<div class="col-md-5">
									<div class="form-group">
										<label class="form-label">Unidade de Destino</label>
										<%
										strCmbId = "cmbEmpresaDestino"
										strCmbName = "cmbEmpresaDestino"
										strCmbSelecionado = intCodEmpresaDestino
										strCmbAtributos = "onchange=""this.form.submit()""" : if not blnPodeEditar then strCmbAtributos = "disabled"
										%>
										<!--#include file="includes/inc_cmbEmpresaPat.asp"-->
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6">
									<div class="form-group">
										<label class="form-label">Local de Destino (opcional)</label>
										<%
										strCmbId = "cmbLocalDestino"
										strCmbName = "cmbLocalDestino"
										strCmbSelecionado = intCodLocalDestino
										strCmbFiltroEmpresa = intCodEmpresaDestino
										strCmbOpcaoVazia = "Não especificado"
										strCmbAtributos = "" : if not blnPodeEditar then strCmbAtributos = "disabled"
										%>
										<!--#include file="includes/inc_cmbLocalPat.asp"-->
										<small class="form-text text-muted">Selecione a unidade de destino primeiro. Se não escolher local aqui, cada item pode manter o local original ou ser ajustado depois.</small>
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label class="form-label">Responsável de Destino (opcional)</label>
										<%
										strCmbId = "cmbColaboradorDestino"
										strCmbName = "cmbColaboradorDestino"
										strCmbSelecionado = intCodColaboradorDestino
										strCmbFiltroEmpresa = intCodEmpresaDestino
										strCmbAtributos = "" : if not blnPodeEditar then strCmbAtributos = "disabled"
										%>
										<!--#include file="includes/inc_cmbColaboradorPat.asp"-->
									</div>
								</div>
							</div>

							<div class="form-group">
								<label class="form-label">Motivo</label>
								<input type="text" id="txtMotivo" name="txtMotivo" class="form-control" value="<%=strMotivo%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
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
					</div>
				</div>
			</div>
		</div>
	</div>

	<%if acao = "AE" then%>
	<%
	' ------------------------------------------------------------
	' Painel de Itens da Transferência
	' ------------------------------------------------------------
	sql = "SELECT i.codigo, i.cod_patrimonio, p.numero_patrimonio, p.descricao,"
	sql = sql & " lo.descricao as local_origem, i.cod_movimentacao"
	sql = sql & " FROM PAT_TRANSFERENCIA_ITEM i"
	sql = sql & " INNER JOIN PAT_PATRIMONIO p ON p.codigo = i.cod_patrimonio"
	sql = sql & " LEFT JOIN PAT_LOCAL lo ON lo.codigo = i.cod_local_origem"
	sql = sql & " WHERE i.cod_transferencia = " & intCodigo
	sql = sql & " ORDER BY p.numero_patrimonio"

	rs.open sql, cnn
	%>
	<div class="row">
		<div class="col-xl-10">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Itens da Transferência</h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">

						<%if strSituacaoTransf = "EM_ELABORACAO" then%>
						<%
						sqlDisp = "SELECT p.codigo, p.numero_patrimonio, p.descricao, lo.descricao as local_origem"
						sqlDisp = sqlDisp & " FROM PAT_PATRIMONIO p"
						sqlDisp = sqlDisp & " INNER JOIN PAT_SITUACAO s ON s.codigo = p.cod_situacao"
						sqlDisp = sqlDisp & " LEFT JOIN PAT_LOCAL lo ON lo.codigo = p.cod_local"
						sqlDisp = sqlDisp & " WHERE p.cod_empresa = " & intCodEmpresaOrigem
						sqlDisp = sqlDisp & " AND s.indicador_baixado = 0"
						sqlDisp = sqlDisp & " AND p.codigo NOT IN (SELECT cod_patrimonio FROM PAT_TRANSFERENCIA_ITEM WHERE cod_transferencia = " & intCodigo & ")"
						sqlDisp = sqlDisp & " ORDER BY p.numero_patrimonio"
						Set rsDisp = Server.CreateObject("ADODB.Recordset")
						rsDisp.open sqlDisp, cnn
						%>
						<form id="frmSelecionados" name="frmSelecionados" method="post" action="pat_transferencia_itens_cod.asp?acao=AdicionarVarios">
							<input type="hidden" name="cod_transferencia" value="<%=intCodigo%>">

							<div class="row mb-2">
								<div class="col-md-6">
									<input type="text" id="txtFiltroLista" class="form-control" placeholder="Filtrar por número ou descrição..." onkeyup="filtrarListaBens()">
								</div>
								<div class="col-md-6 text-right">
									<button type="button" class="btn btn-primary" onclick="return adicionarSelecionados()">Adicionar Selecionados</button>
								</div>
							</div>

							<%if rsDisp.eof then%>
							<div class="panel-tag">
								<span class="fw-300">Não há bens disponíveis para transferência nesta unidade (ou todos já foram adicionados).</span>
							</div>
							<%else%>
							<div class="table-responsive-lg" style="max-height: 350px; overflow-y: auto;">
								<table class="table table-bordered table-hover m-0" id="tabelaBensDisponiveis">
									<thead class="thead-themed">
									  <tr>
										<th style="width:40px;"><input type="checkbox" onclick="marcarTodos(this)"></th>
										<th><strong>N&ordm; Patrim&ocirc;nio</strong></th>
										<th><strong>Descri&ccedil;&atilde;o</strong></th>
										<th><strong>Local Atual</strong></th>
									  </tr>
									</thead>
									<tbody>
									<%
									while not rsDisp.eof
										%>
										<tr>
											<td><input type="checkbox" name="chkBem" value="<%=rsDisp("codigo")%>"></td>
											<td><%=rsDisp("numero_patrimonio")%></td>
											<td><%=trim(rsDisp("descricao"))%></td>
											<td><%=trim(rsDisp("local_origem"))%></td>
										</tr>
										<%
										rsDisp.movenext
									wend
									%>
									</tbody>
								</table>
							</div>
							<%end if%>
							<%
							rsDisp.close
							Set rsDisp = Nothing
							%>
						</form>
						<hr>
						<%end if%>

						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>N&ordm; Patrim&ocirc;nio</strong></th>
									<th><strong>Descri&ccedil;&atilde;o</strong></th>
									<th><strong>Local de Origem</strong></th>
									<th><strong>Status</strong></th>
									<%if strSituacaoTransf = "EM_ELABORACAO" then%><th></th><%end if%>
								  </tr>
								</thead>
								<tbody>
							  <%
							contItem = 0
							while not rs.eof
								contItem = contItem + 1
								statusItem = "Pendente"
								if not isnull(rs("cod_movimentacao")) then statusItem = "Movimentado"
								%>
								  <tr>
									<td class="celula"><%=rs("numero_patrimonio")%></td>
									<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
									<td height="20" class="celula"><%=trim(rs("local_origem"))%></td>
									<td height="20" class="celula"><%=statusItem%></td>
									<%if strSituacaoTransf = "EM_ELABORACAO" then%>
									<td height="20" class="celula">
										<a href="javascript:void(0);" onclick="return removerItem('<%=rs("codigo")%>')">Remover</a>
									</td>
									<%end if%>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="5" class="celula">Total de Itens : <%=contItem%></td>
									</tr>
								</tbody>
							</table>
						</div>

						<%if strSituacaoTransf = "EM_ELABORACAO" and contItem > 0 then%>
						<div class="frame-wrap">
							<button type="button" class="btn btn-success" onclick="return concluirTransferencia()">Concluir Transferência</button>
							<button type="button" class="btn btn-danger" onclick="return cancelarTransferencia()">Cancelar Transferência</button>
						</div>
						<%elseif strSituacaoTransf = "EM_ELABORACAO" then%>
						<div class="frame-wrap">
							<button type="button" class="btn btn-danger" onclick="return cancelarTransferencia()">Cancelar Transferência</button>
						</div>
						<%end if%>

					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	rs.close
	%>
	<%end if%>

	<%
	cont = 0
	sql = "SELECT t.codigo, t.numero_transferencia, t.data_transferencia, t.situacao,"
	sql = sql & " eo.RAZAOSOCIAL as nome_origem, ed.RAZAOSOCIAL as nome_destino"
	sql = sql & " FROM PAT_TRANSFERENCIA t"
	sql = sql & " INNER JOIN SEG_EMPRESA eo ON eo.CODIGO = t.cod_empresa_origem"
	sql = sql & " INNER JOIN SEG_EMPRESA ed ON ed.CODIGO = t.cod_empresa_destino"
	sql = sql & " Order by t.codigo desc"

	rs.open sql, cnn

	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-10">
			<div id="panel-3" class="panel">
				<div class="panel-hdr">
					<h2>Transferências cadastradas</h2>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag"><span class="fw-300">Para editar/ver itens clique na linha abaixo.</span></div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>N&ordm;</strong></th>
									<th><strong>Data</strong></th>
									<th><strong>Origem</strong></th>
									<th><strong>Destino</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								situacaoLabel = rs("situacao")
								if rs("situacao") = "EM_ELABORACAO" then situacaoLabel = "Em Elaboração"
								if rs("situacao") = "CONCLUIDA" then situacaoLabel = "Concluída"
								if rs("situacao") = "CANCELADA" then situacaoLabel = "Cancelada"
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("numero_transferencia")%></td>
									<td height="20" class="celula"><%=FormatDateTime(rs("data_transferencia"), 2)%></td>
									<td height="20" class="celula"><%=trim(rs("nome_origem"))%></td>
									<td height="20" class="celula"><%=trim(rs("nome_destino"))%></td>
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
