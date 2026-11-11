<%
	acao = "I"
	strSituacaoBaixa = ""

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	if intCodigo = "" then intCodigo = Trim(Request.QueryString("cod"))

	strNumeroPatrimonio		= Trim(Request.Form("txtNumeroPatrimonio"))
	strDataBaixa			= Trim(Request.Form("txtDataBaixa"))
	strTipoBaixa			= Trim(Request.Form("cmbTipoBaixa"))
	strMotivo				= Trim(Request.Form("txtMotivo"))
	strNumeroProcesso		= Trim(Request.Form("txtNumeroProcesso"))
	strDocumentoReferencia	= Trim(Request.Form("txtDocumentoReferencia"))
	strObservacao			= Trim(Request.Form("txtObservacao"))

	strDescricaoBem = ""

	if trim(intCodigo) <> "" then
	
		sql = "SELECT b.codigo, p.numero_patrimonio, p.descricao as descricao_bem, b.data_baixa, b.tipo_baixa,"
		sql = sql & " b.motivo, b.numero_processo, b.documento_referencia, b.observacao, b.situacao"
		sql = sql & " FROM PAT_BAIXA b"
		sql = sql & " INNER JOIN PAT_PATRIMONIO p ON p.codigo = b.cod_patrimonio"
		sql = sql & " where b.codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			strNumeroPatrimonio		= rs("numero_patrimonio")
			strDescricaoBem			= rs("descricao_bem")
			if not isnull(rs("data_baixa")) then strDataBaixa = Year(rs("data_baixa")) & "-" & Right("0" & Month(rs("data_baixa")), 2) & "-" & Right("0" & Day(rs("data_baixa")), 2)
			strTipoBaixa			= rs("tipo_baixa")
			strMotivo				= rs("motivo")
			strNumeroProcesso		= rs("numero_processo")
			strDocumentoReferencia	= rs("documento_referencia")
			strObservacao			= rs("observacao")
			strSituacaoBaixa		= rs("situacao")
			
			acao 					= "AE"

		end if 
		rs.close
	end if 

	blnPodeEditar = (acao = "I") or (strSituacaoBaixa = "EM_ELABORACAO")
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
							if strSituacaoBaixa = "EM_ELABORACAO" then Response.Write "<span class='badge badge-warning'>Em Elaboração</span>"
							if strSituacaoBaixa = "EFETIVADA" then Response.Write "<span class='badge badge-success'>Efetivada</span>"
							if strSituacaoBaixa = "CANCELADA" then Response.Write "<span class='badge badge-danger'>Cancelada</span>"
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
										<label class="form-label">Tipo de Baixa</label>
										<select id="cmbTipoBaixa" name="cmbTipoBaixa" class="form-control" <%if not blnPodeEditar then Response.Write "disabled"%>>
											<option value="">Selecione...</option>
											<%
											arrTipo = Array("INSERVIVEL", "PERDA", "FURTO", "ROUBO", "DOACAO", "ALIENACAO", "DESCARTE", "SINISTRO", "OUTRO")
											arrTipoLabel = Array("Inservível", "Perda", "Furto", "Roubo", "Doação", "Alienação", "Descarte", "Sinistro", "Outro")
											for i = 0 to UBound(arrTipo)
												selecionado = ""
												if arrTipo(i) = strTipoBaixa then selecionado = "selected"
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
										<label class="form-label">Data da Baixa</label>
										<input type="date" id="txtDataBaixa" name="txtDataBaixa" class="form-control" value="<%=strDataBaixa%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="form-label">Nº do Processo</label>
										<input type="text" id="txtNumeroProcesso" name="txtNumeroProcesso" class="form-control" value="<%=strNumeroProcesso%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
									</div>
								</div>
							</div>

							<div class="form-group">
								<label class="form-label">Motivo</label>
								<textarea id="txtMotivo" name="txtMotivo" class="form-control" rows="2" <%if not blnPodeEditar then Response.Write "disabled"%>><%=strMotivo%></textarea>
							</div>

							<div class="form-group">
								<label class="form-label">Documento de Referência (opcional)</label>
								<input type="text" id="txtDocumentoReferencia" name="txtDocumentoReferencia" class="form-control" value="<%=strDocumentoReferencia%>" <%if not blnPodeEditar then Response.Write "disabled"%>>
								<small class="form-text text-muted">Número de laudo, boletim de ocorrência, termo de doação etc.</small>
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

						<%if acao = "AE" and strSituacaoBaixa = "EM_ELABORACAO" then%>
						<hr>
						<div class="frame-wrap">
							<button type="button" class="btn btn-success" onclick="return efetivarBaixa()">Efetivar Baixa</button>
							<button type="button" class="btn btn-danger" onclick="return cancelarBaixa()">Cancelar</button>
						</div>
						<div class="panel-tag">
							<span class="fw-300">⚠ Efetivar a baixa é irreversível: o bem será marcado como baixado e não poderá mais ser movimentado, transferido ou entrar em manutenção.</span>
						</div>
						<%end if%>

					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont = 0
	sql = "SELECT b.codigo, p.numero_patrimonio, p.descricao as descricao_bem, b.tipo_baixa, b.situacao, b.data_baixa"
	sql = sql & " FROM PAT_BAIXA b"
	sql = sql & " INNER JOIN PAT_PATRIMONIO p ON p.codigo = b.cod_patrimonio"
	sql = sql & " Order by b.codigo desc"

	rs.open sql, cnn

	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-8">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Baixas cadastradas</h2>
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
									<th><strong>Data</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								situacaoLabel = rs("situacao")
								if rs("situacao") = "EM_ELABORACAO" then situacaoLabel = "Em Elaboração"
								if rs("situacao") = "EFETIVADA" then situacaoLabel = "Efetivada"
								if rs("situacao") = "CANCELADA" then situacaoLabel = "Cancelada"
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("numero_patrimonio")%></td>
									<td height="20" class="celula"><%=trim(rs("descricao_bem"))%></td>
									<td height="20" class="celula"><%=rs("tipo_baixa")%></td>
									<td height="20" class="celula"><%=FormatDateTime(rs("data_baixa"), 2)%></td>
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
