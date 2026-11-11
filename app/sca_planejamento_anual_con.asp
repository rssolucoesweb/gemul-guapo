<%

	'----CONTROLE SE ACESSO
	'1 - SECRETARIA
	'2 - ESCOLA
	SESSION("controleAcessoPlanejamentoAnual")=2

	acao = "I"

	strExecutarSubmitCurso = "S"
	strBotaoVoltaTelaAnterior = "N"
	strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	
	intCodCurso				= Trim(Request("cmbCurso"))	
	intCodPeriodo			= Trim(Request("cmbPeriodo"))
	intCodSituacaoPlanejamento	= Trim(Request.Form("cmbSituacaoPlanejamento"))
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
						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" 	type="hidden" id="txtCodigo">
							<input name="txtCodCurso" 	type="hidden" id="txtCodCurso">
							<input name="txtCodPeriodo" type="hidden" id="txtCodPeriodo">
							<input name="txtCurso" 		type="hidden" id="txtCurso">
							<input name="txtPeriodo" 	type="hidden" id="txtPeriodo">
							<input name="txtSemestre" 	type="hidden" id="txtSemestre">
							<input name="txtCodDisciplina" 	type="hidden" id="txtCodDisciplina">
							<input name="txtDisciplina" 	type="hidden" id="txtDisciplina">
							
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=strAnoLetivo%>"  maxlength="4">
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Curso</label>
										<!--#include file="includes/inc_cmdCurso.asp" -->
									</div>
								</div>	
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Período</label>
										<!--#include file="includes/inc_cmdPeriodo.asp" -->
									</div>
								</div>	
							
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Situa&ccedil;&atilde;o</label>
										<%
										filtroSituacaoPlanejamento = "1,2"
										%>
										<!--#include file="includes/inc_cmbSituacaoPlanejamento.asp" -->
									</div>
								</div>	
							
								
							</div>	
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_consulta_novo.asp"-->
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont =0
	if intCodPeriodo = "" then intCodPeriodo = 0
	sql = "select pla.cod_planejamento_geral, g.AnoReferencia as anoLetivo, si.cor_linha_escola,  si.cod_situacao_planejamento_anual, g.SemestreReferencia as semestre, c.Descricao as curso, c.cod_curso, p.Descricao as periodo, p.cod_periodo, di.Desc_Disciplina as disciplina,di.Cod_Disciplina, isnull(si.descricao_escola,'Aguardando Secretaria') as situacao "
	sql = sql & " from SCA_GRADECURRICULAR g "
	sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA d on d.Cod_GradeCurricular = g.Cod_GradeCurricular "
	sql = sql & " inner join SCA_DISCIPLINA di on di.Cod_Disciplina = d.Cod_Disciplina "
	sql = sql & " inner join SCA_PERIODO p on p.Cod_Periodo = g.Cod_Periodo "
	sql = sql & " inner join SCA_CURSO c on c.Cod_curso = p.Cod_Curso "
	sql = sql & " inner join SCA_PLANEJAMENTO_GERAL pla on pla.cod_disciplina=di.cod_disciplina "
	sql = sql & " 									and pla.Cod_Periodo=p.cod_periodo "
	sql = sql & " 									and g.AnoReferencia = pla.anoLetivo" 
	sql = sql & " 									and g.SemestreReferencia = pla.semestre "
	sql = sql & " left join SCA_SITUACAO_PLANEJAMENTO si on si.cod_situacao_planejamento_anual = pla.cod_situacao_planejamento "
	sql = sql & " where pla.cod_empresa = " & session("codEmpresa") & " and g.AnoReferencia = " & strAnoLetivo
	sql = sql & " and g.Cod_Periodo = " & intCodPeriodo
	sql = sql & " union select pla.cod_planejamento_geral, g.AnoReferencia as anoLetivo, si.cor_linha_escola,  si.cod_situacao_planejamento_anual, g.SemestreReferencia as semestre, c.Descricao as curso, c.cod_curso, p.Descricao as periodo, p.cod_periodo, di.Desc_Disciplina as disciplina,di.Cod_Disciplina, isnull(si.descricao_escola,'Aguardando Secretaria') as situacao "
	sql = sql & " from SCA_GRADECURRICULAR g "
	sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA d on d.Cod_GradeCurricular = g.Cod_GradeCurricular "
	sql = sql & " inner join SCA_DISCIPLINA di on di.Cod_Disciplina = d.Cod_Disciplina "
	sql = sql & " inner join SCA_PERIODO p on p.Cod_Periodo = g.Cod_Periodo "
	sql = sql & " inner join SCA_CURSO c on c.Cod_curso = p.Cod_Curso "
	sql = sql & " left join SCA_PLANEJAMENTO_GERAL pla on pla.cod_empresa is null and pla.cod_disciplina=di.cod_disciplina "
	sql = sql & " 									and pla.Cod_Periodo=p.cod_periodo "
	sql = sql & " 									and g.AnoReferencia = pla.anoLetivo" 
	sql = sql & " 									and g.SemestreReferencia = pla.semestre "
	sql = sql & " left join SCA_SITUACAO_PLANEJAMENTO si on si.cod_situacao_planejamento_anual = pla.cod_situacao_planejamento "
	sql = sql & " where g.AnoReferencia = " & strAnoLetivo
	sql = sql & " and g.Cod_Periodo = " & intCodPeriodo
	sql = sql & " and d.cod_disciplina not in ("
	
	sql = sql & " select di.Cod_Disciplina"
	sql = sql & " from SCA_GRADECURRICULAR g "
	sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA d on d.Cod_GradeCurricular = g.Cod_GradeCurricular "
	sql = sql & " inner join SCA_DISCIPLINA di on di.Cod_Disciplina = d.Cod_Disciplina "
	sql = sql & " inner join SCA_PERIODO p on p.Cod_Periodo = g.Cod_Periodo "
	sql = sql & " inner join SCA_CURSO c on c.Cod_curso = p.Cod_Curso "
	sql = sql & " inner join SCA_PLANEJAMENTO_GERAL pla on pla.cod_disciplina=di.cod_disciplina "
	sql = sql & " 									and pla.Cod_Periodo=p.cod_periodo "
	sql = sql & " 									and g.AnoReferencia = pla.anoLetivo" 
	sql = sql & " 									and g.SemestreReferencia = pla.semestre "
	sql = sql & " left join SCA_SITUACAO_PLANEJAMENTO si on si.cod_situacao_planejamento_anual = pla.cod_situacao_planejamento "
	sql = sql & " where pla.cod_empresa = " & session("codEmpresa") & " and g.AnoReferencia = " & strAnoLetivo
	sql = sql & " and g.Cod_Periodo = " & intCodPeriodo
	
	sql = sql & " )"
	sql = sql & " order by si.cod_situacao_planejamento_anual desc, di.Desc_Disciplina	"
	'response.write sql
	rs.open sql, cnn
		
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastrados
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
									<th><strong>Disciplina</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								bloq = "S"
								if rs("situacao") = "Aguardando cadastro" or rs("situacao") = "Liberado ao Professor" then
									bloq = "N"
								end if
								
								
								%>
								  <tr <%=rs("cor_linha_escola")%> height="20" <%if bloq = "N" then%> style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("cod_planejamento_geral")%>','<%=rs("cod_curso")%>','<%=rs("cod_periodo")%>','<%=rs("curso")%>','<%=rs("periodo")%>','<%=rs("semestre")%>','<%=rs("Cod_Disciplina")%>','<%=rs("disciplina")%>')" <%end if%>>
									<td><%=rs("anoLetivo")%></td>
									<td><%=rs("curso")%></td>
									<td><%=rs("periodo")%></td>
									<td><%=rs("disciplina")%></td>
									<td><%=rs("situacao")%> </td>
								  </tr>
								  <%
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="5" class="celula">Total Registros : <%=cont%></td>
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
	  
	%>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>