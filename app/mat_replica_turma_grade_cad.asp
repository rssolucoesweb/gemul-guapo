<%
	'Versão nova de sistema/MAT/promoverTurmaGrade_cad.asp
	strExecutarSubmitSemestre	= ""

	'Ano letivo atual (origem da replicação)
	strAnoLetivo = Trim(Request.Form("txtAnoLetivo"))
	strAnoLetivo = session("strAnoLetivo")	'ano letivo vem da sessão (Trocar Ano Letivo)
	if strAnoLetivo = "" or not isnumeric(strAnoLetivo) then strAnoLetivo = session("strAnoLetivo")
	strAnoLetivo = clng(strAnoLetivo)

	'Ano letivo da replicação (destino): por padrão, o ano seguinte
	strAnoLetivoReplicacao = Trim(Request.Form("txtAnoLetivoReplicacao"))
	if strAnoLetivoReplicacao = "" or not isnumeric(strAnoLetivoReplicacao) then strAnoLetivoReplicacao = strAnoLetivo + 1

	intSemestre = Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" or intSemestre = "0" then intSemestre = "3"

	'Tipo de unidade: filtra a lista de unidades e, sem unidade escolhida,
	'a replicação vale para todas as unidades desse tipo
	strExecutarSubmitTipoEmpresa = "S"
	intCodTipoEmpresa = Trim(Request.Form("cmbTipoEmpresa"))
	if intCodTipoEmpresa = "" or not isnumeric(intCodTipoEmpresa) then intCodTipoEmpresa = "0"

	intCodEmpresaGrupo = Trim(Request.Form("cmbEmpresaGrupo"))

	'----- replicações já feitas a partir do ano atual
	vetReplicacoes = ""
	sql = "SELECT h.id_aut_grade_turma_historico, h.ano_atual, h.ano_promocao, e.razaosocial AS unidade,"
	sql = sql & " h.usuario_incl, h.data_hora_incl, h.situacao, h.cod_empresa, te.Descricao AS tipo_empresa"
	sql = sql & " FROM MAT_aut_grade_turma_historico h"
	sql = sql & " LEFT JOIN SEG_EMPRESA e ON e.codigo = h.cod_empresa"
	sql = sql & " LEFT JOIN SEG_TipoEmpresa te ON te.CODIGO = h.cod_tipo_empresa AND te.COD_GRUPO = " & clng("0" & session("CodGrupo"))
	sql = sql & " WHERE h.ano_atual = " & strAnoLetivo
	sql = sql & " ORDER BY h.data_hora_incl DESC"
	rs.open sql, cnn
	if not rs.eof then vetReplicacoes = rs.getRows
	rs.close
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_replica_turma_grade.asp">
	<input type="hidden" name="txtIdReplicacao" id="txtIdReplicacao" value="">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-copy'></i> <%=pagina%>
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
						<div class="panel-tag">
							Copia as matrizes curriculares (grades) e as turmas ativas do <strong>ano letivo atual</strong> para o <strong>ano letivo da replicação</strong>.
							Escolha uma unidade ou deixe <strong>Selecione...</strong> para replicar <strong>todas as unidades</strong>
							(ou todas as unidades do <strong>tipo de unidade</strong> escolhido).
							A replicação só pode ser cancelada enquanto as novas turmas e grades não tiverem alunos.
						</div>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label" for="txtAnoLetivo">Ano letivo atual</label>
									<input type="number" class="form-control" name="txtAnoLetivo" id="txtAnoLetivo" value="<%=strAnoLetivo%>" min="2000" max="2100" readonly>
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre atual</label>
									<!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label" for="txtAnoLetivoReplicacao">Ano letivo replicação</label>
									<input type="number" class="form-control" name="txtAnoLetivoReplicacao" id="txtAnoLetivoReplicacao" value="<%=strAnoLetivoReplicacao%>" min="2000" max="2100">
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Tipo de unidade</label>
									<%retirarDaComboTipoUnidade = 5%>
									<!--#include file="includes/inc_cmbTipoEmpresa.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Unidade</label>
									<!--#include file="includes/inc_cmbEmpresaGrupo.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<button onClick="salvar()" type="button" class="btn btn-outline-success" id="btnReplicar">Replicar</button>
							<button onClick="window.location='mat_replica_turma_grade.asp'" type="button" class="btn btn-outline-warning">Limpar tela</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Lista de replicações - <%=strAnoLetivo%>
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
										<th><strong>Ano atual</strong></th>
										<th><strong>Ano replicação</strong></th>
										<th><strong>Unidade</strong></th>
										<th><strong>Usuário</strong></th>
										<th><strong>Data</strong></th>
										<th><strong>Situação</strong></th>
										<th class="text-center"><strong>Cancelar</strong></th>
									</tr>
								</thead>
								<tbody>
								<%
								if isArray(vetReplicacoes) then
									'Colunas: 0 id | 1 ano_atual | 2 ano_promocao | 3 unidade | 4 usuario_incl | 5 data_hora_incl | 6 situacao | 7 cod_empresa | 8 tipo_empresa
									for i = 0 to ubound(vetReplicacoes, 2)
										strSituacao = trim(vetReplicacoes(6, i) & "")
										select case strSituacao
											case "A" : strDescSituacao = "<strong class=""rep-processada"">Processada</strong>"
											case "C" : strDescSituacao = "<strong class=""rep-cancelada"">Cancelada</strong>"
											case "N" : strDescSituacao = "<strong class=""rep-cancelada"">Não processada</strong>"
											case else : strDescSituacao = strSituacao
										end select

										strUnidade = trim(vetReplicacoes(3, i) & "")
										if strUnidade = "" or trim(vetReplicacoes(7, i) & "") = "0" then
											strUnidade = "<strong>TODAS AS UNIDADES</strong>"
											if trim(vetReplicacoes(8, i) & "") <> "" then strUnidade = strUnidade & " do tipo <strong>" & trim(vetReplicacoes(8, i) & "") & "</strong>"
										end if
										%>
									<tr>
										<td><%=vetReplicacoes(1, i)%></td>
										<td><%=vetReplicacoes(2, i)%></td>
										<td><%=strUnidade%></td>
										<td><%=vetReplicacoes(4, i)%></td>
										<td><%=vetReplicacoes(5, i)%></td>
										<td><%=strDescSituacao%></td>
										<td class="text-center">
										<%if strSituacao = "A" then%>
											<button type="button" class="btn btn-sm btn-outline-danger" title="Cancelar esta replicação"
												onClick="cancelarReplicacao('<%=vetReplicacoes(0, i)%>', '<%=vetReplicacoes(1, i)%>', '<%=vetReplicacoes(2, i)%>')">
												<i class="fal fa-times"></i>
											</button>
										<%end if%>
										</td>
									</tr>
										<%
									next
								else
									%>
									<tr>
										<td colspan="7" class="text-center">Nenhuma replicação feita a partir de <%=strAnoLetivo%>.</td>
									</tr>
									<%
								end if
								%>
								</tbody>
							</table>
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
