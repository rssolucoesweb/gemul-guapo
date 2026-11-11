<%
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strEmpresaGrupo_submit	  = "S"

	if Session("NivelPermissao") = "A" then 
		mostraSelecione = ""
	else
		mostraSelecione = "S"
	end if
	
	intSemestre  			= session("strSemestre")
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodEmpresaGrupo     = Trim(Request.Form("cmbEmpresaGrupo"))
	intSemestre 			= 3
	strDataInicial  		= Trim(Request.Form("txtDataInicial"))
	strDataFinal  			= Trim(Request.Form("txtDataFinal"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strAnoLetivo               = Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then
		strAnoLetivo 			= session("strAnoLetivo")
	end if
	strFiltroSerie = "0"
	strFiltroTurno = "0"
	IF intCodEmpresaGrupo = "" AND intCodEmpresaGrupo = "0" THEN intCodEmpresaGrupo = Session("CodEmpresa") 

	if intCodSemestre = "" then intCodSemestre = "0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_rel_mapa_rendimentoCon.asp">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
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
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Unidade:</label>
									 <!--#include file="includes/inc_cmbEmpresaGrupo.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									 <!--#include file="includes/inc_cmbCursoFundamental.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurmaEmpresa.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Matr&iacute;cula antes do dia:</label>
									<select name="cmbDia" id="cmbDia" class="form-control"  <%=strFuncao%>>
									 <option value="0">Selecione...</option>
									 <%
									 for i=1 to 31
									 %>
									 <option value="<%=i%>"><%=i%> de maio</option>
									 <%
									 next
									 %>
								 </select>
								</div>
							</div>
							
							<div class="col-sm-5">
								<div class="form-group">
									<label class="form-label">Avaliação:</label>
									<!--#include file="includes/inc_cmbAvaliacaoEmpresa.asp"-->
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