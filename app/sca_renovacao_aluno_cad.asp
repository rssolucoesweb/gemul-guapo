<%
	acao = "I"
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitPeriodo  		= "S"
	strExecutarSubmitTurno	 		= "S"
	strExecutarSubmitTurma	 		= "S"	

	intSemestre 			= Trim(Request("cmbSemestre"))
	strSemestre 			= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	intCodTurma 			= Trim(Request("txtCodTurmaRenovacao"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"

	strMostraAlunos = ""
	if 	intCodCurso <> "0" then strMostraAlunos = "S"
	if 	intCodSerie <> "0" then strMostraAlunos = "S"
	if 	intCodTurno <> "0" then strMostraAlunos = "S"
	if 	intCodTurma <> "0" then strMostraAlunos = "S"
	
	if intCodCursoRenovacao = "" then intCodCursoRenovacao = "0"
	if intCodPeriodoRenovacao = "" then intCodPeriodoRenovacao = "0"
	if intCodTurnoRenovacao = "" then intCodTurnoRenovacao = "0"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	strbotaoAtualizar		= "S"
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
							<input readonly name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
							<input readonly name="cmbTurma" type="hidden" class="text" id="cmbTurma"  value="<%=intCodTurma%>">		
							<input readonly name="txtAnoLetivoRenovacao" type="hidden" class="text" id="txtAnoLetivoRenovacao"  value="<%=strAnoLetivo+1%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
							<input readonly name="txtCodAluno" type="hidden" class="text" id="txtCodAluno"  value="<%=strCodAluno%>">
							
							
							<div class="table-responsive-lg">
								<div class="form-group">
									<label class="form-label">Ano atual</label>
									<%=strAnoLetivo%>
								</div>
								
								<div class="form-group">
									<label class="form-label">Ano renovação</label>
									<%=strAnoLetivo+1%>
								</div>
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										<th><strong>Matrícula</strong></th>
										<th><strong>Nome</strong></th>
										<th><strong>Turma</strong></th>
										<th><strong>Confirmado</strong></th>
										<th><strong>Curso</strong></th>
										<th><strong>Período</strong></th>
										<th><strong>Turno</strong></th>
										<th><strong>Ficha</strong></th>
										<th><strong>Cancelamento</strong></th>
									  </tr>
									</thead>
									<tbody>
									
								 <%	
								cont = 0				
								'seleciona os alunos da turma'					
								sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva "
								sql = sql & " FROM SCA_ALUNO_TURMA "
								sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO  "
								sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
								sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
								sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO" 
								sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa")
								sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A'"
								sql = sql & " and SCA_ALUNO_TURMA.COD_ALUNO = " & strCodAluno
								sql = sql & " order by SCA_ALUNO.NOMEALUNO"
								rsAux.open sql, cnn
								if rsAux.eof = false then
									selecionado = "checked"
									while not rsAux.eof

										cont = cont + 1
										strCodigoAluno        = rsAux("codigo")
										strMatricula		  = rsAux("MATRICULA")
										strRenovado		      = "Não"
										strBloqAltrExcl 	  = ""
										corLinha 			  = " "
										cor_fundo			  = ""
										quem=""
										
										curso 	= ""
										periodo = ""
										turno 	= ""
										
										sql = "select r.codigo, c.descricao as curso, p.descricao as periodo, t.desc_turno as turno, r.usuario_incl, r.data_hora_incl "
										sql = sql & " from SCA_ALUNO_RENOVACAO r "
										sql = sql & " inner join sca_curso c on c.cod_curso = r.cod_curso"
										sql = sql & " inner join sca_periodo p on p.cod_periodo = r.cod_periodo"
										sql = sql & " inner join sca_turno t on t.cod_turno = r.cod_turno"
										sql = sql & " where ano_letivo = " & strAnoLetivo & " and cod_aluno = " & strCodigoAluno
										'response.write sql
										rsAux1.open sql, cnn
										if not rsAux1.eof then
											strRenovado		  = "<strong><font color='Green'>Sim</font></strong>"
											cor_fundo		  = " bgcolor='#E0FFFF' "
											quem = rsAux1("usuario_incl") & "<br>" & rsAux1("data_hora_incl")
											curso 	= rsAux1("curso")
											periodo = rsAux1("periodo")
											turno 	= rsAux1("turno")
										end if
										rsAux1.close
										%>
									  <tr <%=cor_fundo%> <%=corLinha%>>
										<td height="20"><%=strMatricula%></td>
										<td height="20"><%=rsAux("NOMEALUNO")%></td>
										<td height="20"><%=rsAux("TURMAALUNO")%>&nbsp;<%=rsAux("NOMETURMA")%></td>
										<td height="20"><%=strRenovado%></td>
										<td height="20">
										<%if curso = "" then%>
											<!--#include file="includes/inc_cmbCursoRenovacao.asp"-->
										<%else%>
											<%=curso%>
										<%end if%>
										</td>
										<td height="20">
										<%if periodo = "" then%>
											<!--#include file="includes/inc_cmbPeriodoRenovacao.asp"-->
										<%else%>
											<%=periodo%>
										<%end if%>									
										</td>
										<td height="20">
										<%if turno = "" then%>
											<!--#include file="includes/inc_cmbTurnoRenovacao.asp"-->
										<%else%>
											<%=turno%>
										<%end if%>
										</td>
										<td height="20">
										<%IF strRenovado = "Não" THEN%>
											&nbsp;
										<%ELSE%>
											<button class="btn btn-primary" type="button" id="button-addon5" onClick="emitirComprovante('<%=rsAux("codigo")%>','<%=strAnoLetivo%>','<%=strSemestre%>')">Emitir comprovante</button>
										<%END IF%>
										</td>
										<td height="20">
											<%IF strRenovado = "Não" THEN%>
												&nbsp;
											<%ELSE%>
												<button class="btn btn-danger" type="button" id="button-addon5" onClick="cancelarComprovante('<%=rsAux("codigo")%>')">Cancelar renovação</button>
											<%END IF%>
											
										</td>
									  </tr>
										<%			
										selecionado = ""
										rsAux.movenext
										wend
									else
										%>
										  <tr> 
											<td colspan="12" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
										  </tr>
										  <%
									end if
									rsAux.close
									%>
									</tbody>
								</table>
								
							</div>
							
							<br>
							
							<%IF strRenovado = "Não" THEN%>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
							<%end if%>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>