<%

	strExecutarSubmitTurma       = "S"
	
	if trim(request.Form("txtDataI")) = "" then
	   strDataI 			= formatadataAP(date)
	else
	   strDataI				= formatadataAP(request.Form("txtDataI"))   
	end if
	if trim(request.Form("txtDataF")) = "" then
	   strDataF			    = formatadataAP(date)
	else
	   strDataF				= formatadataAP(request.Form("txtDataF"))   
	end if
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	if strlpp = "" then strlpp = "100"
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strOpcaoRelatorio		= request.Form("cmbOpcaoRel")


	if intCodTurma = "" then intCodTurma ="0"

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_situacao_academicaCon.asp">
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
						
						<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
						<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
						<input name="txtPodeEditar" value="<%=strPodeEditar%>" type="hidden">
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Opção de relatório:</label>
										<select name="cmbOpcaoRel" id="cmbOpcaoRel"  class="form-control" >
											<option value="0" <% if strOpcaoRelatorio = "0" then response.Write("selected")%>>Sint&eacute;tico</option>
											<option value="1" <% if strOpcaoRelatorio = "1" then response.Write("selected")%>>Anal&iacute;tico</option>
										</select>
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							<div class="col-sm-8">
								<div class="form-group">
									<label class="form-label">Situa&ccedil;&atilde;o:</label>
									<!--#include file="includes/inc_cmdSituacaoAluno.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Período inicial:</label>
									<input name="txtDataI" type="text" class="form-control" id="txtDataI" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataI%>">
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Período final:</label>
									<input name="txtDataF" type="text" class="form-control" id="txtDataF" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataF%>">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Linhas por P&aacute;gina:</label>
									 <!--#include file="includes/inc_cmbLinhaPorPagina.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Tamanho da Fonte:</label>
									 <!--#include file="includes/inc_cmbTamanhoFonteArial.asp" -->
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