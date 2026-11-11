<%
	
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitGradeCurricular = "S"

	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if intAnoLetivo = "" then 	intAnoLetivo 			= session("strAnoLetivo")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo 			= session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre 			= session("strSemestre")
	
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	intCodColaboradorProfessor  = Trim(Request("cmbProfessor"))
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
	strOpt 					= request("txtOpt")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	intCodTurma				= intCodTurmaProfessor

	if trim(intCodTurma) <> "" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo = rs("cod_periodo")
			intCodTurno = rs("cod_turno")
			intSemestre = rs("cod_Semestre")
		END IF
		rs.close
	end if
	strExecutarSubmitProfessor  = "S"
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	if intCodProfessor = "" then intCodProfessor = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	
	'IF intCodColaboradorProfessor <> "0" THEN
	'	intCodCurso 		= "0"
	'	intCodSerie 		= "0"
	'	intCodTurno 		= "0"
	'	intCodTurma 		= "0"
	'	intCodTurmaProfessor = "0"
	'END IF
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_rel_horario_aulaCon.asp">
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
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Opções:</label>
									<select name="cmbTipo" id="cmbTipo"  class="form-control" >
										<option value="1" <% if intTipo = "1" then response.Write("selected")%>>Normal</option>
										<option value="2" <% if intTipo = "2" then response.Write("selected")%>>Extra</option>
									</select>
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
							<div class="col-sm-8">
								<div class="form-group">
									<label class="form-label">Professor(a):</label>
									 <!--#include file="includes/inc_cmdProfessor.asp" -->
								</div>
							</div>
						</div>
						<br>
						
						<div class="row">	
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									 <!--#include file="includes/inc_cmdCurso.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Período:</label>
									 <!--#include file="includes/inc_cmdPeriodo.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Grade:</label>
									 <!--#include file="includes/inc_cmdGradeCurricular.asp" -->
								</div>
							</div>
						</div>
						<br>
						
						<div class="row">	
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									 <!--#include file="includes/inc_cmdTurno.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurmaProfessor.asp" -->
								</div>
							</div>
						</div>
						<br>
						
						<div class="row">	
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Omitir Hor&aacute;rios?:</label>
									<input type="checkbox" name="txtOmitirHorario" value="S">
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