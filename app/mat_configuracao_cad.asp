<%
	'Matrícula > Configurações: períodos de funcionamento (MAT_CONFIGURACAO_PERIODO)
	function cfgDataInput(ByVal valor)	'valor para <input type="datetime-local">: yyyy-mm-ddThh:nn
		cfgDataInput = ""
		if isdate(valor) then cfgDataInput = year(valor) & "-" & right("0" & month(valor), 2) & "-" & right("0" & day(valor), 2) & "T" & right("0" & hour(valor), 2) & ":" & right("0" & minute(valor), 2)
	end function

	intCfgGrupo = 0
	if isnumeric(Session("CodGrupo") & "") and trim(Session("CodGrupo") & "") <> "" then intCfgGrupo = clng(Session("CodGrupo"))

	'Configurações gravadas do grupo
	set dicCfg = Server.CreateObject("Scripting.Dictionary")
	blnTabelaExiste = true
	on error resume next
	blnColunaPerfis = true
	rs.open "SELECT FUNCIONALIDADE, DESCRICAO, DATA_INICIO, DATA_FIM, USUARIO_ALTR, DATA_HORA_ALTR, PERFIS_LIBERADOS FROM MAT_CONFIGURACAO_PERIODO WHERE COD_GRUPO = " & intCfgGrupo, cnn
	if err.number <> 0 then
		'coluna PERFIS_LIBERADOS ainda não criada
		err.clear
		blnColunaPerfis = false
		rs.open "SELECT FUNCIONALIDADE, DESCRICAO, DATA_INICIO, DATA_FIM, USUARIO_ALTR, DATA_HORA_ALTR, '' AS PERFIS_LIBERADOS FROM MAT_CONFIGURACAO_PERIODO WHERE COD_GRUPO = " & intCfgGrupo, cnn
	end if
	if err.number <> 0 then
		blnTabelaExiste = false
		err.clear
	end if
	on error goto 0
	if blnTabelaExiste then
		do while not rs.eof
			dicCfg(trim(rs("FUNCIONALIDADE") & "")) = array(trim(rs("DESCRICAO") & ""), rs("DATA_INICIO").Value, rs("DATA_FIM").Value, trim(rs("USUARIO_ALTR") & ""), rs("DATA_HORA_ALTR").Value, trim(rs("PERFIS_LIBERADOS") & ""))	'.Value: guarda o valor, não o campo (o recordset é fechado)
			rs.movenext
		loop
		rs.close
	end if

	vetFunc = periodoFuncionalidades()
	agoraCfg = now()

	'Perfis do módulo Matrícula (para liberar uma funcionalidade fora do período)
	vetPerfisMat = ""
	if blnTabelaExiste then
		rs.open "SELECT PERF_CODG, PERF_DESC FROM SEG_PERFIS_SISTEMA WHERE PERF_SIST_SIGL = 'MAT' ORDER BY PERF_DESC", cnn
		if not rs.eof then vetPerfisMat = rs.getRows
		rs.close
	end if
	'altura da lista: todos os perfis visíveis (até 10 linhas; acima disso, rolagem)
	intAlturaPerfis = 3
	if isArray(vetPerfisMat) then intAlturaPerfis = ubound(vetPerfisMat, 2) + 1
	if intAlturaPerfis > 10 then intAlturaPerfis = 10
	if intAlturaPerfis < 3 then intAlturaPerfis = 3
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_configuracao_cod.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-calendar-alt'></i> <%=pagina%>
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>

	<%if not blnTabelaExiste then%>
	<div class="alert alert-danger">
		A tabela <strong>MAT_CONFIGURACAO_PERIODO</strong> ainda não foi criada no banco.
		Execute o script <strong>banco/scripts/2026-10-30_MAT_CONFIGURACAO_PERIODO.sql</strong>.
	</div>
	<%else%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Períodos de funcionamento <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag">
							Informe a data e hora de <strong>início</strong> e de <strong>fim</strong> de cada funcionalidade.
							Fora do período, a tela abre com um aviso e <strong>não grava</strong> alterações;
							o site da matrícula redireciona para a página de inscrições encerradas.
							Deixe em branco para <strong>não ter restrição</strong> (só início = liberado a partir dele; só fim = liberado até ele).
							Em <strong>Perfis liberados</strong>, os perfis escolhidos (Ctrl + clique para mais de um) usam a funcionalidade mesmo fora do período.
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover table-sm m-0 cfg-tabela">
								<thead class="thead-themed">
									<tr>
										<th>Funcionalidade</th>
										<th>Início</th>
										<th>Fim</th>
										<th class="text-center">Situação agora</th>
										<th>Perfis liberados fora do período</th>
										<th>Última alteração</th>
									</tr>
								</thead>
								<tbody>
								<%
								for i = 0 to ubound(vetFunc)
									strCod = vetFunc(i)(0)
									strDesc = vetFunc(i)(1)
									dtIni = null : dtFim = null : strAltr = "" : strPerfisLib = ""
									if dicCfg.exists(strCod) then
										cfg = dicCfg(strCod)
										strPerfisLib = "," & replace(cfg(5), " ", "") & ","
										if cfg(0) <> "" then strDesc = cfg(0)
										dtIni = cfg(1) : dtFim = cfg(2)
										if cfg(3) <> "" or isdate(cfg(4)) then strAltr = cfg(3) & " " & periodoDataHora(cfg(4))
									end if

									strSituacao = "Liberado"
									strClasse = "cfg-liberado"
									if isdate(dtIni) then
										if agoraCfg < cdate(dtIni) then strSituacao = "Ainda não iniciado" : strClasse = "cfg-bloqueado"
									end if
									if isdate(dtFim) then
										if agoraCfg > cdate(dtFim) then strSituacao = "Encerrado" : strClasse = "cfg-bloqueado"
									end if
									if not isdate(dtIni) and not isdate(dtFim) then strSituacao = "Liberado (sem restrição)"
								%>
									<tr>
										<td>
											<strong><%=Server.HTMLEncode(strDesc)%></strong><br>
											<small class="text-muted"><%=Server.HTMLEncode(vetFunc(i)(2))%></small>
											<input type="hidden" name="txtFuncionalidade" value="<%=strCod%>">
										</td>
										<td><input type="datetime-local" class="form-control form-control-sm" name="txtInicio_<%=strCod%>" id="txtInicio_<%=strCod%>" value="<%=cfgDataInput(dtIni)%>" data-desc="<%=Server.HTMLEncode(strDesc)%>"></td>
										<td>
											<input type="datetime-local" class="form-control form-control-sm" name="txtFim_<%=strCod%>" id="txtFim_<%=strCod%>" value="<%=cfgDataInput(dtFim)%>">
										</td>
										<td class="text-center <%=strClasse%>">
											<%=strSituacao%>
											<br><button type="button" class="btn btn-xs btn-outline-secondary mt-1" onclick="limparPeriodo('<%=strCod%>')" title="Apagar as datas (sem restrição)">Limpar datas</button>
										</td>
										<td>
										<%if strCod = "SITE_MATRICULA" then%>
											<small class="text-muted">Site público (sem login)</small>
										<%elseif not blnColunaPerfis then%>
											<small class="text-muted">Rode o script 2026-11-04_periodo_perfis_liberados.sql</small>
										<%elseif isArray(vetPerfisMat) then%>
											<select name="cmbPerfis_<%=strCod%>" class="form-control form-control-sm cfg-perfis" multiple size="<%=intAlturaPerfis%>" title="Ctrl + clique para escolher mais de um">
											<%for p = 0 to ubound(vetPerfisMat, 2)%>
												<option value="<%=vetPerfisMat(0, p)%>" <%if instr(strPerfisLib, "," & trim(vetPerfisMat(0, p) & "") & ",") > 0 then response.write "selected"%>><%=Server.HTMLEncode(trim(vetPerfisMat(1, p) & ""))%></option>
											<%next%>
											</select>
										<%end if%>
										</td>
										<td><small><%=Server.HTMLEncode(strAltr)%></small></td>
									</tr>
								<%next%>
								</tbody>
							</table>
						</div>
						<br>
						<div class="frame-wrap">
							<button onClick="salvar()" type="button" class="btn btn-outline-success" id="btnSalvar">Salvar</button>
							<button onClick="window.location='mat_configuracao.asp'" type="button" class="btn btn-outline-warning">Descartar alterações</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%end if%>
</form>
</main>
