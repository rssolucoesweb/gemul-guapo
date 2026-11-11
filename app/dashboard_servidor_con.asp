<%

%>

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


	<div class="row">
		<div class="col-xl-4">
			<div id="divMatriculados" class="panel" style="background-color: lightgreen;">
				<div class="panel-hdr">
					<h2>
						Total de Servidores <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde" id="total">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> servidores</span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-4">
			<div id="divEdInfantil" class="panel">
				<div class="panel-hdr">
					<h2>
						Professores <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<a style="cursor:pointer" onclick="servidorFuncao('P')" >
							<span class="qtde" id="totalProfessor">0</span>
						</a>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> professores</span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-4">
			<div id="divEF" class="panel">
				<div class="panel-hdr">
					<h2>
						Administrativo <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<a style="cursor:pointer"  onclick="servidorFuncao('A')" >
							<span class="qtde" id="totalAdministrativo">0</span>
						</a>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> administrativo</span>
					</div>
				</div>
			</div>
		</div>	
				
	</div>


	<div class="row">
		<div class="col-xl-8">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Professores por cargo <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<!--div class="panel-tag">Quantidade de alunos por modalidade</div-->
						<canvas id="porCargo"></canvas>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-4">
			<div class="row">
				<div class="col-xl-12">
					<div id="panel-1" class="panel">
						<div class="panel-hdr">
							<h2>
								Diretor(a) <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<div class="panel-content panel-qtde">
								<span class="qtde" id="qtdeDiretor"></span>
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
								Secretário(a) <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<div class="panel-content panel-qtde">
								<span class="qtde" id="qtdeSecretario"></span>
							</div>
						</div>
					</div>
				</div>
			</div>	
					
		</div>
	</div>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>