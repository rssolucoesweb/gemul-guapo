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
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
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
						<!--div class="panel-tag">teste</div-->
						
                        <div class="row">
                            <div class="col-sm-4" style="font-size:40px ; text-align: center"><a href="dashboard_escolaCon.asp"><i class="subheader-icon fal fa-solid fa-school"></i><br>Escolas</a></div>
                            <div class="col-sm-4" style="font-size:40px ; text-align: center"><a href="dashboard_servidorCon.asp"><i class="subheader-icon fal fa-solid fa-user"></i><br>Servidores</a></div>
                            <div class="col-sm-4" style="font-size:40px ; text-align: center"><a href="dashboard_alunoCon.asp"><i class="subheader-icon fal fa-solid fa-user-graduate"></i><br>Alunos</a></div>
                        </div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>