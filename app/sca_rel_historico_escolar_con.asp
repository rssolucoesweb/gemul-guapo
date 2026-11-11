<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strSemestre 					= session("strSemestre")
	strAnoLetivo 					= session("strAnoLetivo")
	
	strCodAluno						= Trim(Request("txtCodAluno"))
	strMatricula 					= Trim(Request("txtMatricula"))
	strNomealuno   					= Trim(Request("txtNomealuno"))
	strTipoHistorico        		= Trim(Request("cmbTipoHistorico"))
	strclasse                       = Trim(Request.Form("cmbTamanhoFonteArial"))
	
	if strMatricula <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			intcodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		end if
		rs.close	
	else
			strCodAluno			= ""
			strMatricula 		= ""
			strNomealuno 		= ""
	end if


	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"

	strMostraAlunos = ""
	if 	intCodCurso <> "0" then strMostraAlunos = "S"
	if 	intCodSerie <> "0" then strMostraAlunos = "S"
	if 	intCodTurno <> "0" then strMostraAlunos = "S"
	if 	intCodTurma <> "0" then strMostraAlunos = "S"

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

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<form id="frm" method="post" action="sca_rel_historico_escolarCon.asp">
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
							
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group"><strong>Matrícula do Aluno</strong></label>
										<div class="input-group">
											<input type="text" class="form-control" value="<%=strMatricula%>" name="txtMatricula" id="txtMatricula" placeholder="" aria-label="" aria-describedby="button-addon5" onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
											<div class="input-group-append">
												<button class="btn btn-primary waves-effect waves-themed" type="button" id="button-addon5" onClick="return abreConsulta('sca_aluno_con.asp')" ><i class="fal fa-search"></i></button>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-9">
									<div class="form-group">
										<label class="form-label"></label>
										<input type="text" name="txtNomealuno" readonly id="txtNomealuno" class="form-control" value="<%=strNomeAluno%>">
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