<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strAtualizaGrade_submit   = "S"
	strBotaoAtualizarTelaAtual = "S" 								
	strBotaoVoltaTelaAnterior = "N"
		
	intCodCurso	 		    = Trim(Request("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	IF intCodTurma = "" THEN intCodTurma = "0"
	IF intCodTurma <> "0" THEN
		sql = "SELECT COD_SEMESTRE" 
		sql = sql & " FROM SCA_TURMA"
		sql = sql & " WHERE COD_TURMA = " & intCodTurma
		sql = sql & " AND COD_EMPRESA = " & session("CodEmpresa")
		rs.open sql, cnn
		if not RS.EOF then
			intSemestre = RS("COD_SEMESTRE")
		end if
		rs.close
	END IF	
	
	if intCodDisciplinaTurma = "0" or intCodDisciplinaTurma = "" then
		sql = " select count(Cod_GradeCurricularDisciplina) as total "
		sql = sql & " from sca_gradecurriculardisciplina " 
		sql = sql & " where cod_gradecurricular in (select Cod_GradeCurricular from sca_turma where cod_turma = "&intCodTurma&")"
		rsAux.open sql, cnn
		if not rsAux.eof then
			intTotalDisciplinaMatriz	=  rsAux("TOTAL")
		else
			intTotalDisciplinaMatriz	=  "0"
		end if
		rsAux.close
	end if

	
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	strAtualizaGrade    	= Trim(Request.Form("cmbAtualizaGrade"))

	if intCodTurma <> "0" and intCodTurma <> "" then
		strTipoModulacao = "0"
		sql = "select P.Cod_Curso, ISNULL(C.Tipo_Modulacao,'P') as Tipo_Modulacao, T.NOMETURMA from SCA_TURMA T "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao='A' "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
		sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
		sql = sql & " WHERE T.COD_TURMA = " & intCodTurma 
		rsaux.open sql, cnn,3,3
		if not rsaux.EOF then
		   strTipoModulacao = rsaux("Tipo_Modulacao")
		end if
		rsaux.close		
	end if

	'controla os botões
	acao = "A"

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_atualiza_matriz_alunoCon.asp">
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
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									<!--#include file="includes/inc_cmdCurso.asp" -->- Opcional
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurma.asp" -->
								</div>
							</div>
							
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Tipo de Atualiza&ccedil;&atilde;o:</label>
									 <!--#include file="includes/inc_cmbAtualizaGradeCurricular.asp" -->
								</div>
							</div>
							<%if ( strTipoModulacao = "P" and strAtualizaGrade = "A" ) or strAtualizaGrade = "D" then %>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Disciplina:</label>
									 <!--#include file="includes/inc_cmbDisciplinaTurma.asp" -->
								</div>
							</div>
							<%end if%>
						</div>
						
						<%  if strAtualizaGrade = "D" then %>
							<script>
								alert("ATENÇÃO! Será Excluída GRADE DE NOTAS e FALTAS da disciplina informada, ou todas caso não seja feita nenhuma escolha.");
							</script>
						<% end if %>
						<%  if strAtualizaGrade = "A" then %>
							<script>
							   alert("ATENÇÃO! A GRADE DE NOTAS e FALTAS será atualizada, a disciplina existente será mantida.");
							</script>
						<% end if %>
						
						<br>
						<div class="frame-wrap">
							<%strBotaoConsultarTelaAtual="N"%>
							<!--#include file="includes/inc_botoes_consulta_novo.asp" -->
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%
	if intCodTurma    = "" then intCodTurma="0"

	if intCodTurma<>"0" then%>

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
						
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><input name="chkTodos" type="checkbox" value="" onClick="return MarcaTodosAlunos(this.checked)"></th>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Matriz</strong></th>
									<th><strong>Notas</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
									if strAtualizaGrade = "D" then		
										sql = " SELECT DISTINCT"
										sql = sql & " AD.COD_ALUNO AS CODIGO, " 
										sql = sql & " A.MATRICULA, "
										sql = sql & " A.NOMEALUNO, "
										sql = sql & " A.DATANASCIMENTO, "
										sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA "
										sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
										sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO "
										sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
										sql = sql & " AND ( AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma & " or AD.COD_TURMA= " & intCodTurma & ") "
										sql = sql & " union "
										sql = sql & " SELECT DISTINCT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_TURMA.COD_TURMA "
										sql = sql & " FROM SCA_ALUNO_TURMA "
										sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
										sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
										sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
										sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
										sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
										sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
										sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & session("CodEmpresa")
										if strAtualizaGrade <> "D" then  ' Se não for exclusão somente alunos ativos na turma
											sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A' "
										end if	
										sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
										sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestre
										if intCodCurso <> "0" then
											sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
										end if
										if intCodTurno <> "0" then
											sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
										end if
										if intCodTurma <> "0" then
											sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
										end if
										sql = sql & " Order By COD_TURMA, NOMEALUNO "
									else
										'SELECIONA OS ALUNOS DA TURMA
										sql = "SELECT DISTINCT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_TURMA.COD_TURMA "
										sql = sql & " FROM SCA_ALUNO_TURMA "
										sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
										sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
										sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
										sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
										sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
										sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso"
										sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & session("CodEmpresa")
										if strAtualizaGrade <> "D" then  ' Se não for exclusão somente alunos ativos na turma
											sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A' "
										end if	
										sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
										sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestre
										if intCodCurso <> "0" then
											sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
										end if
										if intCodTurno <> "0" then
											sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
										end if
										if intCodTurma <> "0" then
											sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
										end if
										sql = sql & " Order By SCA_TURMA.COD_TURMA, SCA_ALUNO.NOMEALUNO"
									end if	
									rs.open sql, cnn
									if rs.eof = false then
										cont = 0
										while not rs.eof
											cont = cont + 1
											strCodigoAluno        = rs("codigo")
											strMatricula		  = rs("MATRICULA")

											if intCodDisciplinaTurma = "0" or intCodDisciplinaTurma = "" then

												sql = "SELECT COUNT (CODIGO) AS TOTAL "
												sql = sql & " FROM SCA_ALUNO_DISCIPLINA "
												sql = sql & " WHERE	COD_ALUNO = " & strCodigoAluno
												rsAux.open sql, cnn
												if not rsAux.eof then
													intTotalDisciplinaALuno	=  rsAux("TOTAL")
												else
													intTotalDisciplinaALuno	=  "0"
												end if
												rsAux.close
												'
												if clng(intTotalDisciplinaALuno) >= clng(intTotalDisciplinaMatriz) then
													strpossuiGradeCurricular = "SIM"
												else
													strpossuiGradeCurricular = "N&Atilde;O"
												end if
												if clng(intTotalDisciplinaALuno) > 0 and clng(intTotalDisciplinaALuno) < clng(intTotalDisciplinaMatriz) then
													strpossuiGradeCurricular = "PARCIAL"
												end if
												sql = "SELECT COD_ALUNO_DISCIPLINA "
												sql = sql & " FROM SCA_NOTAS_FALTAS "
												sql = sql & " WHERE	COD_ALUNO = " & strCodigoAluno
												rsAux.open sql, cnn
												if not rsAux.eof then
													strPossuiNotas = "SIM"
												else
													strPossuiNotas = "N&Atilde;O"
												end if
												rsAux.close

											else
												sql = "SELECT CODIGO "
												sql = sql & " FROM SCA_ALUNO_DISCIPLINA "
												sql = sql & " WHERE	COD_ALUNO = " & strCodigoAluno
												sql = sql & " AND COD_DISCIPLINA = " & intCodDisciplinaTurma
												rsAux.open sql, cnn
												if not rsAux.eof then
													strpossuiGradeCurricular = "SIM"
												else
													strpossuiGradeCurricular = "N&Atilde;O"
												end if
												rsAux.close
							
												sql = "SELECT COD_ALUNO_DISCIPLINA "
												sql = sql & " FROM SCA_NOTAS_FALTAS "
												sql = sql & " WHERE	COD_ALUNO = " & strCodigoAluno
												sql = sql & " AND COD_DISCIPLINA = " & intCodDisciplinaTurma
												rsAux.open sql, cnn
												if not rsAux.eof then
													strPossuiNotas = "SIM"
												else
													strPossuiNotas = "N&Atilde;O"
												end if
												rsAux.close
											end if
										 %>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina">
												<input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=tipo_criterio%></td>
											<td><%=strpossuiGradeCurricular%></td>
											<td><%=strPossuiNotas%></td>
										</tr>
										 <%
										 rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
									 <td colspan="6" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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