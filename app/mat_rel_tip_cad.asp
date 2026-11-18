<%
	'Relatório de TIP - filtros (gera em mat_rel_tip_rel.asp)
	mostraSelecione			= ""
	strEmpresaGrupo_submit	= ""
	intCodEmpresaGrupo 		= Trim(Request("cmbEmpresaGrupo"))
	if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = Session("CodEmpresa")
	strAnoLetivo			= session("strAnoLetivo")	'ano letivo vem da sessão (Trocar Ano Letivo)
	strParticipacao			= Trim(Request("cmbParticipacao"))
	if strParticipacao = "" then strParticipacao = "A"
	strSituacaoFiltro		= Trim(Request("cmbSituacao"))

	strDesabilitaIncluir	= "disabled"
	strDesabilitaAlterar 	= "disabled"
	strDesabilitaExcluir	= "disabled"
	retira_incluir="S"
	acao = "A"
	strBotaoVoltaTelaAnterior = "N"
	anoDestino = ""
	if isnumeric(strAnoLetivo & "") and trim(strAnoLetivo & "") <> "" then anoDestino = clng(strAnoLetivo) + 1
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_rel_tip.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-exchange'></i> <%=pagina%>
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
						<div class="panel-tag">
							Lista as TIP do ano letivo <strong><%=strAnoLetivo%></strong> (selecionado no topo da tela): as <strong>solicitadas em <%=strAnoLetivo%></strong>
							e as em que o aluno vai para a nova escola em <strong><%=strAnoLetivo%></strong>. Em <strong>Unidade</strong>, escolha uma unidade
							ou <strong>Selecione...</strong> para todas as unidades às quais você tem acesso.
						</div>
						<div class="row">
							<div class="col-sm-1">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" readonly>
								</div>
							</div>
							<div class="col-sm-11">
								<div class="form-group">
									<label class="form-label">Unidade:</label>
									 <!--#include file="includes/inc_cmbEmpresaGrupo.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">A unidade como:</label>
									<select name="cmbParticipacao" id="cmbParticipacao" class="form-control">
										<option value="A" <%if strParticipacao = "A" then response.write "selected"%>>Origem ou destino</option>
										<option value="O" <%if strParticipacao = "O" then response.write "selected"%>>Origem (alunos que saem)</option>
										<option value="D" <%if strParticipacao = "D" then response.write "selected"%>>Destino (alunos que chegam)</option>
									</select>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Situação:</label>
									<select name="cmbSituacao" id="cmbSituacao" class="form-control">
										<option value="" <%if strSituacaoFiltro = "" then response.write "selected"%>>Todas</option>
										<option value="P" <%if strSituacaoFiltro = "P" then response.write "selected"%>>Aguardando efetivação</option>
										<option value="E" <%if strSituacaoFiltro = "E" then response.write "selected"%>>Efetivadas</option>
										<option value="C" <%if strSituacaoFiltro = "C" then response.write "selected"%>>Canceladas</option>
									</select>
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
