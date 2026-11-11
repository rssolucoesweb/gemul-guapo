<%
	'PERFIL COORDENADORES - 17
	'PERFIL PROFESSORES   - 11
	'PERFIL ADMINISTRADOR - 2
	'PERFIL SECREATARIO GERAL - 15		
	strCodPefilAcesso = "11,17,2,15"
%>
<!--#include file="includes/inc_VerificaAcessoPerfilAdmProfessor.asp"-->
<%
'RESPONSE.WRITE "intCodProfessor:" & intCodProfessor
'RESPONSE.WRITE "strAcessoPerfil:" & strAcessoPerfil

	if intCodProfessor="" or strAcessoPerfil="" then
		%>
		<script>
			//alert("Essa funcionalidade do Planejamento do professor por turma, deve ser utilizada pelo professor ou coordenador, você deverá ter acesso a algum desse perfil!")
		</script>
		<%
		'response.end
	end if
	
	acao = "I"
	strBotaoVoltaTelaAnterior = "N"
	strExecutarSubmitCurso = "S"
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")

	intCodTurmaProfessor = request("cmbTurmaProfessor")


	intSemestre = session("strSemestre")
	strConsultar			= Trim(Request.Form("strConsultar"))
	intCodTurnoRH			= Trim(Request.Form("cmbTurnoRH"))
	if intCodTurnoRH = "" then intCodTurnoRH = "0"
	
	intCodCurso				= Trim(Request.Form("cmbCurso"))
	if intCodCurso = "" then intCodCurso = "0"	
	intCodPeriodo			= Trim(Request.Form("cmbPeriodo"))
	if intCodPeriodo = "" then intCodPeriodo = "0"
	
	intCodDisciplina			= Trim(Request.Form("cmbDisciplinaDoProfessorPlanejamento"))
	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	if intCodProfessor="" or intCodProfessor = "0" then
		intCodProfessor			= Trim(Request.Form("cmbProfessor"))
	end if

	intCodColaboradorProfessor = intCodProfessor
	strExecutarSubmitTurma = "S"
	sql = "select codigo, CodCategoria "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and (CodCategoria = 1 OR CodCategoria = 8)"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		strTipoAcessoCadastroNotas = "PROF"
		strExecutarSubmitDisciplinaDoProfessor = "S"
		strAnoLetivo = session("strAnoLetivo")
		intSemestre = session("strSemestre")
	else
		if rs("CodCategoria") = "8" then
			strTipoAcessoCadastroNotas = "PROF"
			strExecutarSubmitDisciplinaDoProfessor = "S"
			strAnoLetivo = session("strAnoLetivo")
			intSemestre = session("strSemestre")
		else
			if (Session("Seg_CodCategoria") = "1") then
				strTipoAcessoCadastroNotas = "PROF"
				intCodColaboradorProfessor = rs("codigo")
				intCodProfessor = intCodColaboradorProfessor
				strExecutarSubmitDisciplinaDoProfessor = "S"
				strAnoLetivo = session("strAnoLetivo")
				intSemestre = session("strSemestre")
			else
				strTipoAcessoCadastroNotas = "PROF"
				strExecutarSubmitDisciplinaDoProfessor = "S"
				strAnoLetivo = session("strAnoLetivo")
				intSemestre = session("strSemestre")
			END IF	
		end if
	end if
	rs.close		
	
	strVerificaTurmaProfessor	= "Professor"	
	
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
	<form id="frm" name="frm" method="post">

	<input type="hidden" name="pagina" id="pagina" value="<%=strControlePagina%>">

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
						
							<input name="txtCodCurso" 		type="hidden" id="txtCodCurso">
							<input name="txtCurso" 			type="hidden" id="txtCurso">
							<input name="txtCodPeriodo" 	type="hidden" id="txtCodPeriodo">
							<input name="txtPeriodo" 		type="hidden" id="txtPeriodo">
							<input name="txtCodTurno" 		type="hidden" id="txtCodTurno">
							<input name="txtTurno" 			type="hidden" id="txtTurno">
							<input name="txtCodDisciplina" 	type="hidden" id="txtCodDisciplina">
							<input name="txtDisciplina" 	type="hidden" id="txtDisciplina">
							<input name="txtCodTurma" 		type="hidden" id="txtCodTurma">
							<input name="txtTurma" 			type="hidden" id="txtTurma">
							<input name="txtSemestre" 		type="hidden" id="txtSemestre" value="<%=intSemestre%>">
							<input name="strConsultar" 		type="hidden" id="strConsultar" value="S">
							<!--input name="txtAnoLetivo" 		type="hidden" id="txtAnoLetivo"-->
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=strAnoLetivo%>" maxlength="4" onblur="submit()">
									</div>
								</div>
							</div>
							<%if strAcessoPerfil<>"PROFESSOR" then%>
							<div class="row">

								<div class="col-sm-5">
									<div class="form-group">
										<label class="form-label">Professor</label>
										<%retiraFiltroTurno="S" %>
										<!--#include file="includes/inc_cmdProfessorHorarioAulaTurno.asp" -->
										
									</div>
								</div>	
								
							</div>	
							<br>
							<div class="frame-wrap">
								<button onClick="submit()" type="button" class="btn btn-outline-info">Selecionar Professor</button>
							</div>
							<%end if%>

							<%if intCodProfessor<>"" and intCodProfessor <> "0" then%>
							<div class="row">


								<div class="col-sm-5">
									<div class="form-group">
										<label class="form-label">Turma</label>
										<!--#include file="includes/inc_cmdTurmaProfessorPlanejamento.asp"-->
										<%
										'response.write sql
										if intCodTurmaProfessor <>"" then
											intCodCurso = intCodComp
											intCodPeriodo = intCodSerie
											'intCodTurnoRH = intCodTurno
										end if										
										%>
									</div>
								</div>	

								<div class="col-sm-5">
									<div class="form-group">
										<label class="form-label">Curso</label>
										<!--#include file="includes/inc_cmdCursoTurmaProfessor.asp" -->
										<%if session("usuarioWeb") = "ROBERTO" THEN RESPONSE.WRITE SQL%>
									</div>
								</div>	
								
							</div>
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Período</label>
										<!--#include file="includes/inc_cmdPeriodoTurmaProfessor.asp" -->
									</div>
								</div>

								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Turno</label>
										<%
										filtroTurno="S"
										strExecutarSubmitTurno="S"
										%>
										<!--#include file="includes/inc_cmdTurnoHorarioProfessor.asp" -->
									</div>
								</div>	

							</div>	
							
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_consulta_novo.asp"-->
							</div>
							<%end if%>
						
					</div>
				</div>
			</div>
		</div>
	</div>
	<%

	IF strConsultar = "S" and intCodTurnoRH<>"0" then
		cont =0
		if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
		sql = " SELECT distinct sp.cor_linha_escola, c.nome as professor, pa.cod_situacao_planejamento, isnull(sp.descricao_escola,'Aguardando Secretaria') as situacao_planejamento, HA.Cod_Colaborador as codProfessor, HA.ANOLETIVO, HA.Semestre, CU.Descricao AS CURSO, P.Cod_Periodo, P.Descricao AS PERIODO, di.cod_disciplina as cod_disciplina, di.desc_disciplina as disciplina, tu.cod_turno, tu.desc_turno as turno, T.Cod_Turma, T.TurmaAluno"
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO" 
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador" 
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO "
		sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO"
		sql = sql & " INNER JOIN SRH_TURNO TU ON TU.Cod_Turno = H.CodTurno "
		sql = sql & " INNER JOIN SCA_DISCIPLINA DI ON DI.Cod_Disciplina = HA.Cod_Disciplina"
		sql = sql & " left join SCA_PLANEJAMENTO_GERAL pa on pa.anoLetivo=ha.AnoLetivo and pa.cod_disciplina = ha.Cod_Disciplina and pa.cod_empresa = ha.cod_empresa and pa.cod_periodo = t.Cod_periodo and pa.semestre = ha.Semestre"
		sql = sql & " left join SCA_SITUACAO_PLANEJAMENTO sp on sp.cod_situacao_planejamento_anual = pa.cod_situacao_planejamento"
		sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
		sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
		if intCodTurnoRH<>"0" then
			sql = sql & " AND tu.Cod_Turno = " & intCodTurnoRH
		end if
		sql = sql & " AND P.COD_PERIODO = " & intCodPeriodo
		'sql = sql & " AND (HA.Cod_Colaborador = " & intCodProfessor & " or T.COD_TURMA=" & intCodTurmaProfessor & ")"
		sql = sql & " AND HA.Cod_Colaborador = " & intCodProfessor
		sql = sql & " AND T.COD_TURMA=" & intCodTurmaProfessor
		if intCodDisciplina <> "0" then
			sql = sql & " AND DI.Cod_Disciplina = " & intCodDisciplina
		end if
		sql = sql & " order by ANOLETIVO, curso, periodo, turno, turmaaluno, disciplina"
		'response.write sql
		rs.open sql, cnn
		if rs.eof = false then
		%>
		<input name="txtProfessor" 		type="hidden" id="txtProfessor" value="<%=rs("professor")%>">
		<input name="txtCodProfessor" 		type="hidden" id="txtCodProfessor" value="<%=intCodProfessor%>">
		<div class="row">
			<div class="col-xl-12">
				<div id="panel-1" class="panel">
					<div class="panel-hdr">
						<h2>
							<%=pagina%> cadastrados - <%=rs("professor")%>
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
										<th><strong>Ano Letivo</strong></th>
										<th><strong>Curso</strong></th>
										<th><strong>Período</strong></th>
										<th><strong>Turno</strong></th>
										<th><strong>Disciplina</strong></th>
										<th><strong>Turma</strong></th>
										<th><strong>Situação</strong></th>
									  </tr>
									</thead>
									<tbody>
								  <%
								while not rs.eof
									
									bloq = "S"
									if rs("cod_situacao_planejamento") = "7" then
										bloq = "N"
									end if
									%>
									  <tr <%=rs("cor_linha_escola")%> height="20" <%if bloq = "N" then%> style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("cod_turno")%>','<%=rs("turno")%>','<%=rs("cod_periodo")%>','<%=rs("periodo")%>','<%=rs("cod_disciplina")%>','<%=rs("disciplina")%>','<%=rs("cod_turma")%>','<%=rs("turmaAluno")%>','<%=rs("anoLetivo")%>')" <%end if%>>
										<td><%=rs("anoLetivo")%></td>
										<td><%=rs("curso")%></td>
										<td><%=rs("periodo")%></td>
										<td><%=rs("turno")%></td>
										<td><%=rs("disciplina")%></td>
										<td><%=rs("turmaAluno")%></td>
										<td><%=rs("situacao_planejamento")%></td>
									  </tr>
									  <%
									rs.movenext
								wend
								%>
										<tr>
											<td height="21" colspan="7" class="celula">Total Registros : <%=cont%></td>
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
	 end if
	%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>