<%
	strExecutarSubmitCurso = "S"
	strExecutarSubmitPeriodo = "S"
	strExecutarSubmitTurno = "S"
	strEmpresa_submit = "S"

	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	
	intCodCursoTip		= Trim(Request("cmbCurso"))
	intCodPeriodoTip	= Trim(Request("cmbPeriodo"))
	intCodTurno			= Trim(Request("cmbTurno"))
	intCodEmpresa		= Trim(Request("cmbEmpresa"))
	intCodTurma			= Trim(Request("cmbTurma"))
	
	
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	strAnoLetivoDestino = strAnoLetivo + 1

	if strTipoAtendimento="" then strTipoAtendimento ="0"
	
	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula, cod_situacaoaluno from sca_aluno"
		sql = sql & " where matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
		    intCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			intCodSituacaoAluno = Trim(rs("cod_situacaoaluno"))
		else
			strCodAluno			= 0
		    intCodAluno			= ""
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close	
	
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if

	acao="I"

	'TIP já feita para o aluno no ano: mostra na lista e bloqueia o Incluir
	vetTip = ""
	if strCodAluno <> "" and strCodAluno <> "0" then
		sql = "SELECT TIP.CODIGO, TIP.ANO_LETIVO,"
		sql = sql & " EO.RAZAOSOCIAL AS UNIDADE_ORIGEM, LTRIM(RTRIM(ISNULL(PO.Descricao,'') + ' ' + ISNULL(TOR.TurmaAluno,'') + ' ' + ISNULL(TOR.NomeTurma,''))) AS TURMA_ORIGEM,"
		sql = sql & " ED.RAZAOSOCIAL AS UNIDADE_DESTINO, LTRIM(RTRIM(ISNULL(PD.Descricao,'') + ' ' + ISNULL(TDE.TurmaAluno,'') + ' ' + ISNULL(TDE.NomeTurma,''))) AS TURMA_DESTINO,"
		sql = sql & " TUD.Desc_Turno AS TURNO_DESTINO, TIP.USUARIO_INCL, TIP.DATA_HORA_INCL,"
		sql = sql & " ISNULL(TIP.SITUACAO, 'E') AS SITUACAO, TIP.DATA_HORA_EFETIVACAO, TIP.USUARIO_EFETIVACAO,"
		sql = sql & " TIP.DATA_HORA_CANCELAMENTO, TIP.MOTIVO_CANCELAMENTO"
		sql = sql & " FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP"
		sql = sql & " LEFT JOIN SEG_EMPRESA EO ON EO.CODIGO = TIP.COD_EMPRESA"
		sql = sql & " LEFT JOIN SEG_EMPRESA ED ON ED.CODIGO = TIP.COD_EMPRESA_DESTINO"
		sql = sql & " LEFT JOIN SCA_TURMA TOR ON TOR.Cod_Turma = TIP.COD_TURMA"
		sql = sql & " LEFT JOIN SCA_PERIODO PO ON PO.Cod_Periodo = TOR.Cod_periodo"
		sql = sql & " LEFT JOIN SCA_TURMA TDE ON TDE.Cod_Turma = TIP.COD_TURMA_DESTINO"
		sql = sql & " LEFT JOIN SCA_PERIODO PD ON PD.Cod_Periodo = TDE.Cod_periodo"
		sql = sql & " LEFT JOIN SCA_TURNO TUD ON TUD.Cod_Turno = TIP.COD_TURNO_DESTINO"
		sql = sql & " WHERE TIP.COD_ALUNO = " & clng(strCodAluno)
		sql = sql & " AND TIP.ANO_LETIVO = " & clng(strAnoLetivo)
		sql = sql & " ORDER BY TIP.CODIGO DESC"
		rs.open sql, cnn
		if not rs.eof then vetTip = rs.getRows
		rs.close
	end if
	'Colunas de vetTip: 0 CODIGO | 1 ANO_LETIVO | 2 UNIDADE_ORIGEM | 3 TURMA_ORIGEM | 4 UNIDADE_DESTINO
	'                   5 TURMA_DESTINO | 6 TURNO_DESTINO | 7 USUARIO_INCL | 8 DATA_HORA_INCL
	'                   9 SITUACAO (P pendente | E efetivada | C cancelada) | 10 DATA_HORA_EFETIVACAO | 11 USUARIO_EFETIVACAO
	'                   12 DATA_HORA_CANCELAMENTO | 13 MOTIVO_CANCELAMENTO
	'TIP ativa (pendente ou efetivada) bloqueia nova TIP; cancelada não bloqueia
	blnTipAtiva = false
	if isArray(vetTip) then
		for iTip = 0 to ubound(vetTip, 2)
			if trim(vetTip(9, iTip) & "") <> "C" then blnTipAtiva = true
		next
	end if
	if blnTipAtiva then retira_incluir = "S"

	'TIP exige RENOVAÇÃO nesta unidade para o ano de destino (vaga garantida aqui se a TIP não for efetivada)
	strRenovacaoAluno = ""
	blnSemRenovacao = false
	if strCodAluno <> "" and strCodAluno <> "0" then
		sql = "SELECT TOP 1 R.ANO_LETIVO_RENOVACAO, LTRIM(RTRIM(ISNULL(P.Descricao,'') + ' ' + ISNULL(T.TurmaAluno,'') + ' ' + ISNULL(T.NomeTurma,''))) AS TURMA"
		sql = sql & " FROM SCA_ALUNO_RENOVACAO R"
		sql = sql & " LEFT JOIN SCA_TURMA T ON T.Cod_Turma = R.COD_TURMA_RENOVACAO"
		sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = T.Cod_periodo"
		sql = sql & " WHERE R.COD_ALUNO = " & clng(strCodAluno) & " AND R.ANO_LETIVO = " & clng(strAnoLetivo)
		sql = sql & " AND R.ANO_LETIVO_RENOVACAO = " & clng(strAnoLetivoDestino) & " AND R.COD_EMPRESA = " & clng(Session("CodEmpresa"))
		sql = sql & " ORDER BY R.CODIGO DESC"
		rs.open sql, cnn
		if not rs.eof then strRenovacaoAluno = trim(rs("TURMA") & "") & " em " & rs("ANO_LETIVO_RENOVACAO")
		rs.close
		blnSemRenovacao = (strRenovacaoAluno = "")
		'Exceção: terminalidade (ex.: INFANTIL V numa escola sem 1º ANO): TIP liberada sem renovação
		strTerminalidade = ""
		if blnSemRenovacao then
			strTerminalidade = tipTerminalidadeSemRenovacao(strCodAluno, Session("CodEmpresa"), strAnoLetivo, strAnoLetivoDestino)
			if strTerminalidade <> "" then blnSemRenovacao = false
		end if
	end if

	'TIP só para aluno ATIVO nesta unidade (vínculo ativo na turma e situação ativa no ano)
	blnAlunoInativo = false
	if strCodAluno <> "" and strCodAluno <> "0" and not blnTipAtiva then
		sql = "SELECT"
		sql = sql & " (SELECT COUNT(*) FROM SCA_ALUNO_TURMA AT WHERE AT.COD_EMPRESA = " & clng(Session("CodEmpresa"))
		sql = sql & "   AND AT.COD_ALUNO = " & clng(strCodAluno) & " AND AT.ANO_LETIVO = " & clng(strAnoLetivo) & " AND AT.SITUACAO = 'A') AS VINCULOS,"
		sql = sql & " ISNULL((SELECT TOP 1 CS.COD_SITUACAOALUNO FROM SCA_CONTROLE_SITUACAO_ALUNO CS WHERE CS.COD_EMPRESA = " & clng(Session("CodEmpresa"))
		sql = sql & "   AND CS.COD_ALUNO = " & clng(strCodAluno) & " AND CS.ANO_LETIVO = " & clng(strAnoLetivo) & " ORDER BY CS.CODIGO DESC), 1) AS SITUACAO"
		rs.open sql, cnn
		if not rs.eof then
			if clng(rs("VINCULOS")) = 0 or clng(rs("SITUACAO")) <> 1 then blnAlunoInativo = true
		end if
		rs.close
	end if
	if blnAlunoInativo then retira_incluir = "S"
	'sem renovação para o ano de destino: não pode incluir TIP (aluno ativo e sem TIP ativa)
	if blnSemRenovacao and not blnTipAtiva and not blnAlunoInativo then retira_incluir = "S" else blnSemRenovacao = false


