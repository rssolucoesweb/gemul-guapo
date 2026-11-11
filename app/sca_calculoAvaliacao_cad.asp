<%
	acao = "I"

	strExecutarSubmitTipoCriterio 	= "S"
	strExecutarSubmitTipoCalculo = "S"
	strExecutarSubmitCurso 	= "S"
	
	strAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo 			= "" then strAnoLetivo = session("strAnoLetivo")
	intCodigo 					= Trim(Request.Form("txtCodigo"))
	intCodCriterioAvaliacao		= Trim(Request("cmbCriterioAvaliacao"))
	intCodCalculo				= Trim(Request("cmbCalculo"))

	strDescricao 	= Trim(Request.Form("txtDescricao"))
	strPosicao	 	= Trim(Request.Form("cmbPosicao"))
	
	strSigla		= Trim(Request.Form("txtSigla"))
	intCodTipoLancamento		= Trim(Request.Form("cmbTipoLancamento"))
	strFormula		= Trim(Request.Form("txtFormula"))
	strDigitar		= Trim(Request.Form("txtDigitar"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " from SCA_CALCULO_AVALIACAO "
		sql = sql & " Where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then	
			strDescricao			= rs("descricao")
			strSigla				= rs("sigla")
			intCodTipoLancamento	= rs("cod_tipo_lancamento")
			intCodCriterioAvaliacao	= rs("cod_criterio_avaliacao")
			intCodCalculo			= rs("cod_calculo")
			strPosicao				= rs("posicao")
			strFormula				= rs("formula")
			strDigitar				= trim(rs("digitar"))
			acao = "AE"
		end if 
		rs.close
	
	end if 
	
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<form id="frm" method="post" action="sca_calculoAvaliacao.asp">
		<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
		<ol class="breadcrumb page-breadcrumb">
			<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
			<li class="breadcrumb-item"><%=modulo%></li>
			<li class="breadcrumb-item active"><%=pagina%></li>
			<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
		</ol>
		<div class="subheader">
			<h1 class="subheader-title">
				<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
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
										<label class="form-label">Ano Letivo</label>
										<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,5)">
									</div>
								</div>								
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Critério de Avaliação</label>
										<!--#include file="includes/inc_cmdCriterioAvaliacao.asp" -->
									</div>
								</div>
								
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Avaliação</label>
										<!--#include file="includes/inc_cmdCalculo.asp" -->
									</div>
								</div>

							</div>
							<br>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Descrição</label>
										<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="50" maxlength="50" value="<%=strDescricao%>">
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Sigla</label>
										<input name="txtSigla" type="text" class="form-control" id="txtSigla" size="15" maxlength="10" value="<%=strSigla%>">
									</div>
								</div>
								
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Tipo lançamento</label>
										<!--#include file="includes/inc_cmdTipoLancamento.asp" -->
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Campo</label>
										<select name="cmbPosicao" class="form-control" id="cmbPosicao" >
											<%for i=1 to 25%>
											<option value="<%=i%>" <%if strPosicao = i then response.Write("selected") %>>C<%=i%></option>
											<%next%>
										</select>
									</div>
									
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Formula</label>
										<input name="txtFormula" type="text" class="form-control" id="txtFormula" size="100" maxlength="200" value="<%=strFormula%>">
									</div>
								</div>
								
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Digitar</label>
										<select name="txtDigitar" class="form-control" id="txtDigitar">
											<option value="S" <%if trim(strDigitar) = "S" then response.Write("selected") %>>Sim</option>
											<option value="N" <%if trim(strDigitar) = "N" then response.Write("selected") %>>N&atilde;o</option>
										 </select>
									</div>
								</div>
							</div>
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
					
						</div>
					</div>
				</div>
			</div>
		</div>
		<%
		cont =0
		if intCodCriterioAvaliacao = "" then intCodCriterioAvaliacao = "0"

		if intCodCriterioAvaliacao<>"0" then

			cont =0
			sql = "select _ca.codigo, cal.descricao as avaliacao, _cri.descricao as criterio, _ca.posicao, _ca.descricao, _ca.sigla, _tc.cod_criterio, _ca.posicao, _lan.Descricao as tipo_lancamento, _ca.formula, _ca.digitar"
			sql = sql & " from SCA_CALCULO_AVALIACAO _ca"
			sql = sql & " inner join SCA_CRITERIO_AVALIACAO ci on ci.codigo = _ca.cod_criterio_avaliacao"
			sql = sql & " inner join SCA_TIPO_CALCULO _tc on _tc.codigo = ci.cod_tipo_calculo"
			sql = sql & " inner join SCA_CRITERIO _cri on _cri.codigo = _tc.cod_criterio"
			sql = sql & " inner join SCA_TIPO_LANCAMENTO _lan on _lan.codigo = _ca.cod_tipo_lancamento"
			sql = sql & " inner join SCA_CALCULO cal on cal.codigo = _ca.cod_calculo"
			sql = sql & " where _ca.cod_criterio_avaliacao = " & intCodCriterioAvaliacao
			sql = sql & " Order by cal.descricao, _ca.posicao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
		<div class="row">
			<div class="col-xl-12">
				<div id="panel-1" class="panel">
					<div class="panel-hdr">
						<h2>
							<%=pagina%> cadastradas
						</h2>
						<div class="panel-toolbar">
							<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
							<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
						</div>
					</div>	
					<div class="panel-container show">
						<div class="panel-content">					
							<div class="panel-tag">
								<span class="fw-300">Para editar clique na linha abaixo.</span>
							</div>
							<div class="table-responsive-lg">
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										<th><strong>Avaliação</strong></th>
										<th><strong>Descrição da Avaliação</strong></th>
										<th><strong>Sigla</strong></th>
										<th><strong>Tipo</strong></th>
										<th><strong>Campo</strong></th>
										<th><strong>F&oacute;rmula</strong></th>
										<th><strong>Digitar</strong></th>
									  </tr>
									</thead>
									<tbody>
										<%
										while not rs.eof
											cont = cont + 1	
											%>
											  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
												<td class="celula"><%=trim(rs("avaliacao"))%></td>
												<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
												<td height="20" class="celula"><%=trim(rs("sigla"))%></td>
												<td class="celula"><%=rs("tipo_lancamento")%></td>
												<td height="20" class="celula">C<%=trim(rs("posicao"))%></td>
												<td class="celula"><%=trim(rs("formula"))%>&nbsp;</td>
												<td class="celula" align="center"><%=trim(rs("digitar"))%>&nbsp;</td>
											  </tr>
											  <%				
											rs.movenext
										wend
										%>
										<tr>
											<td height="21" colspan="7" class="celula">Total Registros : <%=cont%></td>
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

		end if
		%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>