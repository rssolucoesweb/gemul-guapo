<%
	acao = "I"

	strExecutarSubmitCurso	         = "S"
	strExecutarSubmitPeriodo         = "S"
	strExecutarSubmitSemestreCriacao = "S"
	strExecutarSubmitSemestreTodos   = "S"
	strExecutarSubmitTurno	         = "S"
	
	strAnoLetivo 			= session("strAnoLetivo")
	intCodTurma 			= Trim(Request.Form("txtCodigo"))
	strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
	strTurmaAluno 			= Trim(Request.Form("txtTurmaAluno"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	
	
	if Trim(Request.Form("cmbSemestre")) <> "0" then
	   intSemestre 			= Trim(Request.Form("cmbSemestre"))
	else
	   intSemestre 			= session("strSemestre")
	end if   
	   
	intCodGrade					= Trim(Request.Form("cmbGrade"))

	intCodTurno		 			= Trim(Request.Form("cmbTurno"))
	strSala		 				= Trim(Request.Form("txtSala"))
	
	intAno		 					= Trim(Request.Form("txtAno"))
	intSemestreCriacao				= Trim(Request.Form("cmbSemestreCriacao"))
	intAnoLetivo 					= Trim(Request.Form("txtAnoLetivo"))
	intCapacidade 					= Trim(Request.Form("txtCapacidade"))
	intCodFichaDescritiva			= Trim(Request.form("cmbFichaDescritiva"))
	strSimouNaoIntegralizacao		= Trim(Request.form("cmbSimouNaoIntegralizacao"))
	strDesvincularCriterioAvaliacao	= Trim(Request.form("cmbDesvincularCriterioAvaliacao"))
	strSituacaoTurma				= Trim(Request.form("cmbSituacaoTurma"))
	intVagasMatriculas				= Trim(Request.form("txtVagasMatriculas"))
	intVagasMatriculasUtilizadas	= Trim(Request.form("txtVagasMatriculasUtilizadas"))


	if strSala <> "" then strSala = ZeroLeft(Trim(strSala),2)
	if intAnoLetivo = "" then intAnoLetivo = strAnoLetivo
	if intSemestre = "" then intSemestre = session("strSemestre")

	if trim(intCodTurma) <> ""  then 
		sql = "SELECT SCA_TURMA.capacidade, SCA_TURMA.nomeTurma, SCA_SEMESTRE.sigla, SCA_TURMA.Cod_Turma, SCA_GRADECURRICULAR.diferenciada, "
		sql = sql & " SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.Cod_Semestre, SCA_TURMA.Cod_Turno, SCA_TURMA.Sala, SCA_TURMA.Ano, "
		sql = sql & " SCA_TURMA.Cod_SemestreCriacao,SCA_TURMA.AnoLetivo, SCA_TURMA.TurmaAluno, SCA_TURMA.Cod_FichaDescritiva, SCA_TURMA.DisponibilizaIntegralizacao,"
		sql = sql & " SCA_GRADECURRICULAR.Cod_Periodo, SCA_PERIODO.Cod_Curso, SCA_TURMA.DesvincularCriterioAvaliacao, SCA_TURMA.situacao, sca_turma.VagasMatriculas, sca_turma.VagasMatriculasUtilizadas"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " left JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = dbo.SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " left JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " left JOIN SCA_SEMESTRE ON SCA_SEMESTRE.Codigo = SCA_TURMA.Cod_Semestre"
		sql = sql & " WHERE     (SCA_TURMA.Cod_Turma = " & intCodTurma & ") "
		sql = sql & " AND 		(SCA_TURMA.Cod_Empresa = " & Session("CodEmpresa") & ") "
		rs.open sql, cnn
		if rs.eof = false then
			intCodTurma 			= rs("Cod_Turma")
			strNomeTurma 			= rs("NomeTurma")
			intCodCurso	 			= rs("Cod_Curso")
			intCodPeriodo 			= rs("Cod_Periodo")
			intSemestre 			= rs("Cod_Semestre")
			strSiglaSemestre		= rs("sigla")
			intCodGrade				= rs("Cod_GradeCurricular")
			intCodTurno		 		= rs("Cod_Turno")
			strSala		 			= ZeroLeft(rs("Sala"),2)
			intAno		 			= rs("Ano")
			intSemestreCriacao		= rs("Cod_SemestreCriacao")
			diferenciada		= rs("diferenciada")
			intAnoLetivo 					= rs("AnoLetivo")
			strTurmaAluno					= rs("TurmaAluno")
			intCapacidade					= rs("Capacidade")
			intCodFichaDescritiva			= rs("Cod_FichaDescritiva")
			strSimouNaoIntegralizacao 		=  rs("DisponibilizaIntegralizacao")
			strDesvincularCriterioAvaliacao	=  rs("DesvincularCriterioAvaliacao")
			strSituacaoTurma				=  rs("Situacao")
			intVagasMatriculas				= rs("VagasMatriculas")
			intVagasMatriculasUtilizadas	= rs("VagasMatriculasUtilizadas")
			
			strSiglaSemestre = intSemestreCriacao
		    if intSemestre = "3" then strSiglaSemestre		= "A"
	
		    acao = "AE"
		end if 
		rs.close
	else
		IF LEN(trim(strNomeTurma)) = 9 THEN
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		ELSE
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		END IF
		strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
		
		IF Trim(Request.Form("txtNomeTurma"))<>"" THEN
			strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
		END IF
		IF Trim(Request.Form("cmbCurso")) <>"" THEN
			intCodCurso	 			= Trim(Request.Form("cmbCurso"))
		END IF
		IF Trim(Request.Form("cmbPeriodo"))<>"" THEN
			intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
		END IF
		IF  Trim(Request.Form("cmbGrade"))<>"" THEN
			intCodGrade				= Trim(Request.Form("cmbGrade"))
		END IF
		IF Trim(Request.Form("cmbTurno"))<>"" THEN
			intCodTurno		 		= Trim(Request.Form("cmbTurno"))
		END IF
		IF Trim(Request.Form("txtSala"))<>"" THEN
			strSala		 			= Trim(Request.Form("txtSala"))
		END IF
		if strSala <> "" then strSala = ZeroLeft(Trim(strSala),2)
		IF Trim(Request.Form("txtAno"))<>"" THEN
			intAno		 			= Trim(Request.Form("txtAno"))
		END IF
		IF Trim(Request.Form("cmbSemestreCriacao"))<>"" THEN
			intSemestreCriacao		 			= Trim(Request.Form("cmbSemestreCriacao"))
		END IF
		IF Trim(Request.Form("txtAnoLetivo"))<>"" THEN
			intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
		END IF
		strSiglaSemestre = intSemestreCriacao
		if intSemestreCriacao = "3" then strSiglaSemestre		= "A"
	end if 
	
	if intCodCurso = "" then intCodCurso = "0"
    if intCodCurso <> "0" then
		strSigla = ""
		sql = "SELECT Sigla"
		sql = sql & " FROM SCA_CURSO"
		SQL = SQL & " where cod_curso = " & intCodCurso
		RS.OPEN SQL, CNN		
		IF NOT RS.EOF THEN
			strSigla = RS("sigla")
		END IF
		RS.CLOSE
	end if

	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intCodPeriodo <> "0" then
		strSequencia = ""
		sql = "SELECT Sequencia, descricao"
		sql = sql & " FROM SCA_PERIODO"
		SQL = SQL & " WHERE cod_periodo = " & intCodPeriodo
		RS.OPEN SQL, CNN		
		IF NOT RS.EOF THEN
			strSequencia = RS("Sequencia")
			strPeriodo = RS("descricao")
		END IF
		RS.CLOSE
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
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
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
						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodTurma%>">
							
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Ano</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" onBlur="submit()"  value="<%=intAnoLetivo%>" maxlength="4" onKeyPress="return formataCampo(this,2,4)">
									</div>
								</div>	
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Semestre</label>
										<!--#include file="includes/inc_cmdSemestreTodos.asp"-->
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Curso</label>
										<!--#include file="includes/inc_cmdCurso.asp" -->
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Período</label>
										<!--#include file="includes/inc_cmdPeriodo.asp" -->
									</div>
								</div>	
							</div>	
							<%
								if strCurso = "EDUCAÇÃO INFANTIL" then strDesvincularCriterioAvaliacao = "S"
							%>
							<br>
							<div class="row">
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Sala</label>
										<input type="text" id="txtSala" onBlur="submit()" name="txtSala" class="form-control" value="<%=strSala%>"  size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)" >
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Turno</label>
										<!--#include file="includes/inc_cmdTurno.asp" -->
									</div>
								</div>	
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Matriz</label>
										<!--#include file="includes/inc_cmdGradeCurricular.asp"-->
									</div>
								</div>	
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Ano criação</label>
										<input type="text" id="txtAno" name="txtAno" onBlur="submit()" class="form-control" value="<%=intAno%>"  size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)" >
									</div>
								</div>									
							</div>	
							
							<br>
							<div class="row">
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Semestre criação</label>
										<!--#include file="includes/inc_cmdSemestreCriacao.asp" -->
									</div>
								</div>	
								<%
								strNomeTurma = strSigla 
								strNomeTurma = strNomeTurma & strSequencia 
								strNomeTurma = strNomeTurma & strSala 
								strNomeTurma = strNomeTurma & strSiglaTurno 
								strNomeTurma = strNomeTurma & strSiglaSemestre
								if intAno <> "" then
									strNomeTurma = strNomeTurma & right(intAno,2)
								end if
							
								if trim(intCodTurma) = "" then
									IF LEN(trim(strNomeTurma)) = 9 OR LEN(trim(strNomeTurma)) = 10 THEN
										strDesabilitaIncluir= "" 'Desabilita o botão Incluir
									ELSE
										strDesabilitaIncluir= "disabled" 'Desabilita o botão Incluir
									END IF
									strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
									strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir		
								end if
								
								if trim(intCodTurma) <> "" then
									if strTurmaAluno <> "" then
										strTurmaAluno = right(strTurmaAluno,len(strTurmaAluno)-len(strPeriodo))
									end if
								END IF
								
								%>
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Nome turma</label>
										<input readonly="true" name="txtNomeTurma" type="text" class="form-control" id="txtNomeTurma"  value="<%=strNomeTurma%>" size="12" maxlength="10" >
									</div>
								</div>	
								<div class="col-sm-2">	
									<div class="form-group">
										<label class="form-label">Descrição Física da Turma<input type="hidden" id="strPeriodo" name="strPeriodo" value="<%=strPeriodo%>"></label>
										<br><strong><%=strPeriodo%></strong>
									</div>
								</div>
								<div class="col-sm-1">	
									<div class="form-group">
										<label class="form-label">Ex.: A</label>
										<input name="txtTurmaAluno" type="text" class="form-control" id="txtTurmaAluno"  value="<%=strTurmaAluno%>" size="2" maxlength="2" >
									</div>
								</div>								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Capacidade</label>
										<input type="text" id="txtCapacidade" name="txtCapacidade" class="form-control" value="<%=intCapacidade%>"  size="5" maxlength="4" onKeyPress="return formataCampo(this,2,2)" >
									</div>
								</div>	
							</div>	
							
							<br>
							<div class="row">
								<!--div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Ficha Descritiva</label>
										<!--include file="includes/inc_cmdFichaDescritiva.asp" >
									</div>
								</div -->	
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Disponibilizar Integraliza&ccedil;&atilde;o</label>
										<select name="cmbSimouNaoIntegralizacao" class="form-control" id="cmbSimouNaoIntegralizacao" >
										  <option value="N" <%if strSimouNaoIntegralizacao = "N" then response.Write("selected") %>>NAO</option>
										  <option value="S" <%if strSimouNaoIntegralizacao = "S" then response.Write("selected") %>>SIM</option>
										</select>
									</div>
								</div>	
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Desvincular Crit&eacute;rio de Avalia&ccedil;&atilde;o</label>
										<select name="cmbDesvincularCriterioAvaliacao" class="form-control" id="cmbDesvincularCriterioAvaliacao" >
										  <option value="N" <%if strDesvincularCriterioAvaliacao = "N" then response.Write("selected") %>>NAO</option>
										  <option value="S" <%if strDesvincularCriterioAvaliacao = "S" then response.Write("selected") %>>SIM</option>
										</select>
									</div>
								</div>									
							
							<%
							if trim(intCodTurma) <> ""  then 
								intOcupada = 0
								sql = "SELECT  DISTINCT SCA_ALUNO.CODIGO"
								sql = sql & " FROM SCA_ALUNO_TURMA "
								sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
								SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO "
								sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
								sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")	
								sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
								sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivo
								sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
								sql = sql & " and   SCA_TURMA.COD_TURMA = " & intCodTurma 
								sql = sql & " AND (SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'ATIVO' OR SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
								RSAUX.OPEN SQL, CNN, 3, 1
								IF NOT RSAUX.EOF THEN
									intOcupada = RSAUX.RECORDCOUNT
								END IF
								RSAUX.CLOSE
								intVagasMatriculasUtilizadas = intOcupada
							end if	
						   %> 
							
							
								<div class="col-sm-6">	
									<div class="form-group">
										<label class="form-label">Situa&ccedil;&atilde;o</label>
										<select name="cmbSituacaoTurma" class="form-control" id="cmbSituacaoTurma" >
										  <option value="A" <%if strSituacaoTurma = "A" then response.Write("selected") %>>ATIVA</option>
										  <option value="I" <%if strSituacaoTurma = "I" then response.Write("selected") %>>INATIVA</option>
										</select>
										<input  name="cmbSituacaoTurmaAnterior" type="hidden" id="cmbSituacaoTurmaAnterior"  value="<%=strSituacaoTurma%>">
									</div>
								</div>
							</div>
							<br>
							<div class="row">									
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Vagas</label>
										<input type="text" id="txtVagasMatriculas" name="txtVagasMatriculas" class="form-control" value="<%=intVagasMatriculas%>"  size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)">
									</div>
								</div>	
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Vagas Utilizadas</label>
										<input name="txtVagasMatriculasUtilizadas" type="text" class="form-control"  readonly id="txtVagasMatriculasUtilizadas"  value="<%=intVagasMatriculasUtilizadas%>" size="3" maxlength="2">
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Regra de criação de uma turma ex: EF 1 01 M 1 05</label>
										<br>EF: Sigla do curso | 1: Período | 01: Sala de Aula | M: Inicial do turno <br>1: Semestre de Criação ( "1"º Semestre, "2"º Semestre e "A"nual ) | 21: Ano de Criação
									</div>
								</div>
								
							</div>
							
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont =0
	sql = "SELECT SCA_TURMA.Cod_Turma, SCA_TURMA.Cod_GradeCurricular, SCA_GRADECURRICULAR.diferenciada, SCA_TURMA.Cod_Semestre, SCA_TURMA.Cod_Turno, SCA_TURNO.Desc_turno, SCA_TURMA.Capacidade,"
	sql = sql & "SCA_TURMA.nomeTurma, SCA_TURMA.Sala, SCA_TURMA.Ano, SCA_TURMA.AnoLetivo, SCA_TURMA.TurmaAluno, SCA_GRADECURRICULAR.cod_gradecurricular as cod_matriz, "
	sql = sql & " SCA_TURMA.Cod_periodo, PT.Descricao as Periodo,SCA_TURMA.DesvincularCriterioAvaliacao,SCA_TURMA.situacao  "
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.cod_turno = SCA_TURMA.cod_turno"
	sql = sql & " LEFT JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " LEFT JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	sql = sql & " LEFT JOIN SCA_PERIODO PT ON SCA_TURMA.Cod_periodo = PT.Cod_Periodo"
	sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and 	AnoLetivo = " & intAnoLetivo
    sql = sql & " and 	SCA_TURMA.Cod_Semestre = " & intSemestre	
	sql = sql & " Order by SCA_TURMA.AnoLetivo, SCA_TURNO.DESC_TURNO, PT.DESCRICAO, SCA_TURMA.Nometurma"
	rs.open sql, cnn
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastradas
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">					
						<div class="panel-tag">
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Desc. Física</strong></th>
									<th><strong>Nome da Turma</strong></th>
									<th><strong>Período</strong></th>
									<th><strong>Sala</strong></th>
									<th><strong>Ano Letivo</strong></th>
									<th><strong>Matriz</strong></th>
									<th><strong>Diferenciada</strong></th>
									<th><strong>Turno</strong></th>
									<th><strong>Capacidade</strong></th>
									<th><strong>Desvincular C.A.</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							  <%
									while not rs.eof
										cont = cont + 1	
							
										strCorLinha = ""
										
										sit = ""
										if ucase(trim(rs("situacao"))) = "I" then
											sit = " <strong>(inativa)</strong>"
										end if
										if ucase(trim(rs("DESC_TURNO"))) = "MATUTINO" then
											strCorLinha = "bgcolor='#FFFFCC'"
										end if
										
										if ucase(trim(rs("DESC_TURNO"))) = "VESPERTINO" then
											strCorLinha = "bgcolor='#CAFEB4'"
										end if
										
										if ucase(trim(rs("DESC_TURNO"))) = "NOTURNO" then
											strCorLinha = "bgcolor='#D8D8D8'"
										end if
										
										if ucase(trim(rs("DESC_TURNO"))) = "INTEGRAL" then
											strCorLinha = "bgcolor='#C2CAFC'"
										end if
										
										strMatrizDiferencia = ""
										if trim(rs("diferenciada")) = "S" then
											strMatrizDiferencia = "<strong>Sim</strong>"
										end if
										
										strDesvincularCriterioAvaliacaoLista = "Não"
										if ucase(trim(rs("DesvincularCriterioAvaliacao"))) = "S" then
											strDesvincularCriterioAvaliacaoLista = "<strong>Sim</strong>"
										end if
										%>
										  <tr <%=strCorLinha%> style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("cod_turma")%>')">
											<td class="celula"><%=rs("TurmaAluno")%><%=sit%></td>
											<td height="20" class="celula"><%=trim(rs("NomeTurma"))%></td>
											<td height="20" class="celula"><%=trim(rs("Periodo"))%></td>
											<td height="20" class="celula"><%=trim(rs("Sala"))%></td>
											<td height="20" class="celula"><%=trim(rs("AnoLetivo"))%></td>
											<td height="20" class="celula"><%=trim(rs("cod_matriz"))%></td>
											<td height="20" class="celula"><%=trim(strMatrizDiferencia)%></td>
											<td height="20" class="celula"><%=trim(rs("Desc_turno"))%></td>
											<td height="20" class="celula"><%=trim(rs("Capacidade"))%></td>
											<td height="20" class="celula"><%=strDesvincularCriterioAvaliacaoLista%></td>
										  </tr>
										  <%				
										rs.movenext
									wend
									%>
									<tr>
										<td height="21" colspan="9" class="celula">Total Registros : <%=cont%></td>
									</tr>
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
	rs.close
	  
	%>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>