%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_tip.asp">
<input type="hidden" name="txtCodSituacaoAluno" value="<%=intCodSituacaoAluno%>">
<input type="hidden" name="txtAnoLetivoDestino" value="<%=strAnoLetivoDestino%>">
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
				<%=descricao_pagina%> - <%=strAnoLetivoDestino%>
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
										
						<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
						<input name="txtCodTip" type="hidden" id="txtCodTip" value="">
						<%if blnAlunoInativo then%>
						<div class="alert alert-danger">
							<i class="fal fa-ban mr-1"></i>
							Este aluno <strong>não está ativo</strong> em uma turma desta unidade em <%=strAnoLetivo%>.
							Somente alunos ativos na unidade podem fazer TIP.
						</div>
						<%end if%>
						<%if blnSemRenovacao then%>
						<div class="alert alert-danger">
							<i class="fal fa-ban mr-1"></i>
							<strong>(sem renovação)</strong> Este aluno <strong>não está renovado para <%=strAnoLetivoDestino%></strong> nesta unidade.
							Para fazer a TIP, faça primeiro a renovação em Matrícula &gt; Renovação: ela garante a vaga do aluno aqui se a TIP não for efetivada.
						</div>
						<%elseif strTerminalidade <> "" and not blnTipAtiva then%>
						<div class="alert alert-info">
							<i class="fal fa-info-circle mr-1"></i>
							<strong>(terminalidade)</strong> Esta unidade não tem turma de <strong><%=server.htmlEncode(strTerminalidade)%></strong> em <%=strAnoLetivoDestino%>:
							o aluno não tem como ser renovado aqui e pode fazer a TIP sem renovação.
						</div>
						<%elseif strRenovacaoAluno <> "" and not blnTipAtiva then%>
						<div class="alert alert-info">
							<i class="fal fa-info-circle mr-1"></i>
							<strong>(renovação)</strong> Aluno renovado para <%=server.htmlEncode(strRenovacaoAluno)%>.
							Se a TIP não for efetivada pela unidade de destino, ele <strong>continua nessa turma</strong>; a vaga só é liberada quando a TIP for efetivada.
						</div>
						<%end if%>
						<%if blnTipAtiva then%>
						<div class="alert alert-warning">
							<i class="fal fa-exclamation-triangle mr-1"></i>
							<strong>(TIP)</strong> Este aluno já tem TIP em <%=strAnoLetivo%> (veja a lista abaixo). Para fazer outra, exclua a TIP atual.
						</div>
						<%end if%>
						
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
									<label class="form-label">
										<%if strRenovacaoAluno <> "" then%><span class="text-success fw-700">(renovação)</span>&nbsp;<%end if%>
										<%if blnTipAtiva then%><span class="text-danger fw-700">(TIP)</span><%end if%>&nbsp;
									</label>
									<input type="text" name="txtNomealuno" readonly id="txtNomealuno" class="form-control" value="<%=strNomeAluno%>">
								</div>
							</div>
						</div>
						<%'TIP pendente ou efetivada: esconde os campos de destino (cancelada permite nova TIP)%>
						<%if not blnTipAtiva then%>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Dados escolares</label>
									<%
									'Dados escolares da turma ATUAL (ativa neste ano letivo e nesta unidade), não da turma da renovação
									intAnoDadosAluno = strAnoLetivo
									intEmpresaDadosAluno = Session("CodEmpresa")
									%>
									<strong><!--#include file="includes/inc_sqlDadosAluno.asp" --></strong>
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-3">	
								<div class="form-group">
									<label class="form-label">Curso</label>
									<%
									'Período ATUAL do aluno = turma ativa NESTE ano letivo e nesta unidade (o de/para da TIP parte dela).
									'O inc_sqlDadosAluno pega o vínculo mais recente, que para aluno renovado é a turma do ano seguinte.
									if trim(intCodAluno & "") <> "" and trim(intCodAluno & "") <> "0" then
										rs.open "SELECT TOP 1 T.Cod_periodo FROM SCA_ALUNO_TURMA AT INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.COD_TURMA WHERE AT.COD_ALUNO = " & clng(intCodAluno) & " AND AT.COD_EMPRESA = " & clng(Session("CodEmpresa")) & " AND AT.ANO_LETIVO = " & clng(strAnoLetivo) & " AND AT.SITUACAO = 'A' ORDER BY AT.CODIGO DESC", cnn
										if not rs.eof then intCodPeriodo = rs("Cod_periodo")
										rs.close
									end if
									%>
									<!--#include file="includes/inc_cmbCursoTip.asp"-->
								</div>
							</div>	
						</div>
						<div class="row">
							<div class="col-sm-3">	
								<div class="form-group">
									<label class="form-label">Período</label>
									<!--#include file="includes/inc_cmbPeriodoTip.asp"-->
								</div>
							</div>	
						</div>
						<div class="row">
							<div class="col-sm-3">	
								<div class="form-group">
									<label class="form-label">Turno</label>
									<!--#include file="includes/inc_cmdTurno.asp"-->
								</div>
							</div>	
						</div>
						<div class="row">
							<div class="col-sm-3">	
								<div class="form-group">
									<label class="form-label">Unidade Escolar</label>
									<!--#include file="includes/inc_cmbEmpresaTip.asp"-->
								</div>
							</div>	
						</div>
						<div class="row">
							<div class="col-sm-3">	
								<div class="form-group">
									<label class="form-label">Turma com vaga disponível para <%=strAnoLetivoDestino%></label>
									<!--#include file="includes/inc_cmbTurmaTip.asp"-->
								</div>
							</div>	
						</div>
						<%end if%>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
