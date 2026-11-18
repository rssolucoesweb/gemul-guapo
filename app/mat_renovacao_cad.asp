<%
	
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitSemestreAlocacao = "S"
	strExecutarSubmitCurso	 		= "S"	
	strExecutarSubmitTurno	 		= "S"	
	strExecutarSubmitPeriodo	 	= "S"	
	strExecutarSubmitTurma	 		= "S"
	strExecutarSubmitTurmaAlocacao  = "S"

	intSemestre 			= Trim(Request("cmbSemestre"))

	if Trim(Request("cmbSemestreAlocacao")) <> "0" and Trim(Request("cmbSemestreAlocacao")) <> "" then
		intSemestreAlocacao 	= Trim(Request("cmbSemestreAlocacao"))
	else
		intSemestreAlocacao 	= session("strSemestre")
	end if


	'ano_matricula (Matrícula > Configurações) = ano PARA O QUAL se matricula (ex.: 2027).
	'Renovação: origem = ano anterior (2026), destino = ano da matrícula (2027).
	sql = "select ano_matricula from [dbo].[MAT_configuracoes] where cod_grupo = " & clng("0" & session("codGrupo")) & " and isnull(ano_matricula, 0) > 0"
	rs.open sql, cnn		
	if not rs.eof then
		strAnoLetivoRenovacao = clng(rs("ano_matricula"))
		strAnoLetivo = strAnoLetivoRenovacao - 1
	end if
	rs.close

	intCodCurso 			= Trim(Request.Form("cmbCurso"))
	intCodTurno 			= Trim(Request.Form("cmbTurno"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodTurmaRenovacao 	= Trim(Request("cmbTurmaRenovacao"))
	if intCodTurmaRenovacao = "" then intCodTurmaRenovacao = "0"
	
	strTipoAlocacao 		= Trim(Request.Form("cmbTipoAlocacao"))
	
	if intCodTurma 		= "" then intCodTurma 		= "0"

	acao = "I"
	
	aluno_renovado = 0
	capacidade = 0
	vagas = 0
	if intCodTurmaRenovacao <> "0" then
		sql = "select count(*) as qtde, tu.capacidade, tu.VagasReservadas "	
		sql = sql & " from sca_aluno_turma at inner join sca_turma tu on tu.cod_turma = at.cod_turma"
		sql = sql & " where at.ano_letivo = " & strAnoLetivoRenovacao
		sql = sql & " and at.cod_turma = " & intCodTurmaRenovacao
		sql = sql & " and at.situacao = 'A' group by tu.capacidade, tu.VagasReservadas"
		rs.open sql, cnn		
		if not rs.eof then
			aluno_renovado = rs("qtde")
			if isnull(aluno_renovado) then aluno_renovado = 0
			VagasReservadas = rs("VagasReservadas")
			if isnull(VagasReservadas) then VagasReservadas = 0
			capacidade = rs("capacidade")
			if isnull(capacidade) then capacidade = 0
			vagas = cInt(capacidade) - cint(VagasReservadas) - cint(aluno_renovado)
		end if
		rs.close
	end if

%>
<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="mat_renovacao.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%> - <%=strAnoLetivoRenovacao%>
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
						
						<!--div class="alert alert-warning  alert-dismissible fade show">
							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
								<span aria-hidden="true"><i class="fal fa-times"></i></span>
							</button>
							<div class="d-flex align-items-center">
								<div class="alert-icon width-8">
									<span class="icon-stack icon-stack-xl">
										<i class="base-2 icon-stack-3x color-warning -400"></i>
										<i class="base-10 text-white icon-stack-1x"></i>
										<i class="ni md-profile color-warning -800 icon-stack-2x"></i>
									</span>
								</div>
								<div class="flex-1 pl-1">
									<span class="h2">
										Aviso!
									</span>
									<br>
									O bloqueio de alocação de alunos em turmas está desativado. Dessa forma, os alunos poderão ser alocados sem a necessidade de fechamento anual das turmas.
								</div>
							</div>
						</div-->
						
						<div class="row">
							<div class="col-sm-12">
								<span><strong>Origem</strong></span>
							</div>	
						</div>					
						<div class="row">
							<div class="col-sm-1">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input disabled name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-1">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Curso</label>
									<!--#include file="includes/inc_cmdCurso.asp"-->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Período</label>
									<!--#include file="includes/inc_cmdPeriodo.asp"-->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Turno</label>
									<!--#include file="includes/inc_cmdTurno.asp"-->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Turma de <%=strAnoLetivo%></label>
									<!--#include file="includes/inc_cmdTurma.asp"-->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
								
									<label class="form-label">Turma Renovação <%=strAnoLetivoRenovacao%></label>
									<!--#include file="includes/inc_cmdTurmaRenovacao.asp"-->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Capacidade da turma: </label>
									<strong><%=capacidade%></strong>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Aluno na turma: </label>
									<strong><%=aluno_renovado%></strong>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Vagas: </label>
									<strong><%=vagas%></strong>
								</div>
							</div>
						</div>
						
						<input name="txtAnoLetivoAnterior" 	id="txtAnoLetivoAnterior"  type="hidden" value="<%=strAnoLetivo%>" >
						<input name="txtAnoLetivoLocacao"	id="txtAnoLetivoLocacao" type="hidden" value="<%=strAnoLetivoRenovacao%>" >
						<input name="txtCurso"				id="txtCurso" type="hidden" value="<%=intCodCurso%>" >
						<input name="txtPeriodo"			id="txtPeriodo" type="hidden" value="<%=intCodSerie%>" >
						<input name="txtTurno"				id="txtTurno" type="hidden" value="<%=intCodTurno%>" >
						<input name="txtCodRenovacao"		id="txtCodRenovacao" type="hidden" value="" >
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
  if intCodTurma <> "0"  and intCodTurma <> "" then
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
									<th><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
									<th><strong>Turma Renovação</strong></th>
									<th class="text-center"><strong>Excluir</strong></th>
									<th class="text-center"><strong>Imprimir</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
								
							sql = "SELECT "
							sql = sql & " SCA_ALUNO.CODIGO, "
							sql = sql & " SCA_ALUNO.MATRICULA, "
							sql = sql & " SCA_ALUNO.NOMEALUNO, "
							sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, "
							sql = sql & " SCA_TURMA.TURMAALUNO, "
							sql = sql & " SCA_TURMA.NomeTurma, SCA_PERIODO.descricao as periodo,"
							sql = sql & " '' as TURMAALUNO_renovacao, "
							sql = sql & " '' as NomeTurma_renovacao, "
							sql = sql & " SCA_SITUACAOALUNO.Desc_SituacaoAluno,"
							sql = sql & " 'N' AS renovado,"
							sql = sql & " 0 AS cod_renovacao, 0 AS cod_turma_renovacao,'' as periodo_renovacao, 0 AS semestre_renovacao, 0 AS ano_renovacao,"
							'TIP no ano: aluno não pode ser renovado
							sql = sql & " CASE WHEN EXISTS (SELECT 1 FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP WHERE TIP.COD_ALUNO = SCA_ALUNO.CODIGO AND TIP.ANO_LETIVO = " & clng(strAnoLetivo) & " AND ISNULL(TIP.SITUACAO, 'E') <> 'C') THEN 'S' ELSE 'N' END AS tem_tip"
							sql = sql & " FROM SCA_ALUNO_TURMA "
							sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
							sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
							sql = sql & " INNER JOIN SCA_PERIODO ON SCA_TURMA.Cod_periodo = SCA_PERIODO.Cod_periodo "
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
							sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")		
							sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma 
							sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A' "
							'aluno já renovado a partir desta turma aparece só uma vez, na parte de baixo (com a turma de renovação)
							sql = sql & " and NOT EXISTS (SELECT 1 FROM SCA_ALUNO_RENOVACAO RN WHERE RN.COD_ALUNO = SCA_ALUNO.CODIGO AND RN.COD_TURMA = " & intCodTurma & ")"
							sql = sql & " union"
							sql = sql & " Select "
							sql = sql & " SCA_ALUNO.CODIGO, "
							sql = sql & " SCA_ALUNO.MATRICULA, "
							sql = sql & " SCA_ALUNO.NOMEALUNO, "
							sql = sql & " SCA_ALUNO_RENOVACAO.COD_TURMA, "
							sql = sql & " SCA_TURMA.TURMAALUNO, "
							sql = sql & " SCA_TURMA.NomeTurma, (SELECT P.descricao FROM SCA_PERIODO P WHERE P.Cod_periodo = SCA_TURMA.Cod_periodo) as periodo, "
							sql = sql & " SCA_TURMA_renovacao.TURMAALUNO as TURMAALUNO_renovacao, "
							sql = sql & " SCA_TURMA_renovacao.NomeTurma as NomeTurma_renovacao, "
							sql = sql & " SCA_SITUACAOALUNO.Desc_SituacaoAluno,"
							sql = sql & " 'S' AS renovado,"
							sql = sql & " SCA_ALUNO_RENOVACAO.CODIGO AS cod_renovacao, SCA_ALUNO_RENOVACAO.COD_TURMA_RENOVACAO AS cod_turma_renovacao, "
							sql = sql & " sca_periodo.descricao as periodo_renovacao,"
							sql = sql & " ISNULL(SCA_TURMA_renovacao.Cod_Semestre, 3) AS semestre_renovacao, SCA_ALUNO_RENOVACAO.ANO_LETIVO_RENOVACAO AS ano_renovacao,"
							sql = sql & " 'N' AS tem_tip"
							sql = sql & " FROM SCA_ALUNO_RENOVACAO"
							sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_RENOVACAO.COD_ALUNO = SCA_ALUNO.CODIGO" 
							sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_RENOVACAO.COD_TURMA = SCA_TURMA.Cod_Turma "
							sql = sql & " INNER JOIN SCA_TURMA SCA_TURMA_renovacao ON SCA_ALUNO_RENOVACAO.COD_TURMA_RENOVACAO = SCA_TURMA_renovacao.Cod_Turma "
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							sql = sql & " INNER JOIN SCA_PERIODO ON SCA_TURMA_renovacao.Cod_periodo = SCA_PERIODO.Cod_periodo "
							sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
							sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")	 
							sql = sql & " and SCA_ALUNO_RENOVACAO.COD_TURMA = " & intCodTurma 
							'Alunos que saíram desta turma por TIP (o vínculo aqui ficou 'T'): aparecem com (TIP), sem renovação
							sql = sql & " union"
							sql = sql & " Select "
							sql = sql & " SCA_ALUNO.CODIGO, "
							sql = sql & " SCA_ALUNO.MATRICULA, "
							sql = sql & " SCA_ALUNO.NOMEALUNO, "
							sql = sql & " TIP.COD_TURMA, "
							sql = sql & " SCA_TURMA.TURMAALUNO, "
							sql = sql & " SCA_TURMA.NomeTurma, (SELECT P.descricao FROM SCA_PERIODO P WHERE P.Cod_periodo = SCA_TURMA.Cod_periodo) as periodo, "
							sql = sql & " '' as TURMAALUNO_renovacao, "
							sql = sql & " '' as NomeTurma_renovacao, "
							sql = sql & " 'TRANSFERIDO POR TIP PARA ' + ISNULL(ED.RAZAOSOCIAL, '') AS Desc_SituacaoAluno,"
							sql = sql & " 'N' AS renovado,"
							sql = sql & " 0 AS cod_renovacao, 0 AS cod_turma_renovacao,'' as periodo_renovacao, 0 AS semestre_renovacao, 0 AS ano_renovacao,"
							sql = sql & " 'S' AS tem_tip"
							sql = sql & " FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP"
							sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO.CODIGO = TIP.COD_ALUNO"
							sql = sql & " INNER JOIN SCA_TURMA ON SCA_TURMA.Cod_Turma = TIP.COD_TURMA"
							sql = sql & " LEFT JOIN SEG_EMPRESA ED ON ED.CODIGO = TIP.COD_EMPRESA_DESTINO"
							sql = sql & " where TIP.COD_EMPRESA = " & Session("CodEmpresa")
							sql = sql & " and TIP.COD_TURMA = " & intCodTurma
							sql = sql & " and TIP.ANO_LETIVO = " & clng(strAnoLetivo)
							sql = sql & " and ISNULL(TIP.SITUACAO, 'E') = 'E'"	'pendente: o aluno ainda está ativo na turma (aparece na lista acima, com (TIP))
							sql = sql & " order by NOMEALUNO"
							rs.open sql, cnn
							if rs.eof = false then
								selecionado = "checked"
								cont = 0
								qtde_renovado = 0
								qtde_n_renovado = 0
								while not rs.eof
									cont = cont + 1
									strCodigoAluno        = rs("codigo")
									strMatricula		  = rs("MATRICULA")
									strRenovado		  	  = rs("renovado")
									strTemTip			  = trim(rs("tem_tip") & "")
									if strRenovado = "S" then
										qtde_renovado = qtde_renovado + 1
									else
										qtde_n_renovado = qtde_n_renovado + 1
									end if
									strBloqAltrExcl 	  = ""
									corLinha 			  = " "
									 %>
									 <tr style="cursor: pointer"  <%=corLinha%>>
										<td>
											<%if strRenovado = "N" and strTemTip <> "S" then %>
											<input type="checkbox"  <%=strBloqAltrExcl%>  id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>"></td>
											<%end if%>
																					
										<td><%=strMatricula%></td>
										<td>
											<%=rs("NOMEALUNO")%>&nbsp;<%=strPendencias%>
											<%if strRenovado = "S" then%><br><small class="text-success fw-700">(renovação)</small><%end if%>
											<%if strTemTip = "S" then%><br><small class="text-danger fw-700" title="Aluno com TIP em <%=strAnoLetivo%>: não pode ser renovado. Para renovar, exclua a TIP.">(TIP)</small><%end if%>
										</td>
										<td><%=rs("periodo")%>&nbsp;<%=rs("TURMAALUNO")%>&nbsp;&nbsp;<%=rs("NOMETURMA")%></td>
										<td><%=rs("Desc_SituacaoAluno")%></td>
										<td><%=rs("periodo_renovacao")%>&nbsp;<%=rs("TURMAALUNO_RENOVACAO")%>&nbsp;&nbsp;<%=rs("NOMETURMA_RENOVACAO")%></td>
										<td class="text-center">
											<%if strRenovado = "S" then
												'A conferência de bloqueio (nota, falta ou avaliação no ano novo) é feita ao clicar em Excluir
												'(SP_MAT_RenovacaoDesfaz no mat_renovacao_cod.asp). Antes era feita para cada aluno ao abrir a
												'turma, o que deixava a tela lenta.%>
											<button type="button" class="btn btn-sm btn-outline-danger" title="Excluir a renovação (bloqueado se o aluno já tiver nota, falta ou avaliação no ano novo)"
												onClick="excluirRenovacao('<%=rs("cod_renovacao")%>', '<%=replace(replace(trim(rs("NOMEALUNO") & ""), "\", ""), "'", "\'")%>')">
												<i class="fal fa-times"></i>
											</button>
											<%end if%>
										</td>
										<td class="text-center">
											<%if strRenovado = "S" then %>
											<button type="button" class="btn btn-sm btn-outline-info" title="Imprimir o termo de renovação"
												onClick="imprimirTermo('<%=rs("codigo")%>', '<%=rs("ano_renovacao")%>', '<%=rs("semestre_renovacao")%>', '<%=rs("cod_turma_renovacao")%>', '<%=Session("CodEmpresa")%>')">
												<i class="fal fa-print"></i>
											</button>
											<%end if%>
										</td>
									</tr>
									
									 <%
									 rs.movenext
								  wend
									  
							  else
								 %>
								<tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
									<td colspan="8" align="center" class="celula">Total de Alunos:&nbsp;<%=cont%> </td>
								</tr>
								 <%
							  end if
							  rs.close
							%>
								<tr>
									<td  align="center" colspan="2"><STRONG>Total de Alunos:&nbsp;<%=cont%></STRONG></td>
									<td  align="center" colspan="3"><STRONG>Não renovado:&nbsp;<%=qtde_n_renovado%></STRONG></td>
									<td  align="center" colspan="3"><STRONG>Renovado:&nbsp;<%=qtde_renovado%></STRONG></td>
								</tr>
								</tbody>
							</table>
							<br><strong><%=strMensagemEfetivacao%></strong>
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