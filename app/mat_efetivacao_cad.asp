<%
	Session("MatriculaInformatizada") =  "SIM"

	dinamico = "N"
	sql = "select PERIODO_DINAMICO, ano_matricula from MAT_configuracoes where cod_grupo=" & session("codGrupo")
	rs.open sql, cnn
	if not rs.eof then
		Session("MatriculaInformatizadaAnoEfetivacao")	= rs("ano_matricula") '***IMPORTANTE ANO DA MATRÍCULA DEVE SER INFORMADO NA TELA DE CONFIGURAÇÕES
	end if
	rs.close

	
	strCod_empresa 		= Session("CodEmpresa")
	intTipo		= Trim(Request("cmbTipo"))
	if intTipo = "" then intTipo = "1"
	'Função: NOVO = aluno novato (inscrição) | TIP = transferência por interesse próprio para esta unidade
	strFuncao = ucase(Trim(Request("cmbFuncao")))
	if strFuncao <> "TIP" then strFuncao = "NOVO"
	'3 = TIP canceladas (só consulta; não existe para novatos)
	if intTipo <> "1" and intTipo <> "2" and intTipo <> "3" then intTipo = "1"
	if intTipo = "3" and strFuncao <> "TIP" then intTipo = "1"
	intAnoTipOrigem = 0
	if isnumeric(Session("strAnoLetivo") & "") and trim(Session("strAnoLetivo") & "") <> "" then intAnoTipOrigem = clng(Session("strAnoLetivo"))
	'Ano mostrado no título e usado nas listas: ano letivo da sessão (topo da tela)
	'Guapó: novatos = MAT_inscricao da unidade (sem filtro de ano, como a tela antiga) | TIP = TIP com destino neste ano
	strAnoTitulo = intAnoTipOrigem
	if strFuncao = "NOVO" then strAnoTitulo = Session("MatriculaInformatizadaAnoEfetivacao")	'Guapó: ano da matrícula (Configurações)
	intInscricao		= Trim(Request("txtInscricao"))
	strNomealuno 		= Trim(Request.Form("txtNomealuno"))
	strBotaoVoltaTelaAnterior = "N"
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_efetivacao.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%><%if strAnoTitulo & "" <> "" then%> - <%=strAnoTitulo%><%end if%>
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
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Efetivação de:</label>
									<select name="cmbFuncao" id="cmbFuncao" class="form-control" onchange="submit()">
										<option value="NOVO" <% if strFuncao = "NOVO" then response.Write("selected")%>>Alunos novatos (inscrição)</option>
										<option value="TIP" <% if strFuncao = "TIP" then response.Write("selected")%>>TIP - Transferência por interesse próprio</option>
									</select>
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Filtro:</label>
									<select name="cmbTipo" id="cmbTipo"  class="form-control" onchange="submit()">
										<option value="1" <% if intTipo = "1" then response.Write("selected")%>>Não efetivados</option>
										<option value="2" <% if intTipo = "2" then response.Write("selected")%>>Efetivados</option>
										<%if strFuncao = "TIP" then%><option value="3" <% if intTipo = "3" then response.Write("selected")%>>Canceladas</option><%end if%>
									</select>
								</div>
							</div>
						</div>
						<%if strFuncao <> "TIP" then%>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Inscrição:</label>
									<input name="txtInscricao" type="text" class="form-control" id="txtInscricao" value="<%=intInscricao%>" size="20" maxlength="10"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
								</div>
							</div>
						</div>
						<%end if%>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Nome do Aluno:</label>
									<input name="txtNomealuno" type="text" class="form-control" id="txtNomealuno" value="<%=strNomealuno%>" maxlength="200">
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
	
	<%if strFuncao = "TIP" then
	'=====================================================================
	' TIP - transferência por interesse próprio PARA esta unidade
	'	Não efetivados: TIP pendente (aluno ainda ativo na origem) -> Efetivar
	'	Efetivados: TIP efetivada -> Desfazer (SP_MAT_TipDesfaz) e Imprimir
	'=====================================================================
	vetTipEfet = ""
	sql = "SELECT TIP.CODIGO, A.MATRICULA, A.NOMEALUNO, A.DATANASCIMENTO, A.MAE,"
	sql = sql & " EO.RAZAOSOCIAL AS UNIDADE_ORIGEM,"
	sql = sql & " LTRIM(RTRIM(ISNULL(PO.Descricao,'') + ' ' + ISNULL(TOR.TurmaAluno,'') + ' ' + ISNULL(TOR.NomeTurma,''))) AS TURMA_ORIGEM,"
	sql = sql & " LTRIM(RTRIM(ISNULL(PD.Descricao,'') + ' ' + ISNULL(TDE.TurmaAluno,'') + ' ' + ISNULL(TDE.NomeTurma,''))) AS TURMA_DESTINO,"
	sql = sql & " TUD.Desc_Turno AS TURNO_DESTINO, TIP.USUARIO_INCL, TIP.DATA_HORA_INCL, TIP.USUARIO_EFETIVACAO, TIP.DATA_HORA_EFETIVACAO,"
	sql = sql & " ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO + 1) AS ANO_DESTINO, dbo.FN_MAT_TipPrazoConfirmacao(TIP.CODIGO) AS PRAZO,"
	sql = sql & " TIP.DATA_HORA_CANCELAMENTO, TIP.MOTIVO_CANCELAMENTO"
	sql = sql & " FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP"
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = TIP.COD_ALUNO"
	sql = sql & " LEFT JOIN SEG_EMPRESA EO ON EO.CODIGO = TIP.COD_EMPRESA"
	sql = sql & " LEFT JOIN SCA_TURMA TOR ON TOR.Cod_Turma = TIP.COD_TURMA"
	sql = sql & " LEFT JOIN SCA_PERIODO PO ON PO.Cod_Periodo = TOR.Cod_periodo"
	sql = sql & " LEFT JOIN SCA_TURMA TDE ON TDE.Cod_Turma = TIP.COD_TURMA_DESTINO"
	sql = sql & " LEFT JOIN SCA_PERIODO PD ON PD.Cod_Periodo = TDE.Cod_periodo"
	sql = sql & " LEFT JOIN SCA_TURNO TUD ON TUD.Cod_Turno = TIP.COD_TURNO_DESTINO"
	sql = sql & " WHERE TIP.COD_EMPRESA_DESTINO = " & clng("0" & strCod_empresa)
	'Só as TIP com destino no ano letivo da sessão (ex.: sessão 2027 = TIP feitas em 2026 para 2027)
	sql = sql & " AND ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO + 1) = " & intAnoTipOrigem
	if intTipo = "1" then
		sql = sql & " AND TIP.SITUACAO = 'P'"
	elseif intTipo = "3" then
		sql = sql & " AND TIP.SITUACAO = 'C'"
	else
		sql = sql & " AND ISNULL(TIP.SITUACAO, 'E') = 'E'"
	end if
	if strNomealuno <> "" then
		sql = sql & " AND A.NOMEALUNO COLLATE Latin1_General_CI_AI LIKE '%" & replace(strNomealuno, "'", "''") & "%'"
	end if
	sql = sql & " ORDER BY A.NOMEALUNO"
	rs.open sql, cnn
	if not rs.eof then vetTipEfet = rs.getRows
	rs.close
	'Colunas: 0 CODIGO | 1 MATRICULA | 2 NOMEALUNO | 3 DATANASCIMENTO | 4 MAE | 5 UNIDADE_ORIGEM | 6 TURMA_ORIGEM
	'         7 TURMA_DESTINO | 8 TURNO_DESTINO | 9 USUARIO_INCL | 10 DATA_HORA_INCL | 11 USUARIO_EFETIVACAO
	'         12 DATA_HORA_EFETIVACAO | 13 ANO_DESTINO | 14 PRAZO (confirmação da matrícula: 02 dias úteis após o comprovante)
	'         15 DATA_HORA_CANCELAMENTO | 16 MOTIVO_CANCELAMENTO
	%>
	<input type="hidden" name="txtCodTip" id="txtCodTip" value="">
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%if intTipo = "1" then%>TIP para efetivar<%elseif intTipo = "3" then%>TIP canceladas<%else%>TIP efetivadas<%end if%>
						<span class="fw-300"><i>&nbsp;- transferência por interesse próprio para esta unidade</i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="alert alert-info">
							<i class="fal fa-info-circle mr-1"></i>
							Serão listadas as TIP incluídas para o ano letivo <strong><%=intAnoTipOrigem%></strong> (ano letivo selecionado).
							Para ver as TIP de outro ano, troque o ano letivo no topo da tela.
						</div>
						<div class="panel-tag">
						<%if intTipo = "1" then%>
							Alunos de outras unidades da rede com TIP para esta unidade. Ao <strong>efetivar</strong>, o aluno é alocado na turma de destino
							desta unidade para o ano letivo de destino, levando o histórico. Na unidade de origem ele <strong>finaliza normalmente o ano atual</strong>
							(notas, faltas e histórico do ano ficam lá). A vaga já está reservada desde a inclusão da TIP.
						<%elseif intTipo = "3" then%>
							TIP <strong>canceladas</strong> automaticamente porque a matrícula não foi confirmada nesta unidade no prazo de 02 dias úteis
							após o comprovante. Só consulta: o aluno continua na unidade de origem e a vaga já foi liberada.
						<%else%>
							TIP já efetivadas. <strong>Desfazer</strong> devolve o aluno para a turma da unidade de origem
							(só é possível enquanto não houver notas, faltas ou avaliações lançadas na turma de destino).
						<%end if%>
						</div>
						<%if not isArray(vetTipEfet) then%>
							<div class="alert alert-info m-0">
								<%if intTipo = "1" then%>Nenhuma TIP aguardando efetivação para esta unidade em <%=intAnoTipOrigem%>.<%elseif intTipo = "3" then%>Nenhuma TIP cancelada para esta unidade em <%=intAnoTipOrigem%>.<%else%>Nenhuma TIP efetivada para esta unidade em <%=intAnoTipOrigem%>.<%end if%>
							</div>
						<%else%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover table-sm m-0">
								<thead class="thead-themed">
									<tr>
										<th><strong>Matrícula</strong></th>
										<th><strong>Nome Aluno</strong></th>
										<th><strong>Data Nasc.</strong></th>
										<th><strong>M&atilde;e</strong></th>
										<th><strong>Unidade de origem</strong></th>
										<th><strong>Turma de origem</strong></th>
										<th><strong>Turma de destino</strong></th>
										<th><strong><%if intTipo = "1" then%>Solicitada por / em<%elseif intTipo = "3" then%>Cancelada em<%else%>Efetivada por / em<%end if%></strong></th>
										<th class="text-center"><strong><%if intTipo = "1" then%>Efetivar<%elseif intTipo = "3" then%>Motivo<%else%>Desfazer<%end if%></strong></th>
										<th class="text-center"><strong>Imprimir</strong></th>
									</tr>
								</thead>
								<tbody>
								<%
								for i = 0 to ubound(vetTipEfet, 2)
									strNomeTip = replace(replace(vetTipEfet(2, i) & "", "\", ""), "'", "\'")
									strMotivoBloqueio = ""
									if intTipo = "2" then
										'Mesma validação do Desfazer: se já tem nota, falta ou avaliação na turma de destino, fica o cadeado
										set rsBloqueio = Server.CreateObject("adodb.recordset")
										rsBloqueio.open "EXEC SP_MAT_TipDesfaz " & clng(vetTipEfet(0, i)) & ", 1", cnn
										if not rsBloqueio.eof then strMotivoBloqueio = trim(rsBloqueio("MOTIVO") & "")
										rsBloqueio.close
										set rsBloqueio = nothing
									end if
								%>
									<tr>
										<td><%=vetTipEfet(1, i)%></td>
										<td><%=vetTipEfet(2, i)%></td>
										<td><%=formatadataAP(vetTipEfet(3, i))%></td>
										<td><%=vetTipEfet(4, i)%></td>
										<td><%=vetTipEfet(5, i)%></td>
										<td><%=vetTipEfet(6, i)%></td>
										<td><%=vetTipEfet(7, i)%><%if trim(vetTipEfet(8, i) & "") <> "" then%><br><small><%=vetTipEfet(8, i)%> - <%=vetTipEfet(13, i)%></small><%end if%></td>
										<%if intTipo = "1" then%>
										<td><%=vetTipEfet(9, i)%><br><small><%=vetTipEfet(10, i)%></small>
											<%if isdate(vetTipEfet(14, i)) then%><br><span class="badge badge-warning" title="Prazo para a confirmação da matrícula (02 dias úteis após o comprovante). Depois dele a TIP é cancelada automaticamente.">Prazo: <%=formatadataAP(vetTipEfet(14, i))%></span><%end if%></td>
										<td class="text-center">
											<button type="button" class="btn btn-sm btn-outline-success" title="Efetivar a TIP (transferir o aluno para esta unidade)"
												onClick="efetivarTip('<%=vetTipEfet(0, i)%>', '<%=strNomeTip%>', '<%=replace(replace(vetTipEfet(7, i) & "", "\", ""), "'", "\'")%>', '<%=vetTipEfet(13, i)%>', '<%=replace(replace(vetTipEfet(5, i) & "", "\", ""), "'", "\'")%>')">
												<i class="fal fa-check"></i> Efetivar
											</button>
										</td>
										<%elseif intTipo = "3" then%>
										<td><small><%=vetTipEfet(15, i)%></small></td>
										<td><small><%=server.htmlEncode(vetTipEfet(16, i) & "")%></small></td>
										<%else%>
										<td><%=vetTipEfet(11, i)%><br><small><%=vetTipEfet(12, i)%></small></td>
										<td class="text-center">
										<%if strMotivoBloqueio <> "" then%>
											<span title="<%=server.htmlEncode(strMotivoBloqueio)%>" data-toggle="tooltip">
												<button type="button" class="btn btn-sm btn-outline-secondary" disabled style="pointer-events: none;">
													<i class="fal fa-lock"></i>
												</button>
											</span>
										<%else%>
											<button type="button" class="btn btn-sm btn-outline-danger" title="Desfazer a efetivação (aluno volta para a unidade de origem)"
												onClick="desfazerTip('<%=vetTipEfet(0, i)%>', '<%=strNomeTip%>')">
												<i class="fal fa-undo"></i>
											</button>
										<%end if%>
										</td>
										<%end if%>
										<td class="text-center">
											<button type="button" class="btn btn-sm btn-outline-info" title="Imprimir o comprovante da TIP"
												onClick="imprimirTip('<%=vetTipEfet(0, i)%>')">
												<i class="fal fa-print"></i>
											</button>
										</td>
									</tr>
								<%next%>
									<tr>
										<td colspan="10"><strong><%if intTipo = "1" then%>Total de TIP para efetivar<%elseif intTipo = "3" then%>Total de TIP canceladas<%else%>Total de TIP efetivadas<%end if%>: <%=ubound(vetTipEfet, 2) + 1%></strong></td>
									</tr>
								</tbody>
							</table>
						</div>
						<%end if%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%else%>
	<%
	'=====================================================================
	' NOVATOS - regra de Guapó (tela antiga EfetivacaoAluno_con.asp):
	'	inscrições de MAT_inscricao desta unidade; clicar na linha abre a confirmação dos dados
	'=====================================================================
	cont = 0
	mensagem_alerta_pagina = "Para efetivar o aluno, clique na lista abaixo."

	sql = "SELECT MT.Codigo, MT.Cod_Aluno, MT.matricula, MT.nome, MT.cpf, MT.data_nascimento, MT.mae, MT.CONTATO, MT.CELULAR, MT.FoneMae, MT.FonePai,"
	sql = sql & " PE.Descricao, T.DESC_TURNO, SEG_EMPRESA.RAZAOSOCIAL, MT.Data_hora_Incl as DataInclusao, MT.bolsa_Familia"
	sql = sql & " FROM MAT_inscricao MT"
	sql = sql & " inner join SCA_PERIODO PE on PE.Cod_Periodo = MT.Cod_periodo"
	sql = sql & " inner join SCA_CURSO C on C.Cod_curso = PE.Cod_Curso"
	sql = sql & " inner join SCA_TURNO T on T.COD_TURNO = MT.Cod_turno"
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = MT.COD_EMPRESA"
	sql = sql & " where MT.Cod_empresa = " & clng("0" & strCod_empresa)
	sql = sql & " And MT.Situacao = 'S'"
	if intTipo = "1" then
		sql = sql & " And isnull(MT.Efetivacao,'N') = 'N'"
	else
		sql = sql & " And isnull(MT.Efetivacao,'N') = 'S'"
	end if
	sql = sql & " And isnull(MT.excluido,'N') = 'N'"
	if intInscricao <> "" and isnumeric(intInscricao) then
		sql = sql & " And MT.Cod_Aluno = " & clng(intInscricao)
	end if
	if strNomealuno <> "" then
		sql = sql & " And MT.nome COLLATE Latin1_General_CI_AI like '%" & replace(strNomealuno, "'", "''") & "%'"
	end if
	sql = sql & " order by MT.nome"
	rs.open sql, cnn

	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%if intTipo = "1" then%>Lista para <%=pagina%><%else%>Lista dos alunos efetivados<%end if%>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if intTipo = "1" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Insc.</strong></th>
									<th><strong>Data</strong></th>
									<th><strong>Matrícula</strong></th>
									<th><strong>Bolsa</strong></th>
									<th><strong>Nome Aluno</strong></th>
									<th><strong>Data Nasc.</strong></th>
									<th><strong>M&atilde;e</strong></th>
									<th><strong>Série</strong></th>
									<th><strong>Turno</strong></th>
									<th><strong>Telefone</strong></th>
									<th><strong>Escola</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								while not rs.eof
									cont = cont + 1
									TELEFONES = ""
									IF NOT ISNULL(rs("CONTATO")) THEN TELEFONES = rs("CONTATO")
									IF NOT ISNULL(rs("CELULAR")) THEN
										if TELEFONES <> "" then TELEFONES = TELEFONES & " / "
										TELEFONES = TELEFONES & rs("CELULAR")
									END IF
								%>
								  <tr <%if intTipo = "1" then%>onClick="return Confirmar('<%=rs("Cod_Aluno")%>')" style="cursor: pointer;"<%end if%>>
									<td><%=rs("Cod_Aluno")%></td>
									<td><%=formatadataAP(rs("DataInclusao"))%></td>
									<td><%=rs("matricula")%></td>
									<td><%=rs("bolsa_Familia")%></td>
									<td><%=rs("nome")%></td>
									<td><%=formatadataAP(rs("data_nascimento"))%></td>
									<td><%=rs("mae")%></td>
									<td><%=rs("Descricao")%></td>
									<td><%=rs("DESC_TURNO")%></td>
									<td><%=TELEFONES%></td>
									<td><%=rs("RAZAOSOCIAL")%></td>
								  </tr>
								<%
									rs.movenext
								wend
								%>
								<tr>
									<td colspan="11"><strong><%if intTipo = "1" then%>Quantidade de candidatos: <%else%>Total de alunos efetivados: <%end if%><%=cont%></strong></td>
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
	else
	%>
	<div class="alert alert-secondary">
		<%if intTipo = "1" then%>Nenhum aluno novato aguardando efetivação nesta unidade.<%else%>Nenhum aluno novato efetivado nesta unidade.<%end if%>
	</div>
	<%
	end if
	rs.close
	%>
	<%end if%>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>