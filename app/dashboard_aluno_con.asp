<%
	strAnoLetivo = request("strAnoLetivo")
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
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

	<!--#include file="dashboard_inc_filtro.asp" -->

	<div class="row">
		<div class="col-xl-3 ">
			<div id="divMatriculados" class="panel" style="background-color: lightgreen;">
				<div class="panel-hdr">
					<h2>
						Matriculados <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde" id="total">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> alunos</span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-3">
			<div id="divEdInfantil" class="panel">
				<div class="panel-hdr">
					<h2>
						Educação Infantil <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<a style='cursor:pointer' onclick="alunoModalidade('EDUCAÇÃO INFANTIL')">
							<span class="qtde" id="totalEI">0</span>
						</a>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> alunos</span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-3">
			<div id="divEF" class="panel">
				<div class="panel-hdr">
					<h2>
						Ensino Fundamental <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<a style='cursor:pointer' onclick="alunoModalidade('ENSINO FUNDAMENTAL')">
							<span class="qtde" id="totalEF">0</span>
						</a>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> alunos</span>
					</div>
				</div>
			</div>
		</div>	

		<div class="col-xl-3">
			<div id="divEJA" class="panel">
				<div class="panel-hdr">
					<h2>
						EJA <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<a style='cursor:pointer' onclick="alunoModalidade('EJA')">
							<span class="qtde" id="totalEJA">0</span>
						</a>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> alunos</span>
					</div>
				</div>
			</div>
		</div>						
	</div>		

	<div class="row">
		<div class="col-xl-10">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Matriculados por mês <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="width:100%; height:300px; position:relative;">
						<!--div class="panel-tag">Quantidade de alunos por modalidade</div-->
						<canvas id="alunosPorMes" style="width:100%; height: 100%"></canvas>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-2">
			<div class="row">
				<div class="col-xl-12">
					<div id="panel-1" class="panel">
						<div class="panel-hdr">
							<h2>
								Alunos por Turno <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<div class="panel-content" style="width:100%; height:300px; position:relative;">
								<canvas id="alunosPorTurno" style="width:100%; height: 100%"></canvas>
							</div>
						</div>
					</div>
				</div>
			</div>
<!--			<div class="row">
				<div class="col-xl-12">
					<div id="panel-1" class="panel">
						<div class="panel-hdr">
							<h2>
								Alunos Atend. Especializado <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<div class="panel-content panel-qtde">
								<span class="qtde" id="qtdeAtendEsp"></span>
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
								Necessidades Especiais <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<div class="panel-content panel-qtde">
								<span class="qtde" id="qtdeDeficiencia"></span>
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
								Alunos Transporte Escolar <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<div class="panel-content panel-qtde">
								<span class="qtde" id="qtdeTransporte"></span>
							</div>
						</div>
					</div>
				</div>
			</div>	-->		
		</div>
	</div>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>