<%

	acao = "I"

	intCodCurso				= Trim(Request.Form("txtCodCurso"))	
	intCodPeriodo			= Trim(Request.Form("txtCodPeriodo"))
	strCurso				= Trim(Request.Form("txtCurso"))	
	strPeriodo				= Trim(Request.Form("txtPeriodo"))
	intCodigo				= Trim(Request.Form("txtCodigo"))
	strAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
	strSemestre             = Trim(Request.Form("txtSemestre"))
	intCodDisciplina        = Trim(Request.Form("txtCodDisciplina"))
	strDisciplina           = Trim(Request.Form("txtDisciplina"))
	pagina_anterior			= pagina_anterior & "?txtAnoLetivo=" & strAnoLetivo & "&cmbCurso=" & intCodCurso & "&cmbPeriodo=" & intCodPeriodo
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
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=strAnoLetivo%>" disabled maxlength="4">
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Curso</label>
										<input type="text" id="txtCodCurso" name="txtCodCurso" class="form-control" value="<%=strCurso%>" disabled >
									</div>
								</div>	
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Período</label>
										<input type="text" id="txtCodPeriodo" name="txtCodPeriodo" class="form-control" value="<%=strPeriodo%>" disabled >
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Disciplina</label>
										<input type="text" id="txtDisciplina" name="txtDisciplina" class="form-control" value="<%=strDisciplina%>" disabled >
									</div>								
								</div>
							</div>

							<br>
							<div class="frame-wrap">
								<%
								strBotaoLimparTelaAtual  = "N"
								strBotaoConsultarTelaAtual = "N"
								%>
								<!--#include file="includes/inc_botoes_consulta_novo.asp"-->
							</div>

							<%
							intCodigoPlanejamento = 0
							intCodigoPlanejamentoEscola = 0
							intCodigoSituacaoPlanejamento = 1 'Aguardando Cadastro
							intCodigoSituacaoPlanejamentoEscola = 4 'Aguardando Secretaria

							sql="select cod_planejamento_geral, cod_situacao_planejamento from SCA_PLANEJAMENTO_GERAL"
							sql=sql & " where anoLetivo = " & strAnoLetivo
							sql=sql & " and semestre = " & strSemestre
							sql=sql & " and cod_periodo = " & intCodPeriodo
							sql=sql & " and cod_disciplina = " & intCodDisciplina
							'sql=sql & " and cod_empresa =" & session("codEmpresa")
if ucase(session("usuarioWeb")) = "SERGIO" then
	response.write sql
