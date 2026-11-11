<script>
	function gerar(){
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
		if (frm.cmbOpcaoRel.value == "CONTEUDO") {
			if (frm.txtDataInicial.value == "") {
				alert("A Data Inicial deve ser Informada !");
				frm.txtDataInicial.focus();
				return false;
			}
	
			if (frm.txtDataFinal.value == "") {
				alert("A Data Final deve ser Informada !");
				frm.txtDataFinal.focus();
				return false;
			}
			frm.action = "sca_rel_conteudo_programaticoREL.asp";
		}else{
			frm.action = "sca_rel_conteudo_programatico_devolucaoREL.asp";
		}

		frm.submit();
		
		return true;	
	}		
</script>
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
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
	intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))

	intCodTurma				= Trim(Request("cmbTurmaProfessor"))
	intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	
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
	
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if session("codGrupo") = "7" then
		if intCodTurnoRH = "" then intCodTurnoRH = "0"
		if intCodTurno = "" then intCodTurno = "0"
		sql = "select trh.cod_turno from SCA_TURNO t inner join SRH_TURNO trh on trh.desc_turno = t.desc_turno and trh.Cod_Grupo = " & session("codGrupo") & " where t.cod_turno = " & intCodTurno
		rs.open sql, cnn
		if not rs.eof then
			intCodTurnoRH = rs("cod_turno")
		end if
		rs.close
	end if

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_conteudo_programatico.asp">
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
								
									<label class="form-label">Op&ccedil;&atilde;o:</label>
									<select name="cmbOpcaoRel" id="cmbOpcaoRel" class="form-control" onChange="submit()">
										<option <%IF strOpcaoRel = "CONTEUDO" then%>selected<%END IF%> value="CONTEUDO">Conteudo</option>
										<option <%IF strOpcaoRel = "DEVOLUCAO" then%>selected<%END IF%> value="DEVOLUCAO">Devolução</option>
									</select> 
		
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
								
									<label class="form-label">Tamanho da fonte na impressão:</label>
									<!--#include file="includes/inc_cmbTamanhoFonteArial.asp"-->
		
								</div>
							</div>
						</div>
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
								
									<label class="form-label">Turma:</label>
									<!--#include file="includes/inc_cmdTurmaProfessorConteudo.asp"-->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									<!--#include file="includes/inc_cmdTurnoDoProfessorConteudo.asp"-->
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Disciplina:</label>
									<!--#include file="includes/inc_cmdDisciplinaDoProfessorConteudo.asp"-->
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
									<input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>">
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Período final:</label>
									<input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>">
								</div>
							</div>
						</div>
						
						
						<div class="row">
							
								<div class="col-sm-12">
									<div class="panel-tag">
										<span class="fw-300">Obs: Para a impress&atilde;o, seu navegador dever&aacute; ser configurado com as margens direita 05, esquerda 05, superior 05 e inferior 5. Dever&aacute; tamb&eacute;m ser exclu&iacute;do cabe&ccedil;alho e rodap&eacute; de seu navegador na op&ccedil;&atilde;o configurar p&aacute;gina.</span>
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