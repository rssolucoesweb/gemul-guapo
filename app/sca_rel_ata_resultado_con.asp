<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	submitFuncaoAvaliacao = "S"
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo 			= session("strAnoLetivo")
	else
		strAnoLetivo 			= request("txtAnoLetivo")
	end if
	if Trim(Request.Form("cmbSemestre")) <> "" then
		intSemestre 				= Trim(Request.Form("cmbSemestre"))
	else
		intSemestre 				= session("strSemestre")
    end if	
	
	intCodAvaliacao	 			= Trim(Request.Form("cmbAvaliacao"))
	strTipo	 			= Trim(Request.Form("cmbTipo"))
	if strTipo = "" then strTipo = "A"
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSituacaoDisciplina   = Trim(Request.Form("cmbSituacaoDisciplina"))
	
	if trim(intCodTurma) = "" then  intCodTurma = "0"

	if trim(intCodTurma) <> "0" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre ,SCA_TURMA.anoLetivo , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
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
			strAnoLetivo = rs("anoLetivo")
		END IF
		rs.close
	end if

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_ata_resultadoCon.asp">
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
									<label class="form-label">Opções:</label>
									<select name="cmbTipo" id="cmbTipo"  class="form-control" onchange="submit()">
										<option value="A" <% if strTipo = "A" then response.Write("selected")%>>Anual</option>
										<option value="B" <% if strTipo = "B" then response.Write("selected")%>>Por Avaliação </option>
									</select>
								</div>
							</div>
						</div>
						<br>
						<div class="row">	
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							
							<div class="col-sm-<% if strTipo = "B" then %>6<%else%>8<%end if%>">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									<!--#include file="includes/inc_cmdCurso.asp" -->
								</div>
							</div>
							<% if strTipo = "B" then %>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Avaliação:</label>
									 <!--#include file="includes/inc_cmbAvaliacaoAta.asp" -->
								</div>
							</div>
							<% end if %>
						</div>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Per&iacute;odo:</label>
									<!--#include file="includes/inc_cmdPeriodo.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									 <!--#include file="includes/inc_cmdTurno.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurma.asp" -->
								</div>
							</div>
						
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
						</div>
						<%
						if intCodTurma<>"0" then
						%>
						<div class="frame-wrap">
							<input type="button" name="cmdAprovar" style="cursor:hand" value=" Clique aqui para consultar aluno reprovado por falta com opção de aprovar pelo conselho " class="form-control" onclick="return aprovarPeloConselho()">
						</div>
						<%
						end if						
						%>			
					</div>
				</div>
			</div>
		</div>
	</div>
	<input name="txtPosicao"  type="hidden" id="txtPosicao" value="<%=strPosicao%>">
	<input name="txtBimestre" type="hidden" id="txtBimestre" value="<%=strBimestre%>">
						
</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>