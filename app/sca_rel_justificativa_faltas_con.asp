<%

	dim intCodSituacaoAluno

	strPaginaTitulo = "sca_rel_justificativa_faltas_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmit	  = "S"
	

	strMatriculaAluno		= Trim(Request.Form("txtMatricula"))
    strCodAluno			    = Trim(Request("txtCodAluno"))
	strNomealuno 		    = Trim(Request("txtNomealuno"))
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request.Form("cmbPlanoPagamento"))
	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))

	strIntervaloPercFaltaInicial	= Trim(Request.Form("txtIntervaloPercFaltaInicial"))
	strIntervaloPercFaltaFinal	= Trim(Request.Form("txtIntervaloPercFaltaFinal"))

	strIntervaloMediaInicial	= Trim(Request.Form("txtIntervaloMediaInicial"))
	strIntervaloMediaFinal		= Trim(Request.Form("txtIntervaloMediaFinal"))
	strSimouNao                 = Trim(Request.Form("cmbSimouNao"))
	strclasse                   = Trim(Request.Form("cmbTamanhoFonteArial"))
	if strclasse = "" then strclasse = "celulaarial12"

	'**********************************************
	'INICIO -> Regra para pegar ou não do historico
	'**********************************************
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	buscarExtratoHistorico = ""
	extratoBusca = ""
	'IF UCASE(SESSION("USUARIOWEB")) = "SERGIO" THEN
	if trim(session("strAnoLetivo"))<>Trim(Request.Form("txtAnoLetivo")) and Trim(Request.Form("txtAnoLetivo"))<>"" then
		if Clng(Trim(Request.Form("txtAnoLetivo"))) < Clng(trim(session("strAnoLetivo"))) then
			extratoBusca = " - HISTORICO"
			buscarExtratoHistorico = "S"
		end if
	end if
	'END IF
	'**********************************************
	'FIM    -> Regra para pegar ou não do historico
	'**********************************************

	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"
	if intCodTurma = "" then intCodTurma = "0"

	if trim(strMatriculaAluno) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where matricula = " & strMatriculaAluno
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			    = Trim(rs("codigo"))
			strMatriculaAluno 		= Trim(rs("Matricula"))
			strNomealuno 	    	= Trim(rs("Nomealuno"))
		else
			strCodAluno			= 0
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close
		'
		' Verificando a alocação do aluno
		sql = "SELECT TOP 1 SCA_CURSO.Cod_Curso, SCA_TURMA.COD_SEMESTRE, SCA_TURMA.COD_TURMA "
		sql = sql & " FROM SCA_ALUNO_TURMA "
		sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
		sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
		sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and 	SCA_ALUNO.CODIGO = " & strCodAluno
		sql = sql & " order by SCA_ALUNO_TURMA.CODIGO DESC "
		rs.open sql, cnn
		if not rs.eof then
		   intCodCurso = rs("cod_curso") 
		   intCodTurma = rs("COD_TURMA")
		else
		   %>
		   <script>
			   alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
		   </script>
		   <%
		end if
		rs.close

	else
		strCodAluno			    = ""
		strMatriculaAluno 		= ""
		strNomealuno 		    = ""
	end if

	if trim(intCodTurma) <> "0" then
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
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
	intTotalExtrato 			= Trim(Request.Form("cmbTotalExtrato"))
	if intTotalExtrato = "" then intTotalExtrato = 2

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_justificativa_faltasCon.asp">
	<input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">
	<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
	<input type="hidden" name="cmbTurno" value="<%=intCodTurno%>">
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
						<%=pagina%><%=extratoBusca%> <span class="fw-300"><i></i></span>
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
						<input name="buscarExtratoHistorico" type="hidden" id="buscarExtratoHistorico" value="<%=buscarExtratoHistorico%>">
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
							<div class="col-sm-8">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurma.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Situa&ccedil;&atilde;o:</label>
									<!--#include file="includes/inc_cmdSituacaoAluno.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Bimestre:</label>
									<!--#include file="includes/inc_cmdBimestre.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Tipo:</label>
									<!--#include file="includes/inc_cmbTipoJustificativa.asp" -->
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
	
	<%
	if intCodTurma    = "" then intCodTurma="0"
	if intCodPeriodo = "" then intCodPeriodo="0"

	if intCodTurma<>"0" then%>

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">		
						
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><input name="chkTodos" type="checkbox" value="" onClick="return MarcaTodosAlunos(this.checked)"></th>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								sql = sqlAlunoTurma(intCodTurma, "")
								rs.open sql, cnn
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1
										strCodigoAluno        = rs("codigo")
										strMatricula		  = rs("MATRICULA")
										
										%>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO")%></td>
											<td><%=rs("DESC_SITUACAOALUNO")%></td>
										</tr>
										 <%
										 rs.movenext
									  wend
									  %>
									   <tr>
										<td colspan="4" align="left"><strong>Quantidade de alunos: <%=cont%></strong></td>
									  </tr>
									  <%
								  else
									 %>
									 <tr> 
									 <td colspan="4" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
									 </tr>
									 <%
								  end if
								  rs.close
								%>
								</tbody>
							</table>
						</div>	
					</div>
				</div>
			</div>
		</div>
	</div> 
		<%
		end if
		%>
		<input type="hidden" name="txtHiddenAlunosTurma" value="<%=strAlunosTurma%>">
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>