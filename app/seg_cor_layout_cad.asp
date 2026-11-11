<%
	intCodigo	 			= Session("CodGrupo")	
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT cor_layout"
		sql = sql & " FROM SEG_GRUPO"
		sql = sql & " where CODIGO = " & Session("CodGrupo")			
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= Session("CodGrupo")
			strCorLayout			= rs("cor_layout")
			
		end if 
		rs.close
	end if 
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
		<div class="col-xl-8">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> disponíveis
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">					
						<div class="panel-tag">
							<span class="fw-300">Para alterar clique na cor abaixo.</span>
						</div>
						<div>
						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<input name="txtLayout" type="hidden" id="txtLayout" value="<%=strCorLayout%>">							
							<div class="modal-body p-0">
								<div class="settings-panel">
									
									<hr class="mb-0 mt-4">
									<div class="mt-4 d-table w-100 pl-5 pr-3">
										<div class="d-table-cell align-middle">
											<h5 class="p-0 pr-2 d-flex">
												Cores 
												<a href="#" class="ml-auto fw-400 fs-xs" data-toggle="popover" data-trigger="focus" data-placement="top" title="" data-html="true" data-content="Escolha seu tema preferido e altere todo o layout com um só click." data-original-title="<span class='text-primary'><i class='fal fa-exclamation-triangle mr-1'></i> Informativo GEMUL!</span>" data-template="<div class=&quot;popover bg-white border-white&quot; role=&quot;tooltip&quot;><div class=&quot;arrow&quot;></div><h3 class=&quot;popover-header bg-transparent&quot;></h3><div class=&quot;popover-body fs-xs&quot;></div></div>"><i class="fal fa-info-circle mr-1"></i> mais informações</a>
											</h5>
										</div>
									</div>
									<div class="expanded theme-colors pl-5 pr-3">
										<ul class="m-0">
											<li>
												<a href="#" onClick="salvar('cust-theme-1.css')" id="myapp-1" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-1.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 1"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-2.css')" id="myapp-2" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-2.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 2"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-3.css')" id="myapp-3" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-3.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 3"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-4.css')" id="myapp-4" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-4.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 4"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-5.css')" id="myapp-5" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-5.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 5"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-6.css')" id="myapp-6" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-6.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 6"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-7.css')" id="myapp-7" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-7.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 7"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-8.css')" id="myapp-8" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-8.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 8"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-9.css')" id="myapp-9" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-9.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 9"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-10.css')" id="myapp-10" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-10.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 10"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-11.css')" id="myapp-11" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-11.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 11"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-12.css')" id="myapp-12" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-12.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 12"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-13.css')" id="myapp-13" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-13.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 13"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-14.css')" id="myapp-14" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-14.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 14"></a>
											</li>
											<li>
												<a href="#" onClick="salvar('cust-theme-15.css')" id="myapp-15" data-action="theme-update" data-themesave="" data-theme="css/themes/cust-theme-15.css" data-toggle="tooltip" data-placement="top" title="" data-original-title="Tema 15"></a>
											</li>
										</ul>
									</div>
									
								</div> <span id="saving"></span>
							</div>
						</form>	
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> 
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>