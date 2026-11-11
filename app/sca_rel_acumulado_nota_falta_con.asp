<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
    strExecutarSubmit         = "S"  
	
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
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
    intCodSituacaoAluno     = Trim(Request.Form("cmbSituacaoAluno"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
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

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_acumulado_nota_faltaCon.asp">
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
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									<!--#include file="includes/inc_cmdCurso.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Per&iacute;odo:</label>
									<!--#include file="includes/inc_cmdPeriodo.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurma.asp" -->
								</div>
							</div>
						
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Situa&ccedil;&atilde;o:</label>
									<!--#include file="includes/inc_cmdSituacaoAluno.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Tamanho da Fonte:</label>
									 <!--#include file="includes/inc_cmbTamanhoFonteArial.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Extrato por Folha:</label>
									 <!--#include file="includes/inc_cmbExtratoPorFolha.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Mostrar Resultado:</label>
									<input type="checkbox" checked name="resultadoFinal" value="S">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Resultado Definitivo:</label>
									<input type="checkbox" checked name="txtTipoResultadoFinal" value="D">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Mostrar C.H.:</label>
									<input type="checkbox" checked name="CH" value="S">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Mostrar (%) Faltas:</label>
									<input type="checkbox" checked name="PercFaltas" value="S">
								</div>
							</div>
						</div>
						<%
						strSomenteFonte7 = ""
						strSomenteFonte8 = ""
						strSomenteFonte9 = "N"
						strSomenteFonte10 = "N"
						strSomenteFonte11 = "N"
						strSomenteFonte12 = "N"
						%>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<strong>Obs:</strong> Para a impress&atilde;o da Acumulada de Notas e faltas, seu navegador dever&aacute; ser configurado com as margens direita 05, esquerda 05, superior 05 e inferior 5. Dever&aacute; tamb&eacute;m ser exclu&iacute;do cabe&ccedil;alho e rodap&eacute; de seu navegador na op&ccedil;&atilde;o configurar p&aacute;gina.
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
	cont  = 0
	if intCodTurma    = "" then intCodTurma="0"
	if intCodPeriodo = "" then intCodPeriodo="0"
	if intCodSituacaoAluno = "" then intCodSituacaoAluno = "0"

	if intCodTurma<>"0" and intCodCurso<>"0" and intCodPeriodo<>"0" then
	%>

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
								  </tr>
								</thead>
								<tbody>
								<%
								sql = "SELECT DISTINCT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATAMATRICULA , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURMA.TurmaAluno , TC.DESCRICAO AS TIPO_CRITERIO "
								sql = sql & " FROM SCA_ALUNO_TURMA "
								sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
								sql = sql & " INNER JOIN SCA_TURMA ON (SELECT TOP 1 COD_TURMA FROM SCA_ALUNO_TURMA WHERE COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo & " and SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ") ORDER BY CODIGO DESC) = SCA_TURMA.Cod_Turma "
								sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
								sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
								sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
								sql = sql & " INNER JOIN SCA_NOTAS_FALTAS NF ON NF.cod_aluno = SCA_ALUNO_TURMA.COD_ALUNO "
								sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO AND TAI.ANO_LETIVO = SCA_TURMA.ANOLETIVO"
								sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_calculo"
								sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
								sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
								if intSemestre <> "0" and intSemestre<>"" then
									sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
								end if
								if intCodCurso <> "0" then
									sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
								end if
								if intCodPeriodo <> "0" then
									sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
								end if
								if intCodTurno <> "0" then
									sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
								end if
								if intCodTurma <> "0" then
									sql = sql & " and SCA_TURMA.COD_TURMA = " & intCodTurma
								end if
								if intCodSituacaoAluno <> "0" then
									sql = sql & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
								end if
								sql = sql & " order by SCA_TURMA.NOMETURMA, SCA_ALUNO.NOMEALUNO"
								rs.open sql, cnn
								
								'Armazena o código de todos os alunos da turma'
								strAlunosTurma=""
								cont = 0
								if rs.eof = false then
									while not rs.eof
													cont = cont + 1
										strCodigoAluno        = rs("codigo")
										strMatricula		  = rs("MATRICULA")
										strNomeTurma		  = rs("TURMAALUNO") & " - " & rs("NOMETURMA")
										'Função que verifica a siuação do aluno
										strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
										if trim(strNomeTurma) <> trim(strNomeTurmaAnt) then
											%>
											  <thead class="thead-themed">
											  <tr>
												<td colspan="4" align="center"><strong>(<%=strNomeTurma%>)&nbsp;</strong></td>
												</tr>
											  <tr>
											  </thead>
											<%
										end if
										
										tipo_criterio = rs("tipo_criterio")
										if not isnull(tipo_criterio) then
											tipo_criterio = "<font color='blue'>&nbsp;(" & rs("tipo_criterio") & ")</font>"
										end if
										%>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=tipo_criterio%></td>
										</tr>
										 <%
										 strNomeTurmaAnt = strNomeTurma
										 rs.movenext
									  wend
									  %>
									   <tr>
										<td colspan="4" align="left"><strong>Quantidade de alunos: <%=cont%></strong></td>
									  </tr>
									  <%
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
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
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>