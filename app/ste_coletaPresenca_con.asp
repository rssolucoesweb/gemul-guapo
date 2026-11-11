<%
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strBloqueia_NotasDocente = ""
	strExecutarSubmitSemestreTodos   = "S"
	
	'Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and (CodCategoria = 1 OR CodCategoria = 8)"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		strVerificaCategoria = ""
	else
	
		if (Session("Seg_CodCategoria") = "1") then
			strVerificaCategoria 		= "Professor"
			intCodColaboradorProfessor 	= rs("codigo")
		ELSE
			strVerificaCategoria = ""
		END IF	
	
	end if
	rs.close
	
	
	intCodSituacaoAluno = "0"
	sql = "select Cod_SituacaoAluno "
	sql = sql & " from SCA_SITUACAOALUNO"
	sql = sql & " where DESC_SITUACAOALUNO='ATIVO'"
	rs.open sql, cnn
	if NOT rs.eof then
		intCodSituacaoAluno = RS("Cod_SituacaoAluno")
	end if
	rs.close
	
	strAtivos = request("cmbativos")
	if strAtivos = "" then strAtivos = "A"
	
	IF strAtivos <> "A" THEN intCodSituacaoAluno = "0"
	strExecutarSubmitCurso	  	= "S"
	strExecutarSubmitPeriodo  	= "S"
	strExecutarSubmitSemestre 	= "S"
	strExecutarSubmitTurno	  	= "S"
	strExecutarSubmitTurma	 	= "S"
	strExecutarSubmitMes 		= "S"
	strSemestre 				= session("strSemestre")
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	strDataLancamento		= formataDataAP(Trim(Request("txtDataLancamento")))
	strDataLancamentoDate	= formataDataBDcomZeroTraco(Trim(Request("txtDataLancamento")))
	if trim(strDataLancamento) = "" then 
		strDataLancamento = formataDataBD(date)
		strDataLancamentoDate = formataDataBDcomZeroTraco(date)
	end if
	
	intCodTurno		 		= Trim(Request("cmbTurno"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodRota  			= trim(request("cmbRota"))
	strData					= trim(request("txtData"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	strTipoPeriodo = "D"
	sql = " SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, "
	sql = sql & " SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_PERIODO.Tipo "
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
		strTipoLancamento = rs("Tipo")
	END IF
	rs.close
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

	'controla os botões
	acao = "A"
	
'response.write "strQuinzena:" & strQuinzena
'response.write "strDataLancamento:" & strDataLancamento	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="ste_coletaPresencaCon.asp">
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
			
			<!--#include file=inc_tutorial.asp-->
			
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
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input readonly name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Rota:</label>
									<!--#include file="includes/inc_cmdRota.asp"-->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Turno:</label>
									<!--#include file="includes/inc_cmdTurno.asp"-->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Data:</label>
									<input onchange="submit()" name="txtDataLancamento" type="date" onblur="return validaDataSelecionada(this)" class="form-control" id="txtDataLancamento" size="11" maxlength="10" value="<%=strDataLancamentoDate%>" >
								</div>
							</div>
						</div>

						<br>
						<div class="frame-wrap">
							<button onClick="submit()"  name="cmbCadastrar" id="cmbCadastrar" type="button" class="btn btn-outline-success">Consultar</button>
							<button onClick="window.location='ste_coletaPresencaCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-warning">Limpar tela</button>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%
	if intCodRota  	= "" then intCodRota="0"
	if intCodTurno  = "" then intCodTurno="0"
	if intCodRota<>"0" and intCodTurno<>"0" and strDataLancamentoDate<>"" then

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
									<th><strong>Rede</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Escola</strong></th>
									<th><strong>Presente</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	cont = 0
								ssql = "select p.cod_presenca, t.codigo, t.cod_aluno, t.cod_turma, t.turno_estadual, t.codigo_escola_estadual, t.cod_empresa, t.nome, t.obs, t.obs_dda, r.Descricao as rota, t.bairro as setor, em.RAZAOSOCIAL as escola, "
								ssql = ssql & " 	t.cod_rota,ee.nome as escola_estadual,"
								ssql = ssql & " 	t.data_efetivacao, us.USUA_NOME_COMPLETO as usuario_efetivacao, tu.TurmaAluno, tur.desc_turno"
								ssql = ssql & " 	from ste_solicitacao_transporte t "
								ssql = ssql & " 	left join SEG_EMPRESA em on em.codigo = t.Cod_empresa "
								ssql = ssql & " 	left join ste_escola_estadual ee on ee.codigo_escola_estadual = t.codigo_escola_estadual "
								ssql = ssql & " 	left join SEG_USUARIOS_SISTEMA us on us.USUA_CODG = t.usuario_efetivacao"
								ssql = ssql & " 	left join MAT_setores se on se.descricao = t.bairro"
								ssql = ssql & " 	left join STE_ROTA r on r.Cod_rota = t.cod_rota"
								ssql = ssql & " 	left join sca_turma tu on tu.cod_turma = t.cod_turma"
								ssql = ssql & " 	left join sca_turno tur on tur.Cod_Turno = tu.Cod_Turno"
								ssql = ssql & " 	left join ste_presenca p on p.Cod_rota = t.cod_rota and p.Cod_solicitacao_transporte= t.codigo and p.data = '" & strDataLancamentoDate & "'"
								ssql = ssql & " where t.ano_letivo = " & strAnoLetivo & " and t.Situacao = 'D'"
								if intCodRota <> "0" then
									ssql = ssql & " and r.Cod_rota = " & intCodRota
								end if
								
								if intCodTurno <> "0" and intCodTurno<>"" then
									ssql = ssql & " and (tur.desc_turno = '" & strDescricaoTurno & "' or t.turno_estadual = '" & strDescricaoTurno & "')"
								end if
								
								ssql = ssql & " order by t.nome"	
				'response.write ssql
								rs.open ssql, cnn
								if rs.eof = false then
									while not rs.eof
										codigo_ste_solicitacao_transporte      = rs("codigo")
										intCodRota      = rs("cod_rota")
										
										cont = cont + 1 
										escola = rs("escola_estadual")
										rede = "Estadual"
										if isnull(rs("escola_estadual")) then 
											escola = rs("escola")
											rede = "Municipal"
										end if
										presenca=""
										if not isnull(rs("cod_presenca")) then 
											presenca = " checked "
										end if
										%>
										 <tr style="cursor: pointer">
											<td><%=rede%></td>
											<td><%=rs("nome")%></td>
											<td><%=escola%></td>
											<td align="center">
												<input type="checkbox" <%=presenca%> onClick="gravaPresenca(this.checked,'<%=codigo_ste_solicitacao_transporte%>','<%=intCodRota%>','<%=strDataLancamentoDate%>')" id="chkAluno" name="chkAluno" value="<%=codigo_ste_solicitacao_transporte%>" style="transform: scale(2); margin-right: 8px;">
											</td>
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
									<tr style="font-weight: bold;">
									<td colspan="4" class="text-left">Total de <%=cont%> aluno(s)</td>
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
		%>
		
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>