<%
	mostraSelecione			  = "N"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strEmpresaGrupo_submit    = "S"
	

	intCodEmpresaGrupo		    = Trim(Request.Form("cmbEmpresaGrupo"))
	intCodEmpresaGrupoUsuario	= Trim(Request.Form("cmdEmpresaGrupoUsuario"))
	intCodCurso	 				= Trim(Request.Form("cmbTodosCursoEmpresas"))
	intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	intCodGrade					= Trim(Request.Form("cmbGrade"))
	strCodTurno		 			= Trim(Request.Form("cmbTurno"))
	strSexo						= Trim(Request.Form("cmbSexo"))
	strIntervaloIdadeInicial 	= Trim(Request.Form("txtIntervaloIdadeInicial"))
	strIntervaloIdadeFinal  = Trim(Request.Form("txtIntervaloIdadeFinal"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodSemestre = "" then intCodSemestre = "0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_rel_mapa_turma_modulacaoCon.asp">
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
							<div class="col-sm-2" style="display:none">
								<div class="form-group">
									<label class="form-label">Faixa de Idade (Inicio):</label>
									<input  name="txtIntervaloIdadeInicial" type="text" class="form-control" id="txtIntervaloIdadeInicial" value="<%=strIntervaloIdadeInicial%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,2,3)">
								</div>
							</div>
							<div class="col-sm-2" style="display:none">
								<div class="form-group">
									<label class="form-label">Faixa de Idade (Fim):</label>
									<input  name="txtIntervaloIdadeFinal" type="text" class="form-control" id="txtIntervaloIdadeFinal" value="<%=strIntervaloIdadeFinal%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,2,3)">
								</div>
							</div>
							<div class="col-sm-4" style="display:none">
								<div class="form-group">
									<label class="form-label">Sexo:</label>
									 <!--#include file="includes/inc_cmdSexo.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Filtro:</label>
									 <select name="optOpcao" class="form-control" id="optOpcao">
										<option <% if strOpcaoRelatorio = "T" then response.Write("selected")%> value="T" >Todas Turmas</option>
										<option <% if strOpcaoRelatorio = "A" then response.Write("selected")%> value="A" >Turmas Ativas (Alunos vinculados)</option>
									</select>
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Situação Aluno:</label>
									<!--#include file="includes/inc_cmdSituacaoAluno.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									<!--#include file="includes/inc_cmbTipoCurso.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									<select name="cmbTurno" class="form-control" id="cmbTurno">
									  <option value="0">Selecione...</option>
									  <option value="M" <%if strCodTurno = "M" then response.Write("selected") %>>Matutino</option>
									  <option value="V" <%if strCodTurno = "V" then response.Write("selected") %>>Vespertino</option>
									  <option value="N" <%if strCodTurno = "N" then response.Write("selected") %>>Noturno</option>
									  <option value="I" <%if strCodTurno = "I" then response.Write("selected") %>>Integral</option>
									</select>
								</div>
							</div>
						</div>
						<br>
						<div class="row"><div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Somente inconsist&ecirc;ncia:</label>
									<input type="checkbox" name="SomentoIncosistecia" value="S">
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