<!--#include file="includes/inc_verificaPerfilAcessoMatricula.asp"-->
<%
	mostraSelecione			  = "N"
	strExecutarSubmitCurso	  = "S"
	

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strEmpresaGrupo_submit = "S"

	intCodEmpresaGrupo 	= Trim(Request("cmbEmpresaGrupo"))
	strAnoLetivo 			= Trim(Request("txtAnoLetivo")) 
	strAnoLetivo = session("strAnoLetivo")	'ano letivo vem da sessão (Trocar Ano Letivo)
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurma 			= Trim(Request.Form("txtCodigo"))
	strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	if intCodCurso = "" then intCodCurso = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intCodTurno = "" then intCodTurno = "0"


	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strAtualizaVagasOcupadas= Trim(Request.Form("AtualizaVagasOcupadas"))
	
	ckAtualizaVagasOcupadas = ""
    if strAtualizaVagasOcupadas = "S" then ckAtualizaVagasOcupadas = " checked "	
	if intSemestre = "" then 	intSemestre  = session("strSemestre")	

	sql = "SELECT periodo_dinamico, ano_matricula"
	sql = sql & " FROM MAT_configuracoes where cod_grupo=" & session("codGrupo")
	rs.open sql, cnn
	
	if rs.eof = false then
		ano_matricula = rs("ano_matricula")
	end if 
	rs.close
	
	if strAnoLetivo = "" then 	
		strAnoLetivo = ano_matricula
	end if
		
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	retira_incluir="S"
	acao = ""
	IF perfilAlteracao = "S" THEN
		acao = "A"
	END IF
	strBotaoVoltaTelaAnterior = "N"
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_turmasCon.asp">
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
						<%if isnumeric(strAnoLetivo & "") and trim(strAnoLetivo & "") <> "" then%>
						<div class="alert alert-warning">
							<i class="fal fa-exclamation-triangle mr-1"></i>
							<strong>Atenção:</strong> esta tela mostra as turmas e vagas do ano letivo <strong><%=strAnoLetivo%></strong>.
							<%if isnumeric(ano_matricula & "") then%><%if clng(ano_matricula) <> clng(strAnoLetivo) then%>Para ver as vagas de <strong><%=ano_matricula%></strong>, troque o ano letivo no topo do sistema.<%end if%><%end if%>
						</div>
						<%end if%>
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						<div class="row">
							<div class="col-sm-1">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" readonly>
								</div>
							</div>
							<div class="col-sm-1">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							<div class="col-sm-10">
								<div class="form-group">
									<label class="form-label">Unidade:</label>
									 <!--#include file="includes/inc_cmbEmpresaGrupo.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row">	
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									 <!--#include file="includes/inc_cmdCurso.asp" -->
								</div>
							</div>
							<div class="col-sm-2 divDetalhamento">
								<div class="form-group">
									<label class="form-label">Período:</label>
									 <!--#include file="includes/inc_cmdPeriodo.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									 <!--#include file="includes/inc_cmdTurno.asp" -->
								</div>
							</div>
						</div>
						
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_consulta_novo.asp" -->
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%
	cont =0
	if intSemestre = "" then intSemestre = 0
	if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = 0

	sql = "SELECT T.Cod_Turma, t.VagasMatriculaInicial, T.Cod_GradeCurricular, c.descricao as curso, pp.descricao as periodo, T.Cod_Semestre, T.Cod_Turno, tt.Desc_Turno, isnull(T.Capacidade,'0') as Capacidade,"
	sql = sql & " T.Cod_PlanoPagamento, T.Cod_ContaCorrente, T.nomeTurma, T.Sala, T.Ano, T.AnoLetivo, T.TurmaAluno, isnull(T.VagasMatriculas,0) as VagasMatriculas, isnull(T.VagasMatriculasUtilizadas,0) as VagasMatriculasUtilizadas, "
	sql = sql & " isnull(T.VagasReservadas,0) as VagasReservadas," 
	'Guapó: a reserva (MAT_reserva) ainda não é alocada em turma (sem cod_turma_efetivado);
	'por enquanto só a TIP pendente conta como "aguardando efetivação"
	sql = sql & "     0"
	'TIP pendentes para a turma também aguardam efetivação (a escola de destino efetiva em mat_efetivacao.asp)
	sql = sql & "     + isnull((select count(*) from SCA_TRANSFERENCIA_INTERESSE_PROPRIO tip"
	sql = sql & "       where tip.COD_TURMA_DESTINO = t.Cod_turma and tip.SITUACAO = 'P'),0) as alocados_aguardando_efetivacao"
	
	sql = sql & " FROM SCA_TURMA T"
	sql = sql & " Inner join sca_Turno tt on TT.Cod_Turno = T.Cod_Turno "
	sql = sql & " inner join SCA_PERIODO pp on pp.Cod_Periodo = t.Cod_Periodo"
	sql = sql & " inner join SCA_CURSO c on c.Cod_curso = pp.cod_curso"
	
	sql = sql & " where isnull(c.Sigla,'') NOT IN ('AE','AT') and T.SITUACAO = 'A' AND T.Cod_empresa = " & intCodEmpresaGrupo		
	
	if strAnoLetivo <> "" then
		sql = sql & " and T.AnoLetivo = " & strAnoLetivo
	end if
	
	if intSemestre <> "0" then
		sql = sql & " and  T.Cod_Semestre = " & intSemestre
	end if
	
	if intCodPeriodo <> "0" then
		sql = sql & " and  t.Cod_Periodo = " & intCodPeriodo
	end if
	if intCodTurno <> "0" then
		sql = sql & " and  T.Cod_Turno = " & intCodTurno
	end if
	if intCodCurso <> "0" then
		sql = sql & " and  pp.cod_curso = " & intCodCurso
	end if
	
	sql = sql & " Order by t.AnoLetivo, c.descricao, pp.descricao, tt.Desc_Turno, t.Nometurma"
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
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Sala</strong></th>
									<th><strong>Curso</strong></th>
									<th><strong>Período</strong></th>
									<th><strong>Turno</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Capacidade<br>Real da Turma <%if perfilAlteracao = "S" then%><i class="subheader-icon fal fa-edit"></i><%end if%></strong></th>
									<th><strong>Aluno em Turma<br>(Novatos e Veteranos)</strong></th>
									<th><strong>Alocados<br>Aguardando Efetivação</strong></th>
									<th><strong>Vagas<br>Reservadas <%if perfilAlteracao="S" then%><i class="subheader-icon fal fa-edit"></i><%end if%></strong></th>
									<th><strong>Vagas Liberadas<br>para Alocação</strong></th>								
									
								  </tr>
								</thead>
								<tbody>
								
							  <%
									while not rs.eof
										cont = cont + 1	
							
										strCorLinha = ""
										VagasMatriculas = rs("VagasMatriculas")
										VagasMatriculasUtilizadas = rs("VagasMatriculasUtilizadas")
										vagasLiberadas = rs("VagasMatriculas")-rs("VagasMatriculasUtilizadas")-rs("VagasReservadas")-rs("alocados_aguardando_efetivacao")
			
										if cint(vagasLiberadas) < 0 then
											cor = "#f80707"
										else
											cor = "#009900"
										end if
										
										%>
										  <tr <%=strCorLinha%>>
											<td><%=trim(rs("Sala"))%></td>
											<td><%=trim(rs("curso"))%></td>
											<td><%=trim(rs("periodo"))%></td>
											<td align="center"><%=trim(rs("Desc_Turno"))%>&nbsp;</td>
											<td><input value="<%=rs("cod_turma")%>" type="hidden" name="txtCodTurma_<%=rs("cod_turma")%>" ><%=trim(rs("TurmaAluno"))%></td>
											<%if perfilAlteracao = "S" then%>
											<td align="center"><input name="txtNumCapacidade_<%=rs("Cod_Turma")%>" type="input" class="form-control" id="txtNumCapacidade_<%=rs("Cod_Turma")%>"   onKeyPress="return formataCampo(this, 2, 2)" value="<%=trim(rs("VagasMatriculas"))%>" size="3" maxlength="3"></td>
											<%else%>
											<td align="center"><input name="txtNumCapacidade_<%=rs("Cod_Turma")%>" type="hidden" class="form-control" id="txtNumCapacidade_<%=rs("Cod_Turma")%>" value="<%=trim(rs("VagasMatriculas"))%>"><%=trim(rs("VagasMatriculas"))%></td>
											<%end if%>
											<td align="center"><strong><%=trim(rs("VagasMatriculasUtilizadas"))%><strong></td>
											<td align="center"><strong><%=trim(rs("alocados_aguardando_efetivacao"))%><strong></td>
											<%if perfilAlteracao="S" then%>
												<td align="center"><input name="txtVagasMatriculasReservadas_<%=rs("Cod_Turma")%>" type="input" class="form-control"" id="txtVagasMatriculasUtilizadas<%=rs("Cod_Turma")%>"   onKeyPress="return formataCampo(this, 2, 2)" value="<%=rs("VagasReservadas")%>" size="3" maxlength="3"></td>									
											<%else%>
												<td align="center"><input name="txtVagasMatriculasReservadas_<%=rs("Cod_Turma")%>" type="hidden" id="txtVagasMatriculasUtilizadas<%=rs("Cod_Turma")%>" value="<%=rs("VagasReservadas")%>"><%=rs("VagasReservadas")%></td>																					
											<%end if%>
											<td align="center"><strong><font color="<%=cor%>"><%=vagasLiberadas%></font></strong></td>
										  </tr>
										  <%	
										  VagasReservadasTotal = VagasReservadasTotal + rs("VagasReservadas")
										  VagasMatriculasTotal = VagasMatriculasTotal + VagasMatriculas
										  VagasMatriculasUtilizadasTotal = VagasMatriculasUtilizadasTotal + VagasMatriculasUtilizadas
										  Vagasalocados_aguardando_efetivacaoTotal = Vagasalocados_aguardando_efetivacaoTotal + rs("alocados_aguardando_efetivacao")
										  vagasLiberadasTotal = vagasLiberadasTotal + vagasLiberadas
											IF perfilAlteracao = "S" THEN
												acao = "A"
											END IF
										rs.movenext
									wend
									%>
									<tr>
									<td align="right" colspan="5"><strong>Total de Quantitativo&nbsp;&nbsp;</strong></td>
									<td align="center"><strong><%=VagasMatriculasTotal%></strong></td>
									<td align="center"><strong><%=VagasMatriculasUtilizadasTotal%></strong></td>
									<td align="center"><strong><%=Vagasalocados_aguardando_efetivacaoTotal%></strong></td>
									<td align="center"><strong><%=VagasReservadasTotal%></strong></td>
									<td align="center"><strong><%=vagasLiberadasTotal%></strong></td>
								  </tr>
									<tr>
										<td  align="left" colspan="13"><strong>Total de Turmas: <%=cont%></strong></td>
									</tr>
								</tbody>
							</table>
							
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp" -->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> 
	<%
	end if
	rs.close

	'Ocorrências de alteração das VAGAS RESERVADAS (gravadas por mat_turmas_cod.asp em SCA_OCORRENCIA_TURMA)
	'Só para os perfis que podem alterar as vagas (gerente de matrícula / adm - inc_verificaPerfilAcessoMatricula.asp)
	if perfilAlteracao = "S" and clng("0" & intCodEmpresaGrupo) > 0 then
		sql = "SELECT TOP 500 O.DATAOCORRENCIA, T.TurmaAluno, pp.descricao AS periodo, tt.Desc_Turno, O.OCORRENCIA, iif(us.USUA_NOME_COMPLETO is null,O.USUARIO_INCL,us.USUA_NOME_COMPLETO) as USUARIO_INCL"
		sql = sql & " FROM SCA_OCORRENCIA_TURMA O"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = O.COD_TURMA"
		sql = sql & " INNER JOIN SCA_TURNO tt ON tt.Cod_Turno = T.Cod_Turno"
		sql = sql & " INNER JOIN SCA_PERIODO pp ON pp.Cod_Periodo = T.Cod_Periodo"
		sql = sql & " left JOIN SEG_USUARIOS_SISTEMA us ON us.USUA_CODG = O.USUARIO_INCL"
		sql = sql & " WHERE O.COD_EMPRESA = " & clng(intCodEmpresaGrupo)
		sql = sql & " AND O.OCORRENCIA LIKE '%vagas reservadas%'"
		if strAnoLetivo <> "" then sql = sql & " AND T.AnoLetivo = " & clng(strAnoLetivo)
		if intSemestre <> "0" then sql = sql & " AND T.Cod_Semestre = " & clng(intSemestre)
		if intCodPeriodo <> "0" then sql = sql & " AND T.Cod_Periodo = " & clng(intCodPeriodo)
		if intCodTurno <> "0" then sql = sql & " AND T.Cod_Turno = " & clng(intCodTurno)
		if intCodCurso <> "0" then sql = sql & " AND pp.cod_curso = " & clng(intCodCurso)
		sql = sql & " ORDER BY O.DATAOCORRENCIA DESC"
		set rsOcorr = Server.CreateObject("ADODB.Recordset")
		rsOcorr.open sql, cnn
		vetOcorr = ""
		if not rsOcorr.eof then vetOcorr = rsOcorr.getRows
		rsOcorr.close
		set rsOcorr = nothing
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-ocorr" class="panel">
				<div class="panel-hdr">
					<h2>
						Ocorrências de alteração das vagas reservadas <span class="fw-300"><i>(<%=strAnoLetivo%>)</i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if not isArray(vetOcorr) then%>
							<div class="alert alert-info m-0">Nenhuma alteração de vagas reservadas registrada para esta unidade com os filtros selecionados.</div>
						<%else%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover table-sm m-0">
								<thead class="thead-themed">
									<tr>
										<th><strong>Data / hora</strong></th>
										<th><strong>Período</strong></th>
										<th><strong>Turno</strong></th>
										<th><strong>Turma</strong></th>
										<th><strong>Ocorrência</strong></th>
										<th><strong>Usuário</strong></th>
									</tr>
								</thead>
								<tbody>
								<%for iOc = 0 to ubound(vetOcorr, 2)%>
									<tr>
										<td style="white-space:nowrap"><%=vetOcorr(0, iOc)%></td>
										<td><%=Server.HTMLEncode(trim(vetOcorr(2, iOc) & ""))%></td>
										<td><%=Server.HTMLEncode(trim(vetOcorr(3, iOc) & ""))%></td>
										<td><%=Server.HTMLEncode(trim(vetOcorr(1, iOc) & ""))%></td>
										<td><%=Server.HTMLEncode(trim(vetOcorr(4, iOc) & ""))%></td>
										<td><%=Server.HTMLEncode(trim(vetOcorr(5, iOc) & ""))%></td>
									</tr>
								<%next%>
								</tbody>
							</table>
							<%if ubound(vetOcorr, 2) >= 499 then%><small class="text-muted">Mostrando as 500 alterações mais recentes.</small><%end if%>
						</div>
						<%end if%>
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