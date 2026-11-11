<%
	retira_incluir="S"
	intCodEmpresa = request("cmbEmpresa")
	intCodRota = request("cmbRota")
	if intCodEmpresa = "" then intCodEmpresa = "0"
	if intCodRota = "" then intCodRota = "0"
	intCodTurma = trim(request("cmbTurma"))
	if intCodTurma = "" or not isnumeric(intCodTurma) then intCodTurma = "0"
	
	intCodTurno = request("cmbTurno")
	if intCodTurno = "" then 
		intCodTurno = "0"
	end if
	
	rede = ucase(trim(request("rede")))
	if rede <> "E" then rede = "M"
	
	if rede = "M" then
		linhaMunicipal = "block flex"
		linhaEstadual = "none"
	elseif rede = "E" then
		linhaMunicipal = "none"
		linhaEstadual = "block flex"
	end if
	
	strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	
	'sql = "select listar_Alunos, ano_letivo from STE_configura_alunos "
	'rs.open sql, cnn
	'if rs.eof = false then
	'	filtro = rs("listar_Alunos")
	'	strAnoLetivo = rs("ano_letivo")
	'	'if rs("listar_Alunos") = "TELA_CONFIRMA_MATRICULA" then mensagem_alerta_pagina = "Serão listados aluno da renovação de matrícula do Ensino Fundamental"
	'	if rs("listar_Alunos") = "ALUNOS_ATIVOS" then mensagem_alerta_pagina = "Serão listados aluno ativos em turma do Ensino Fundamental"
	'										
	'end if
	'rs.close
	
	if rede = "E" then
		mensagem_alerta_pagina = "Rede estadual: o aluno é cadastrado pelo CPF e vinculado direto à rota. Todo aluno vinculado entra como <strong>Deferido (D)</strong>."
	else
		mensagem_alerta_pagina = "Serão listados os alunos ativos da turma selecionada. Selecione <strong>Turno, Turma e Rota</strong>, ou informe a <strong>matrícula do aluno</strong>.<br>Todo aluno vinculado à rota entra como <strong>Deferido (D)</strong>."
	end if
	strEmpresa_submit = "S"
	strExecutarSubmitRotaTransporteescolar = "S"
	strExecutarSubmitTurno = "S"
	
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	if trim(strMatricula) <> "" then
	
		sql = "Select a.Codigo, a.NomeAluno, a.matricula, a.DATAFASTAMENTO, a.DATAMATRICULA, st.Desc_SituacaoAluno, st.cod_empresa "
		sql = sql & " from sca_aluno a"
		sql = sql & " OUTER APPLY"
		sql = sql & " 		("
		sql = sql & " 			SELECT TOP 1"
		sql = sql & " 				SS.Desc_SituacaoAluno,"
		sql = sql & " 				CS.Cod_empresa"
		sql = sql & " 			FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
		sql = sql & " 			INNER JOIN SCA_SITUACAOALUNO SS"
		sql = sql & " 				ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
		sql = sql & " 			WHERE CS.COD_ALUNO = a.codigo"
		sql = sql & " 			AND CS.ANO_LETIVO = " & session("strAnoLetivo")
		sql = sql & " 			ORDER BY CS.CODIGO DESC"
		sql = sql & " 		) ST"
		sql = sql & " where a.matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			strDatafastamento 	= FORMATADATAap(Trim(rs("DATAFASTAMENTO")))
			strDatamatricula 	= FORMATADATAap(Trim(rs("DATAMATRICULA")))
			strSituacaoAtual	= ucase(Trim(rs("Desc_SituacaoAluno")))
			if strSituacaoAtual="ATIVO" then 
				strSituacaoAtual = ""
			else
				strSituacaoAtual = " (" & strSituacaoAtual & ")"
			end if
			intCodEmpresa = rs("cod_empresa")
			if intCodEmpresa="" then intCodEmpresa ="0"
			if isnull(intCodEmpresa) then intCodEmpresa ="0"
			intCodEmpresa = intCodEmpresa & ""
			'Turno e turma em que o aluno está alocado no ano letivo (agiliza: só falta escolher a rota)
			if intCodEmpresa <> "0" and isnumeric(strAnoLetivo & "") then
				sql = "SELECT TOP 1 AT.Cod_Turma, T.Cod_Turno FROM SCA_ALUNO_TURMA AT"
				sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = AT.Cod_Turma"
				sql = sql & " WHERE AT.Cod_Aluno = " & clng(strCodAluno) & " AND AT.Cod_Empresa = " & clng(intCodEmpresa)
				sql = sql & " AND AT.Situacao = 'A' AND T.AnoLetivo = " & clng(strAnoLetivo)
				sql = sql & " ORDER BY AT.Codigo DESC"
				rsAux.open sql, cnn
				if not rsAux.eof then
					intCodTurma = cstr(rsAux("Cod_Turma"))
					if not isnull(rsAux("Cod_Turno")) then intCodTurno = cstr(rsAux("Cod_Turno"))
				end if
				rsAux.close
			end if
		else
			strCodAluno			= ""
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

	'Turma escolhida sem turno: o turno vem da própria turma
	if intCodTurma <> "0" and intCodTurno = "0" and intCodEmpresa <> "0" then
		sql = "SELECT Cod_Turno FROM SCA_TURMA WHERE Cod_Turma = " & clng(intCodTurma) & " AND Cod_Empresa = " & clng(intCodEmpresa)
		rs.open sql, cnn
		if not rs.eof then
			if not isnull(rs("Cod_Turno")) then intCodTurno = cstr(rs("Cod_Turno"))
		end if
		rs.close
	end if
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="ste_vincula_aluno_individualCon.asp">
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
						
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input readonly name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Selecione a Rede</label>
									<select class="form-control" id="rede" name="rede" onchange="submit()">
										<option <%if rede = "M" then response.write "selected" %> value="M">MUNICIPAL</option>
										<option <%if rede = "E" then response.write "selected" %> value="E">ESTADUAL</option>
									</select>
								</div>
							</div>
						</div>
						<%if rede = "M" then%>
						<br>
						<div class="row" id="linha_municipal">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Unidade</label>
									<!--#include file="includes/inc_cmbEmpresas.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row" id="linha_municipal2">
							<div class="col-sm-3">
								<div class="form-group"><strong>Matrícula do Aluno</strong></label>
									<div class="input-group">
										<input type="hidden" value="<%=strCodAluno%>" name="txtCodAluno" id="txtCodAluno">
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
									<input type="text" name="txtNomealuno" readonly id="txtNomealuno" class="form-control" value="<%=strNomeAluno%><%=strSituacaoAtual%>">
								</div>
							</div>
						</div>
						
						<br>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Turno</label>
									 <!--#include file="includes/inc_cmdTurno.asp" -->
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Turma</label>
									<%
									'Turmas da unidade no ano letivo (e no turno, se escolhido). Turma que não é mais da lista volta para "Selecione..."
									blnTurmaNaLista = false
									%>
									<select name="cmbTurma" id="cmbTurma" class="form-control" onchange="submit()">
										<option value="0">Selecione...</option>
									<%
									if intCodEmpresa <> "0" and isnumeric(strAnoLetivo & "") and trim(strAnoLetivo & "") <> "" then
										sql = "SELECT T.Cod_Turma, ISNULL(P.Descricao, '') AS Periodo, ISNULL(T.TurmaAluno, '') + ' ' + ISNULL(T.NomeTurma, '') AS NomeTurma, T.Cod_empresa_extensao"
										sql = sql & " FROM SCA_TURMA T LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = T.Cod_Periodo"
										sql = sql & " WHERE T.Cod_Empresa = " & clng(intCodEmpresa) & " AND T.AnoLetivo = " & clng(strAnoLetivo) & " AND T.Situacao = 'A'"
										if intCodTurno <> "0" then sql = sql & " AND T.Cod_Turno = " & clng(intCodTurno)
										sql = sql & " ORDER BY P.Cod_Curso, P.Descricao, T.NomeTurma"
										rs.open sql, cnn
										while not rs.eof
											strSelTurma = ""
											if trim(intCodTurma) = trim(rs("Cod_Turma")) then strSelTurma = " selected" : blnTurmaNaLista = true
											strTurmaExtensao = ""
											if not isnull(rs("Cod_empresa_extensao")) then strTurmaExtensao = " (Extensão)"
											response.write "<option value=""" & rs("Cod_Turma") & """" & strSelTurma & ">" & server.htmlEncode(trim(rs("Periodo") & "") & " - " & trim(rs("NomeTurma") & "") & strTurmaExtensao) & "</option>" & vbcrlf
											rs.movenext
										wend
										rs.close
									end if
									if not blnTurmaNaLista then intCodTurma = "0"
									%>
									</select>
									<small class="form-text text-muted">Selecione a turma para listar os alunos.</small>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Rota</label>
									 <!--#include file="includes/inc_cmdRotaUnidadeIndividual.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
						<%end if%>
					</div>
				</div>
			</div>
		</div>
	</div>
<!--#include file="ste_vincula_aluno_estadual_inc.asp"-->
<%
'if session("usuarioWeb") = "SERGIO" THEN
'	RESPONSE.WRITE intCodRota & "<hr>"
'	RESPONSE.WRITE intCodEmpresaGrupo & "<hr>"
'	RESPONSE.WRITE intCodTurno & "<hr>"
'end if	
'Aviso do que falta selecionar para listar os alunos
strFaltaFiltro = ""
if intCodEmpresa<>"0" and rede = "M" then
	if intCodTurno="0" then strFaltaFiltro = strFaltaFiltro & ", <strong>Turno</strong>"
	if intCodRota="0" then
		if intQtdRotasUnidade = 0 then
			strFaltaFiltro = strFaltaFiltro & ", <strong>Rota</strong> (esta unidade não tem rota vinculada: vincule a escola ao setor de uma rota)"
		else
			strFaltaFiltro = strFaltaFiltro & ", <strong>Rota</strong>"
		end if
	end if
	if intCodTurma="0" and strCodAluno="" then strFaltaFiltro = strFaltaFiltro & ", <strong>Turma</strong> (ou informe a matrícula do aluno)"
end if
if strFaltaFiltro <> "" then
%>
	<div class="alert alert-info">
		<strong>Atenção:</strong> para que os alunos sejam listados, selecione: <%=mid(strFaltaFiltro, 3)%>.
	</div>
<%
end if
if rede = "M" and intCodRota<>"0" and intCodEmpresaGrupo<>"0" and intCodTurno<>"0" and (intCodTurma<>"0" or strCodAluno<>"") then
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
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Aluno</strong></th>
									<th><strong>Ficha</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
									<th><strong>Rota Vinculada</strong></th>
									<th><strong>Comprovante</strong></th>
									<th><strong>A&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							<%
							if rede = "M" then
								sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA,SCA_TURMA.Cod_Semestre, SCA_TURMA.cod_turno, SCA_TURMA.Cod_Turma, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, "
								sql = sql & " SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA,"
								sql = sql & " sca_turma.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, st.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, "
								sql = sql & " SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva, SCA_PERIODO.sequencia, "
								sql = sql & " VR.rota_descricao, VR.cod_solicitacao_transporte "
								sql = sql & " FROM SCA_ALUNO_TURMA "
								sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
								sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma and SCA_TURMA.anoletivo = SCA_ALUNO_TURMA.ano_letivo"
								sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO "
								sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO "
								sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.Cod_CURSO" 
								sql = sql & " OUTER APPLY"
								sql = sql & " 		("
								sql = sql & " 			SELECT TOP 1"
								sql = sql & " 				SS.Desc_SituacaoAluno,"
								sql = sql & " 				CS.Cod_empresa"
								sql = sql & " 			FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
								sql = sql & " 			INNER JOIN SCA_SITUACAOALUNO SS"
								sql = sql & " 				ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
								sql = sql & " 			WHERE CS.COD_ALUNO = SCA_ALUNO.codigo"
								sql = sql & " 			AND CS.ANO_LETIVO = " & session("strAnoletivo")
								sql = sql & " 			ORDER BY CS.CODIGO DESC"
								sql = sql & "  		) ST"
								'vínculo do aluno com a rota escolhida, na mesma consulta (antes era uma consulta por aluno)
								sql = sql & " OUTER APPLY (SELECT TOP 1 R.descricao AS rota_descricao, V.cod_solicitacao_transporte"
								sql = sql & " 	FROM SCA_ROTA_VICULA_ALUNO V INNER JOIN ste_rota R ON R.cod_Rota = V.cod_rota"
								sql = sql & " 	WHERE V.cod_aluno = SCA_ALUNO.CODIGO AND V.Cod_Rota = " & clng(intCodRota) & " AND V.ano_letivo = " & clng(strAnoLetivo) & ") VR"
								sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & intCodEmpresa
								sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A' "
								sql = sql & " and SCA_TURNO.COD_TURNO = " & intCodTurno
								sql = sql & " and SCA_TURMA.cod_empresa = " & intCodEmpresa 
								if strCodAluno<>"" then
									sql = sql & " and SCA_ALUNO_TURMA.COD_ALUNO = " & strCodAluno
								else
									'sem matrícula: só a turma escolhida (evita listar a unidade inteira)
									sql = sql & " and SCA_TURMA.Cod_Turma = " & clng(intCodTurma)
								end if
								sql = sql & " and st.desc_SituacaoAluno = 'ATIVO' order by SCA_ALUNO.NOMEALUNO"
								
							elseif rede = "E" then
							
							end if
							
							'if filtro = "ALUNOS_ATIVOS" then
							'	sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA,SCA_TURMA.Cod_Semestre, SCA_TURMA.cod_turno, SCA_TURMA.Cod_Turma, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva, SCA_PERIODO.sequencia "
							'	sql = sql & " FROM SCA_ALUNO_TURMA "
							'	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
							'	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma and SCA_TURMA.cod_empresa = sca_aluno.cod_empresa "
							'	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO and SCA_PERIODO.cod_empresa = SCA_TURMA.cod_empresa "
							'	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.Cod_CURSO"
							'	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							'	sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
							'	sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & intCodEmpresaGrupo
							'	sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A' "
							'	sql = sql & " and SCA_ALUNO_TURMA.ano_letivo = " & strAnoLetivo
							'	sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
							'	sql = sql & " and SCA_TURMA.cod_turno = " & intCodTurno
							'	if strCodAluno<>"" then
							'		sql = sql & " and SCA_ALUNO_TURMA.COD_ALUNO = " & strCodAluno
							'	end if
							'	sql = sql & " and SCA_SITUACAOALUNO.desc_SituacaoAluno = 'ATIVO'"
							'	'sql = sql & " and SCA_CURSO.descricao not in ('EDUCAÇÃO INFANTIL')"
							'	sql = sql & " order by SCA_ALUNO.NOMEALUNO"
							'	
							'elseif filtro = "TELA_CONFIRMA_MATRICULA" then
							'	sql = " SELECT SCA_ALUNO_RENOVACAO.CODIGO AS CODALUNOTURMA,SCA_TURMA.Cod_Semestre, SCA_TURMA.cod_turno, SCA_TURMA.Cod_Turma, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, '0' as SEQUENCIA, SCA_ALUNO_RENOVACAO.COD_TURMA, SCA_TURMA.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno "
							'	sql = sql & " from SCA_ALUNO_RENOVACAO"
							'	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_RENOVACAO.COD_ALUNO = SCA_ALUNO.CODIGO"
							'	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_RENOVACAO.COD_TURMA_RENOVACAO = SCA_TURMA.Cod_Turma "
							'	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO"
							'	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.Cod_CURSO"
							'	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							'	sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
							'	sql = sql & " where SCA_ALUNO_RENOVACAO.cod_empresa = " & intCodEmpresaGrupo
							'	sql = sql & " and SCA_TURMA.anoLetivo = " & strAnoLetivo
							'	sql = sql & " and SCA_TURMA.cod_turno = " & intCodTurno
							'	if strCodAluno<>"" then
							'		sql = sql & " and SCA_ALUNO_RENOVACAO.COD_ALUNO = " & strCodAluno
							'	end if
							'	
							'	'sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
							'	'sql = sql & " and SCA_ALUNO_RENOVACAO.EFETIVADO = 'S' "
							'	sql = sql & " and SCA_SITUACAOALUNO.desc_SituacaoAluno = 'ATIVO'"
							'	'sql = sql & " and SCA_CURSO.descricao not in ('EDUCAÇÃO INFANTIL')"
							'	sql = sql & " order by SCA_ALUNO.NOMEALUNO"
							'end if
							if session("usuarioWeb") = "SERGIO" THEN
								'RESPONSE.WRITE sql & "<hr>"
							end if	
							cont = 0
							contVinculado = 0
							
							rs.open sql, cnn
							
							if rs.eof = false then
							
								while not rs.eof
									strMarca  				= ""
									strRota					= ""
									strCodigoAluno        	= rs("codigo")
									Cod_Turma        		= rs("Cod_Turma")
									Cod_Semestre        	= rs("Cod_Semestre")
									strMatricula		  	= rs("MATRICULA")
									cont = cont + 1
									cod_solicitacao_transporte = ""
									if not isnull(rs("rota_descricao")) then
										strMarca = "checked"
										strRota = rs("rota_descricao")
										contVinculado = contVinculado + 1
										cod_solicitacao_transporte = rs("cod_solicitacao_transporte")
									
									end if
									 %>
									 <tr id="linhaAluno_<%=strCodigoAluno%>">
										<td><%=strMatricula%></td>
										<td><%=trim(rs("NOMEALUNO"))%></td>
										<td>
											
										<img style="cursor:pointer" onclick="return gerarImpressao('<%=strCodigoAluno%>','<%=strAnoLetivo%>','<%=Cod_Turma%>','<%=intCodEmpresa%>','<%=Cod_Semestre%>')" src="../../images/impressora_on.gif" width="26" height="26">
						   
										</td>
										<td><%=trim(rs("TURMAALUNO"))%>&nbsp;<%=rs("NOMETURMA")%>&nbsp;<input type="hidden" id="txtTurma_<%=rs("codigo")%>" name="txtTurma_<%=rs("codigo")%>" value="<%=rs("COD_TURMA")%>"></td>
										<td><%=trim(rs("DESC_SITUACAOALUNO"))%></td>
										<td class="va-rota"><%=strRota%></td>
										<td class="va-comprovante"><%if strRota <> "" then%><img style="cursor:pointer" onclick="return gerarImpressaoComprovante('<%=cod_solicitacao_transporte%>')" src="../../images/impressora_on.gif" width="26" height="26"><%end if%></td>
										<td class="va-acao">
										<%if strMarca="" then%>
										<button onClick="vaIncluir(this, '<%=strCodigoAluno%>','<%=intCodRota%>')" type="button" class="btn btn-outline-success btn-sm">Incluir</button>
										<%end if%>
										<%if strMarca<>"" then%>
										<button onClick="vaExcluir(this, '<%=strCodigoAluno%>','<%=cod_solicitacao_transporte%>','<%=intCodRota%>')" type="button" class="btn btn-outline-danger btn-sm">Excluir</button>
										<%end if%>
										</td>
									</tr>
									 <%
									rs.movenext
								wend
								%>
								 <tr>
									<td colspan="3"><strong><%=cont%> aluno(s) listado(s)</strong></td>
									<td colspan="5"><strong><span id="vaContVinculado"><%=contVinculado%></span> aluno(s) vinculados a rota</strong></td>
								</tr>
								 <%  
							else
								 %>
								 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
								 <td colspan="7" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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