end if
							rs.open sql, cnn
							if rs.eof = false then
								intCodigoPlanejamento = rs("cod_planejamento_geral")
								intCodigoSituacaoPlanejamento = rs("cod_situacao_planejamento")
								if intCodigoSituacaoPlanejamento = 3 and SESSION("controleAcessoPlanejamentoAnual")=2 then 
									intCodigoSituacaoPlanejamento = 1 'Aguardando Cadastro
								end if
							end if
							rs.close


							if SESSION("controleAcessoPlanejamentoAnual") = 2 then
							
								sql="select cod_planejamento_geral, cod_situacao_planejamento from SCA_PLANEJAMENTO_GERAL"
								sql=sql & " where cod_planejamento_geral_pai=" & intCodigoPlanejamento
								sql=sql & " and cod_empresa = " & session("codEmpresa")
								rs.open sql, cnn
								if rs.eof = false then
									intCodigoPlanejamentoEscola = rs("cod_planejamento_geral")
									intCodigoSituacaoPlanejamentoEscola = rs("cod_situacao_planejamento")
									intCodigoSituacaoPlanejamento = rs("cod_situacao_planejamento")
								end if
								rs.close

							end if

							%>							

							<div class="alert border-faded bg-transparent text-secondary fade show" role="alert">
								<div class="d-flex align-items-center">

									<div class="flex-1">
										<span class="h5 color-success-600">Unidade Temática / Linguagem / Práticas de Linguagem</span>
										<br>
										<span class="edicao">Clique no botão para adicionar novos itens</span>
									</div>
									<div class="flex-1" align="right">
										<button type="button" class="btn btn-outline-success btn-sm btn-w-m waves-effect waves-themed" data-toggle="modal" data-target="#modalNovoItem"  onclick="carregaCamposModal(false,0,0,'S')">Criar nova Unidade Temática</button>
									</div>
									
									<button type="button" class="btn btn-outline-success btn-sm btn-w-m waves-effect waves-themed edicao" data-toggle="modal" data-target="#modalNovoItem" onclick="carregaCamposModal(false,0,0,'N')">Novo Item</button>
								</div>
							</div>

							<div id="divListaPlanejamento"></div>					
							<div class="frame-wrap">
								<button onclick="<%if SESSION("controleAcessoPlanejamentoAnual") = 1 then%>liberar()<%elseif SESSION("controleAcessoPlanejamentoAnual") = 2 then%>liberarProfessor()<%end if%>" type="button" class="btn btn-outline-success waves-effect waves-themed edicao">Liberar Planejamento</button>
							</div>

						</form>
					</div>
				</div>

				
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="modalNovoItem" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

			<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">Novo Item</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true"><i class="fal fa-times"></i></span>
						</button>
					</div>
					<div class="modal-body">
							<div class="form-group" id="divBimestre">
								<label class="form-label" for="simpleinput"><%if SESSION("controlePeriodoDeTempo") = 1 then%>Bimestre<%elseif SESSION("controlePeriodoDeTempo") = 2 then%>Trimestre<%end if%></label>
								<select id="cmbBimestre" class="form-control">
									<option value="0">Selecione...</option>
									<%if SESSION("controlePeriodoDeTempo") = 1 then%>
									<option value="1">1° Bimestre</option>
									<option value="2">2° Bimestre</option>
									<option value="3">3° Bimestre</option>
									<option value="4">4° Bimestre</option>
									<option value="5">Unico</option>
									<%elseif SESSION("controlePeriodoDeTempo") = 2 then%>
									<option value="1">1° Trimestre</option>
									<option value="2">2° Trimestre</option>
									<option value="3">3° Trimestre</option>
									<option value="5">Unico</option>
									<%end if%>
								</select>
							</div>					
						
							<div class="form-group">
								<label class="form-label" for="simpleinput">Descrição</label>

									<input type="hidden" id="txtHiddenOrigem" class="form-control" value="<%=SESSION("controleAcessoPlanejamentoAnual")%>">
									<input type="hidden" id="txtHiddenCodigoPlanejamento" class="form-control" value="<%=intCodigoPlanejamento%>">
									<input type="hidden" id="txtHiddenCodigoPlanejamentoEscola" class="form-control" value="<%=intCodigoPlanejamentoEscola%>">

									<input type="hidden" id="txtHiddenCodigoSituacaoPlanejamento" class="form-control" value="<%=intCodigoSituacaoPlanejamento%>">
									<input type="hidden" id="txtHiddenAnoLetivo" class="form-control" value="<%=strAnoLetivo%>">
									<input type="hidden" id="txtHiddenSemestre" class="form-control" value="<%=strSemestre%>">
									<input type="hidden" id="txtHiddenCodPeriodo" class="form-control" value="<%=intCodPeriodo%>">
									<input type="hidden" id="txtHiddenCodDisciplina" class="form-control" value="<%=intCodDisciplina%>">
									<input type="hidden" id="txtHiddenCodigoItemPai" class="form-control">
									<input type="hidden" id="txtHiddenCodigoTipo" class="form-control">
									<input type="hidden" id="txtHiddenAcao" class="form-control">
									<input type="text" id="txtDescricao" class="form-control">
								</div>						
						
							</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
						<button id="btnIncluirItem" type="button" class="btn btn-primary waves-effect waves-themed">Incluir</button>
					</div>
				</div>
			</div>

	</div>	
	
	<div class="modal fade" id="modalReplicar" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

			<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">Replicar novo item para todas as unidades ou selecione uma abaixo</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true"><i class="fal fa-times"></i></span>
						</button>
					</div>
					<div class="modal-body">
										
						
							<div class="form-group">
								<label class="form-label" for="simpleinput">Item:</label>
								<input readonly type="text" id="txtNovoItemDescricao" class="form-control">
								<input type="hidden" id="txtHidden_cod_item_planejamento_geral" class="form-control">
								<input type="hidden" id="txtHidden_ano_letivo_replicacao" class="form-control">
							</div>
							<div class="form-group">
								<label class="form-label" for="simpleinput">Unidade:</label>
								<!--#include file="includes/inc_cmbEmpresas.asp"-->
							</div>
							
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
						<button id="btnIncluirReplicacao" type="button" class="btn btn-warning waves-effect waves-themed">Replicar</button>
					</div>
				</div>
			</div>

	</div>	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>