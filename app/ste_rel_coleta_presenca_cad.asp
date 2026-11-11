	<%
	strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	
	sql = "select ano_letivo from STE_configura_alunos "
	rs.open sql, cnn
	if rs.eof = false then
		strAnoLetivo = rs("ano_letivo")
											
	end if
	rs.close
	%>
<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="ste_rel_coleta_presensa.asp">
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
									<label class="form-label">Opções:</label>
									<select name="cmbOpcao" id="cmbOpcao" class="form-control" onchange="mostraOpcaoRel()">
										<option value="PERIODO">POR PERÍODO</option> 
										<option value="DATA">POR DATA</option> 
									</select>
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input readonly name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Rota</label>
									<!--#include file="includes/inc_cmdRota.asp" -->
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Turno</label>
									<!--#include file="includes/inc_cmbTurnoGeral.asp" -->
								</div>
							</div>
							<div class="col-sm-4" id="linha_data" style="display:none">
								<div class="form-group">
									<label class="form-label">Data:</label>
									<input name="txtDataLancamento" type="date" onblur="return validaDataSelecionada(this)" class="form-control" id="txtDataLancamento" size="11" maxlength="10" value="<%=strDataLancamentoDate%>" >
								</div>
							</div>
							<div class="col-sm-2" id="linha_periodoI">
								<div class="form-group">
									<label class="form-label">Data inicial:</label>
									<input name="txtDataLancamentoI" type="date" onblur="return validaDataSelecionada(this)" class="form-control" id="txtDataLancamentoI" size="11" maxlength="10" value="<%=strDataLancamentoIDate%>" >
								</div>
							</div>
							<div class="col-sm-2" id="linha_periodoF">
								<div class="form-group">
									<label class="form-label">Data final:</label>
									<input name="txtDataLancamentoF" type="date" onblur="return validaDataSelecionada(this)" class="form-control" id="txtDataLancamentoF" size="11" maxlength="10" value="<%=strDataLancamentoFDate%>" >
								</div>
							</div>
						</div>	
						<br>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Qual Rede?</label>
									<select class="form-control" id="rede" name="rede" onchange="mostraUnidade()">
										<option value="0">Todas...</option>
										<option value="M">MUNICIPAL</option>
										<option value="E">ESTADUAL</option>
									</select>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Listar?</label>
									<select class="form-control" id="listar" name="listar" >
										<option value="0">Todos...</option>
										<option value="C">COM PRESENÇA</option>
										<option value="S">SEM PRESENÇA</option>
									</select>
								</div>
							</div>
						</div>
						<br>
						<div class="row" id="linha_municipal" style="display: none">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Unidade</label>
									<!--#include file="includes/inc_cmbEmpresas.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row" id="linha_estadual" style="display: none">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Unidade</label>
									<!--#include file="includes/inc_cmbEscolaEstadual.asp" -->
								</div>
							</div>
						</div>

						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp"-->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>