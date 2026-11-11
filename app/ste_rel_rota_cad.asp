<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="ste_configurar_aluno.asp">
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
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Rota</label>
									<!--#include file="includes/inc_cmdRota.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Turno</label>
									<!--#include file="includes/inc_cmdTurno.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Carregar endereço do aluno</label>
									 
									<select name="cmbEnderecoAluno" class="form-control" id="cmbEnderecoAluno"  >
									  <option value="S" <%if strSexo = "S" then response.Write("selected") %>>Sim</option>
									  <option value="N" <%if strSexo = "N" then response.Write("selected") %>>Não</option>
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