<%
if isArray(vetTip) then
%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						TIP realizada - <%=strAnoLetivo%>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover table-sm m-0">
								<thead class="thead-themed">
									<tr>
										<th><strong>Unidade de origem</strong></th>
										<th><strong>Turma de origem</strong></th>
										<th><strong>Unidade de destino</strong></th>
										<th><strong>Turma de destino</strong></th>
										<th><strong>Turno</strong></th>
										<th><strong>Feita por / em</strong></th>
										<th class="text-center"><strong>Situação</strong></th>
										<th class="text-center"><strong>Excluir</strong></th>
										<th class="text-center"><strong>Imprimir</strong></th>
									</tr>
								</thead>
								<tbody>
								<%
								for i = 0 to ubound(vetTip, 2)
									'Pendente: a origem pode excluir. Efetivada: só a unidade de destino desfaz (tela de Efetivação)
									strSituacaoTip = trim(vetTip(9, i) & "")
									strMotivoBloqueio = ""
									if strSituacaoTip = "C" then
										strMotivoBloqueio = "TIP cancelada: " & trim(vetTip(13, i) & "")
									elseif strSituacaoTip <> "P" then
										strMotivoBloqueio = "TIP já efetivada pela unidade de destino. Somente a unidade de destino pode desfazer, na tela de Efetivação (filtro TIP)."
									end if
								%>
									<tr>
										<td><%=vetTip(2, i)%></td>
										<td><%=vetTip(3, i)%></td>
										<td><%=vetTip(4, i)%></td>
										<td><%=vetTip(5, i)%></td>
										<td><%=vetTip(6, i)%></td>
										<td><%=vetTip(7, i)%><br><small><%=vetTip(8, i)%></small></td>
										<td class="text-center">
										<%if strSituacaoTip = "P" then%>
											<span class="badge badge-warning">Aguardando efetivação</span>
										<%elseif strSituacaoTip = "C" then%>
											<span class="badge badge-danger" title="<%=server.htmlEncode(trim(vetTip(13, i) & ""))%>" data-toggle="tooltip">Cancelada</span>
											<%if not isnull(vetTip(12, i)) then%><br><small><%=vetTip(12, i)%></small><%end if%>
										<%else%>
											<span class="badge badge-success">Efetivada</span>
											<%if not isnull(vetTip(10, i)) then%><br><small><%=vetTip(11, i)%><br><%=vetTip(10, i)%></small><%end if%>
										<%end if%>
										</td>
										<td class="text-center">
										<%if strMotivoBloqueio <> "" then%>
											<span title="<%=server.htmlEncode(strMotivoBloqueio)%>" data-toggle="tooltip">
												<button type="button" class="btn btn-sm btn-outline-secondary" disabled style="pointer-events: none;">
													<i class="fal fa-lock"></i>
												</button>
											</span>
										<%else%>
											<button type="button" class="btn btn-sm btn-outline-danger" title="Excluir a TIP (ainda não efetivada)"
												onClick="excluirTip('<%=vetTip(0, i)%>', '<%=replace(replace(strNomeAluno & "", "\", ""), "'", "\'")%>')">
												<i class="fal fa-times"></i>
											</button>
										<%end if%>
										</td>
										<td class="text-center">
											<button type="button" class="btn btn-sm btn-outline-info" title="Imprimir o comprovante da TIP"
												onClick="imprimirTip('<%=vetTip(0, i)%>')">
												<i class="fal fa-print"></i>
											</button>
										</td>
									</tr>
								<%
								next
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