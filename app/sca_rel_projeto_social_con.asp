<%
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")

	intCodProjetoSociais 	= Trim(Request.Form("cmbProjetoSociais"))
	strMesInicial			= Trim(Request.Form("txtMesInicial"))
	strMesFinal				= Trim(Request.Form("txtMesFinal"))
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_rel_projeto_socialCon.asp">
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
									<label class="form-label">Ano Letivo:</label>
									<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Projetos Sociais:</label>
									 <!--#include file="includes/inc_ProjetosSociais.asp" -->
								</div>
							</div>	
						</div>
							
						<div class="row">	
							
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Per&iacute;odo Mensal de Fr&ecirc;quencia Inicial:</label>
									 <select name="cmbMesInicial" id="cmbMesInicial" class="form-control" >
										<%
										For i = 1 to 12
										%>
											<option value="<%=i%>"><%=ucase(monthname(i))%></option>
										<%
										Next	
										%>
									</select>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Per&iacute;odo Mensal de Fr&ecirc;quencia Final:</label>
									<select name="cmbMesFinal" id="cmbMesFinal" class="form-control" >
										<%
										For i = 1 to 12
										%>
											<option value="<%=i%>"><%=ucase(monthname(i))%></option>
										<%
										Next	
										%>
									</select>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Ordem:</label>
									 <select name="cmbOrdem" class="form-control" id="cmbOrdem">
										<option value="alfabetica" >Alfabetica</option>
										<option value="Turma" >Turma</option>
									</select>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Situação do aluno:</label>
									  <!--#include file="includes/inc_cmdSituacaoAluno.asp" -->
								</div>
							</div>							
						</div>
						
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
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