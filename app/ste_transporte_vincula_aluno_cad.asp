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
	<%
	cont =0
	cont = 0	
	intCodPeriodo = ""
	if intCodSituacaoAluno 		= "" then intCodSituacaoAluno 		= "0"
	'seleciona os alunos da turma'					
	sql = "SELECT 'R' as tipo, SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA,SCA_TURMA.cod_turno, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva, SCA_PERIODO.sequencia "
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma and SCA_TURMA.cod_empresa = sca_aluno.cod_empresa "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO and SCA_PERIODO.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
	sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa") 
	sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma  
	sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A' "
	if intCodSituacaoAluno<>"0" then
		sql = sql & " and SCA_SITUACAOALUNO.cod_SituacaoAluno = " & intCodSituacaoAluno
	end if
	sql = sql & " union"
	sql = sql & " SELECT 'E' as tipo, SCA_ALUNO_RENOVACAO.CODIGO AS CODALUNOTURMA,SCA_TURMA.cod_turno, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, '0' as SEQUENCIA, SCA_ALUNO_RENOVACAO.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva, SCA_PERIODO.sequencia "
	sql = sql & " from SCA_ALUNO_RENOVACAO"
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_RENOVACAO.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_RENOVACAO.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_RENOVACAO.COD_TURMA = SCA_TURMA.Cod_Turma and SCA_TURMA.cod_empresa = sca_aluno.cod_empresa "
	sql = sql & " INNER JOIN SCA_TURMA SCA_TURMA_RENOVACAO  ON SCA_ALUNO_RENOVACAO.COD_TURMA_RENOVACAO = SCA_TURMA_RENOVACAO.Cod_Turma "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO and SCA_PERIODO.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
	sql = sql & " where SCA_ALUNO_RENOVACAO.cod_empresa = " & Session("CodEmpresa") 
	sql = sql & " and SCA_ALUNO_RENOVACAO.COD_TURMA = " & intCodTurma  
	sql = sql & " and SCA_ALUNO_RENOVACAO.EFETIVADO = 'S' "
	if intCodSituacaoAluno<>"0" then
		sql = sql & " and SCA_SITUACAOALUNO.cod_SituacaoAluno = " & intCodSituacaoAluno
	end if
	sql = sql & " order by SCA_ALUNO.NOMEALUNO"
	
	rs.open sql, cnn
	
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
						<div class="panel-tag">
							<span class="fw-300">Situação <%strExecutarSubmitSituacaoTransporte="S"%><!--#include file=includes/inc_cmdSituacaoTransporte.asp--></span>
						</div>
						<%
						if rs.eof = false then
						%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Nome</strong></th>
									<th><strong>Rota</strong></th>
									<th><strong>Setor</strong></th>
									<th><strong>Escola</strong></th>
									<th><strong>Data</strong></th>
									<th><strong>Situação</strong></th>
									<th><strong>Situação DDA</strong></th>
									<th><strong>Ação/Obs</strong></th>
									<th><strong>Obs. DDA</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								rota = "<strong><font color='green'>" & rs("rota_atualizada") & "</font></strong>"
								if isnull(rs("rota_atualizada")) then
									rota = "<strong><font color='blue'>" & rs("rota") & "</font></strong>"
								end if
								%>
								  <tr>
									<td class="celula"><%=rs("nome")%></td>
									<td class="celula"><%=rota%></td>
									<td class="celula"><%=rs("setor")%></td>
									<td class="celula"><%=rs("escola")%></td>
									<td class="celula"><%=rs("data_hora_incl")%></td>
									<td class="celula"><%=rs("situacao")%></td>
									<td class="celula"><%=rs("situacaoDDA")%></td>
									<td height="20" class="celula">
										<%
										if rs("cod_sit_dda")="I" or rs("cod_sit_dda")="D" or rs("cod_sit")="I" or rs("cod_sit")="D" then
											response.write rs("obs")
										else
											if rs("cod_sit_dda")="T" then
												response.write rs("obs")
												%>
												<br>
												<button onClick="return abreModalEncaminhamento('<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Encaminhamento</button>
												<%
											else
												if rs("cod_sit")="S" then
												%>
												<button onClick="return abreModalEncaminhamento('<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Encaminhamento</button>
												<%
												else
													response.write rs("obs")
												end if
											end if
										end if
										%>
									</td>
									<td class="celula"><%=rs("obs_DDA")%></td>
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
						<%
						else
						%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Nome</strong></th>
									<th><strong>Rota</strong></th>
									<th><strong>Setor</strong></th>
									<th><strong>Escola</strong></th>
									<th><strong>Data</strong></th>
									<th><strong>Ação</strong></th>
								  </tr>
								</thead>
								<tbody>
									<tr>
										<td height="21" colspan="6" class="celula">Não foi encontrado registros com essa situação!</td>
									</tr>
								</tbody>
							</table>
						</div>
						<%
						
						end if
						rs.close
						  
						%>
					</div>
				</div>
			</div>
		</div>
	</div> 
	
	
	<div class="modal fade" id="modalEncaminhamento" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Encaminhamento da solicitação</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true"><i class="fal fa-times"></i></span>
					</button>
				</div>
				
				<div class="modal-body">
					<div id="divListaSolicitacao"></div>	
				</div>	
				
			</div>
		</div>

	</div>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
