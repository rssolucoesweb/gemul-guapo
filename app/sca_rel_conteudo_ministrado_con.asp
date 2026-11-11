<%
	strExecutarSubmitSemestre 				= "S"
	strExecutarSubmitCurso	  				= "S"
	strExecutarSubmitPeriodo  				= "S"
	strExecutarSubmitProfessor				= "S"
	strExecutarSubmitTurma	  				= "S"
	strExecutarSubmitDisciplinaDoProfessor  = "S"

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
		intAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request.Form("txtAnoLetivo")
		intAnoLetivo = request.Form("txtAnoLetivo")
	end if
	if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
		intSemestre = session("strSemestre")
	    strSemestre = session("strSemestre")
	else
		intSemestre = request.Form("cmbSemestre")
	    strSemestre = request.Form("cmbSemestre")
	end if
	
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor")) 'perfil prof
	intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaTurma"))		'perfil adm
	if intCodDisciplinaTurma<>"0" then intCodDisciplina = intCodDisciplinaTurma

	'intCodTurma				= Trim(Request("cmbTurma"))                 'perfil prof
	intCodTurma	= Trim(Request("cmbTurmaProfessor"))        'perfil adm
	if intCodTurma<>"0" then intCodTurmaProfessor = intCodTurma
	
	intCodTurno					= Trim(Request("cmbTurnoDoProfessor"))
	intCodTurnoCombo			= Trim(Request("cmbTurnoDoProfessor"))
	
    intCodColaboradorProfessor 	= Trim(Request("cmbProfessor"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	
	strOpcaoRel 	        = Trim(Request("cmbOpcaoRel"))
	IF strOpcaoRel = "" THEN strOpcaoRel = "CONTEUDO"
	IF strOpcaoRel = "DEVOLUCAO" THEN escondeLinha = " style='display: none'"

	strDataInicial         		= Trim(Request("txtDataInicial"))
	strDataFinal            	= Trim(Request("txtDataFinal"))
	intCodEstagio     			= Trim(Request.Form("cmbEstagio"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	if strclasse = "" then strclasse = "celulaarial9"

   	if intCodComp = "" then intCodComp = "0"
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	if intCodTurma = "" then intCodTurma = "0"
	'if intCodDisciplina= "" then intCodDisciplina = "0"

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
			intSemestre = rs("cod_Semestre")
		END IF
		rs.close
	end if

	'controla os botões
	strDesabilitaIncluir 	= "disabled"
	strDesabilitaExcluir 	= "disabled"
	strDesabilitaAlterar 	= "disabled"
	strDesabilitaLimpar 	= ""
	intCodTurnoRH = intCodTurno
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodTurnoRH = "" then intCodTurnoRH = "0"
	if intCodTurno = "" then intCodTurno = "0"


	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and (CodCategoria = 1 OR CodCategoria = 8)"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		strTipoAcessoCadastroNotas = "ADM"
		intSemestre 			= Trim(Request("cmbSemestre"))
	else
		if (Session("Seg_CodCategoria") = "1") then
			strTipoAcessoCadastroNotas = "PROF"
			intCodColaboradorProfessor = rs("codigo")
			strExecutarSubmitDisciplinaDoProfessor = "S"
			strAnoLetivo = session("strAnoLetivo")
			intSemestre = session("strSemestre")
		ELSE
			strTipoAcessoCadastroNotas = "ADM"
			intSemestre 			= Trim(Request("cmbSemestre"))
		END IF	

	end if
	rs.close
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_conteudo_ministradoCon.asp">
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
									<label class="form-label">Ano Letivo:</label>
									<input onBlur="submit()" name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
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
								
									<label class="form-label">Turma:</label>
									
									<!--#include file="includes/inc_cmdTurmaProfessorConteudo.asp"-->
									

								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									<!--#include file="includes/inc_cmdTurnoDoProfessorConteudo.asp"-->
									<!--include file="includes/inc_cmdTurnoHorarioProfessor.asp" -->
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Disciplina:</label>
									<%IF strTipoAcessoCadastroNotas = "ADM" then%>
									<!--#include file="includes/inc_cmbDisciplinaTurma.asp"-->
									<input type="hidden" value="<%=intCodDisciplinaTurma%>" name="cmbDisciplinaDoProfessor" id="cmbDisciplinaDoProfessor">
									
									<%end if%>

									<%IF strTipoAcessoCadastroNotas = "PROF" then%>
									<!--#include file="includes/inc_cmdDisciplinaDoProfessorConteudo.asp"-->
									<%end if%>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Professor(a):</label>

									<!--#include file="includes/inc_cmdProfessorComHorarioDisciplina.asp"-->

								</div>
							</div>
							
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Período inicial:</label>
									<input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onBlur="return validaData(this);" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>">
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Período final:</label>
									<input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onBlur="return validaData(this);" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Opção:</label>
									<select name="cmbAssinatura" class="form-control" id="cmbAssinatura" >
									  <option value="S" >Com Assinaturas</option>
									  <option value="N" >Sem Assinaturas</option>
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