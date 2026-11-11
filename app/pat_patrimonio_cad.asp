<%
	acao = "I"

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strNumeroPatrimonio		= Trim(Request.Form("txtNumeroPatrimonio"))
	strCodigoOrigem			= Trim(Request.Form("txtCodigoOrigem"))
	intCodEmpresa			= Trim(Request.Form("cmbEmpresa"))
	intCodLocal				= Trim(Request.Form("cmbLocal"))
	intCodColaborador		= Trim(Request.Form("cmbColaborador"))
	intCodCategoriaFiltro	= Trim(Request.Form("cmbCategoriaFiltro"))
	intCodTipoBem			= Trim(Request.Form("cmbTipoBem"))
	intCodSituacao			= Trim(Request.Form("cmbSituacao"))
	intCodEstadoConservacao	= Trim(Request.Form("cmbEstadoConservacao"))
	strDescricao			= Trim(Request.Form("txtDescricao"))
	strMarca				= Trim(Request.Form("txtMarca"))
	strModelo				= Trim(Request.Form("txtModelo"))
	strNumeroSerie			= Trim(Request.Form("txtNumeroSerie"))
	intQuantidade			= Trim(Request.Form("txtQuantidade"))
	strNumerosSerieLote		= Trim(Request.Form("txtNumerosSerieLote"))
	strCodigoBarras			= Trim(Request.Form("txtCodigoBarras"))
	strDataAquisicao		= Trim(Request.Form("txtDataAquisicao"))
	strNumeroNotaFiscal		= Trim(Request.Form("txtNumeroNotaFiscal"))
	strFornecedorNome		= Trim(Request.Form("txtFornecedorNome"))
	strValorAquisicao		= Trim(Request.Form("txtValorAquisicao"))
	strObservacao			= Trim(Request.Form("txtObservacao"))
	
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT codigo, numero_patrimonio, codigo_origem, cod_empresa, cod_local, cod_colaborador,"
		sql = sql & " cod_tipo_bem, cod_situacao, cod_estado_conservacao, descricao, marca, modelo,"
		sql = sql & " numero_serie, codigo_barras, data_aquisicao, numero_nota_fiscal, fornecedor_nome,"
		sql = sql & " valor_aquisicao, observacao"
		sql = sql & " FROM PAT_PATRIMONIO"
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			strNumeroPatrimonio		= rs("numero_patrimonio")
			strCodigoOrigem			= rs("codigo_origem")
			intCodEmpresa			= rs("cod_empresa")
			intCodLocal				= rs("cod_local")
			intCodColaborador		= rs("cod_colaborador")
			intCodTipoBem			= rs("cod_tipo_bem")
			intCodSituacao			= rs("cod_situacao")
			intCodEstadoConservacao	= rs("cod_estado_conservacao")
			strDescricao			= rs("descricao")
			strMarca				= rs("marca")
			strModelo				= rs("modelo")
			strNumeroSerie			= rs("numero_serie")
			strCodigoBarras			= rs("codigo_barras")
			if not isnull(rs("data_aquisicao")) then strDataAquisicao = Year(rs("data_aquisicao")) & "-" & Right("0" & Month(rs("data_aquisicao")), 2) & "-" & Right("0" & Day(rs("data_aquisicao")), 2)
			strNumeroNotaFiscal		= rs("numero_nota_fiscal")
			strFornecedorNome		= rs("fornecedor_nome")
			strValorAquisicao		= rs("valor_aquisicao")
			strObservacao			= rs("observacao")
			
			acao 					= "AE"

		end if 
		rs.close

		' Se o filtro de categoria ainda não veio do form (primeiro carregamento da edição),
		' descobre a categoria do tipo de bem atual pra pré-selecionar o combo de filtro
		if intCodCategoriaFiltro = "" and intCodTipoBem <> "" then
			sql = "SELECT cod_categoria FROM PAT_TIPO_BEM WHERE codigo = " & intCodTipoBem
			rs.open sql, cnn
			if rs.eof = false then intCodCategoriaFiltro = rs("cod_categoria")
			rs.close
		end if
	end if 
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
						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">

							<%if acao = "AE" then%>
							<div class="form-group">
								<label class="form-label">Número de Patrimônio</label>
								<input type="text" class="form-control" value="<%=strNumeroPatrimonio%>" readonly>
								<small><a href="etiqueta_patrimonio.asp?num=<%=strNumeroPatrimonio%>" target="_blank">
									<i class="fal fa-qrcode"></i> Gerar etiqueta com QR Code
								</a></small>
							</div>
							<%else%>
							<div class="panel-tag">
								<span class="fw-300">O número de patrimônio será gerado automaticamente ao salvar.</span>
							</div>

							<div class="row">
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Quantidade</label>
										<input type="number" id="txtQuantidade" name="txtQuantidade" class="form-control" value="<%if intQuantidade="" then Response.Write "1" else Response.Write intQuantidade%>" min="1">
										<small class="form-text text-muted">Um registro de patrimônio será gerado para cada unidade.</small>
									</div>
								</div>
								<div class="col-md-9">
									<div class="form-group">
										<label class="form-label">Números de Série (opcional, um por linha)</label>
										<textarea id="txtNumerosSerieLote" name="txtNumerosSerieLote" class="form-control" rows="3" placeholder="Só preencher se a Quantidade for maior que 1 e cada unidade tiver um número de série diferente. Deixe em branco se não aplicável (ex: mesas, cadeiras)."><%=strNumerosSerieLote%></textarea>
										<small class="form-text text-muted">Se preenchido, a quantidade de linhas deve ser igual à Quantidade informada. Nesse caso, o campo "Número de série" abaixo é ignorado.</small>
									</div>
								</div>
							</div>
							<%end if%>

							<div class="row">
								<div class="col-md-9">
									<div class="form-group">
										<label class="form-label">Descrição</label>
										<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>">
									</div>
								</div>
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Código de Barras</label>
										<input type="text" id="txtCodigoBarras" name="txtCodigoBarras" class="form-control" value="<%=strCodigoBarras%>">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6">
									<div class="form-group">
										<label class="form-label">Categoria (filtro)</label>
										<%
										strCmbId = "cmbCategoriaFiltro"
										strCmbName = "cmbCategoriaFiltro"
										strCmbSelecionado = intCodCategoriaFiltro
										strCmbAtributos = "onchange=""this.form.submit()"""
										%>
										<!--#include file="includes/inc_cmbCategoriaPat.asp"-->
										<small class="form-text text-muted">Selecione a categoria pra filtrar o Tipo de Bem abaixo.</small>
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label class="form-label">Tipo de Bem</label>
										<%
										strCmbId = "cmbTipoBem"
										strCmbName = "cmbTipoBem"
										strCmbSelecionado = intCodTipoBem
										strCmbFiltroCategoria = intCodCategoriaFiltro
										strCmbAtributos = ""
										%>
										<!--#include file="includes/inc_cmbTipoBemPat.asp"-->
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6">
									<div class="form-group">
										<label class="form-label">Unidade (Sede/Escola)</label>
										<%
										strCmbId = "cmbEmpresa"
										strCmbName = "cmbEmpresa"
										strCmbSelecionado = intCodEmpresa
										strCmbAtributos = "onchange=""this.form.submit()"""
										%>
										<!--#include file="includes/inc_cmbEmpresaPat.asp"-->
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label class="form-label">Local</label>
										<%
										strCmbId = "cmbLocal"
										strCmbName = "cmbLocal"
										strCmbSelecionado = intCodLocal
										strCmbFiltroEmpresa = intCodEmpresa
										strCmbAtributos = ""
										strCmbOpcaoVazia = ""
										%>
										<!--#include file="includes/inc_cmbLocalPat.asp"-->
										<small class="form-text text-muted">Selecione a unidade primeiro para carregar os locais.</small>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Responsável (opcional)</label>
										<%
										strCmbId = "cmbColaborador"
										strCmbName = "cmbColaborador"
										strCmbSelecionado = intCodColaborador
										strCmbFiltroEmpresa = intCodEmpresa
										strCmbAtributos = ""
										%>
										<!--#include file="includes/inc_cmbColaboradorPat.asp"-->
										<small class="form-text text-muted">Selecione a unidade primeiro para carregar os colaboradores lotados nela.</small>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Situação do Bem</label>
										<%
										strCmbId = "cmbSituacao"
										strCmbName = "cmbSituacao"
										strCmbSelecionado = intCodSituacao
										strCmbAtributos = ""
										%>
										<!--#include file="includes/inc_cmbSituacaoPat.asp"-->
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Estado de Conservação</label>
										<%
										strCmbId = "cmbEstadoConservacao"
										strCmbName = "cmbEstadoConservacao"
										strCmbSelecionado = intCodEstadoConservacao
										strCmbAtributos = ""
										%>
										<!--#include file="includes/inc_cmbEstadoConservacaoPat.asp"-->
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Marca</label>
										<input type="text" id="txtMarca" name="txtMarca" class="form-control" value="<%=strMarca%>">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Modelo</label>
										<input type="text" id="txtModelo" name="txtModelo" class="form-control" value="<%=strModelo%>">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Número de série</label>
										<input type="text" id="txtNumeroSerie" name="txtNumeroSerie" class="form-control" value="<%=strNumeroSerie%>">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Data de Aquisição</label>
										<input type="date" id="txtDataAquisicao" name="txtDataAquisicao" class="form-control" value="<%=strDataAquisicao%>">
									</div>
								</div>
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Nota Fiscal</label>
										<input type="text" id="txtNumeroNotaFiscal" name="txtNumeroNotaFiscal" class="form-control" value="<%=strNumeroNotaFiscal%>">
									</div>
								</div>
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Fornecedor</label>
										<input type="text" id="txtFornecedorNome" name="txtFornecedorNome" class="form-control" value="<%=strFornecedorNome%>">
									</div>
								</div>
								<div class="col-md-3">
									<div class="form-group">
										<label class="form-label">Valor de Aquisição</label>
										<input type="text" id="txtValorAquisicao" name="txtValorAquisicao" class="form-control" value="<%=strValorAquisicao%>">
									</div>
								</div>
							</div>

							<div class="form-group">
								<label class="form-label">Código de Origem (opcional)</label>
								<input type="text" id="txtCodigoOrigem" name="txtCodigoOrigem" class="form-control" value="<%=strCodigoOrigem%>">
								<small class="form-text text-muted">Só preencher se este bem vier de uma migração de dados existente.</small>
							</div>

							<div class="form-group">
								<label class="form-label">Observação</label>
								<textarea id="txtObservacao" name="txtObservacao" class="form-control" rows="3"><%=strObservacao%></textarea>
							</div>

							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont = 0
	sql = "SELECT p.codigo, p.numero_patrimonio, p.descricao, s.descricao as descricao_situacao, e.RAZAOSOCIAL as nome_empresa"
	sql = sql & " FROM PAT_PATRIMONIO p"
	sql = sql & " INNER JOIN SEG_EMPRESA e ON e.CODIGO = p.cod_empresa"
	sql = sql & " INNER JOIN PAT_SITUACAO s ON s.codigo = p.cod_situacao"
	sql = sql & " Order by p.codigo desc"

	rs.open sql, cnn

	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-10">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>Bens cadastrados</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
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
									<th><strong>Unidade</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("numero_patrimonio")%></td>
									<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
									<td height="20" class="celula"><%=trim(rs("nome_empresa"))%></td>
									<td height="20" class="celula"><%=trim(rs("descricao_situacao"))%></td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
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
