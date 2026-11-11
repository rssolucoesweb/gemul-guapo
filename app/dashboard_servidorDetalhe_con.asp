<!-- the #js-page-content id is needed for some plugins to initialize -->
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
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>
	<%qtdeAnosCombo=0%>
	<!--#include file="dashboard_inc_filtro.asp" -->
	<input name="txtTipoEmpresa" id="txtTipoEmpresa" type="hidden" value="<%=intCodTipoEmpresa%>">
	<input name="txtEmpresa" 	id="txtEmpresa" 	 type="hidden" value="<%=intCodEmpresaGrupo%>">
	<input name="txtCategoria" id="txtCategoria" 	 type="hidden" value="<%=strCategoria%>">						
	<div class="row">
		<div class="col-xl-4">
			<div id="divMatriculados" class="panel" style="background-color: lightgreen;">
				<div class="panel-hdr">
					<h2>
						Total de <%=strFiltroDesc%> <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde" id="total">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> <%=strFiltroDesc%> </span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-4">
			<div id="divEdInfantil" class="panel">
				<div class="panel-hdr">
					<h2>
						Concursados <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde" id="totalConcursados">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> Concursados</span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-4">
			<div id="divEF" class="panel">
				<div class="panel-hdr">
					<h2>
						Não Concursados <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde" id="totalNaoConcursados">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> Não concursados</span>
					</div>
				</div>
			</div>
		</div>	
				
	</div>


	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Não concursados por vinculo <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<canvas id="porVinculo"></canvas>
					</div>
				</div>
			</div>
		</div>
	</div>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>