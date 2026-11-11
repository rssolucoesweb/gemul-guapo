<%
	opcao = ""
	sql = "select listar_Alunos, ano_letivo from STE_configura_alunos "
	rs.open sql, cnn
	if rs.eof = false then
		opcao = rs("listar_Alunos")
		strAnoLetivo = rs("ano_letivo")
	end if
	rs.close
	acao = "A"
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="ste_configurar_aluno.asp">
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
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Opção para selecionar alunos nas rotas</label>
									<select name="cmbOpcao" id="cmbOpcao" class="form-control">
									<!--option <%if opcao = "TELA_CONFIRMA_MATRICULA" then response.write "selected"%> value="TELA_CONFIRMA_MATRICULA">Buscar alunos na tela de renovação de matrícula</option> -->
									<option <%if opcao = "ALUNOS_ATIVOS" then response.write "selected"%> value="ALUNOS_ATIVOS">Buscar alunos ativos</option>
									</select>
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
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
									<th><strong>Ano Letivo</strong></th>
									<th><strong>Opção</strong></th>
									<th><strong>Usuario alteração</strong></th>
									<th><strong>Data hora alteração</strong></th>
								  </tr>
								</thead>
								<tbody>
								
									<%
									sql = "SELECT  listar_alunos as opcao, usuario_log, data_log, ano_letivo"
									sql = sql & " FROM STE_configura_alunos_log "
									sql = sql & " order by data_log desc"
									rs.open sql, cnn
									if rs.eof = false then
										while not rs.eof
											if rs("opcao") = "TELA_CONFIRMA_MATRICULA" then opcao = "Buscar alunos na tela de renovação de matrícula"
											if rs("opcao") = "ALUNOS_ATIVOS" then opcao = "Buscar alunos ativos"
											 %>
											 <tr>
												<td><%=trim(rs("ano_letivo"))%></td>
												<td><%=opcao%></td>
												<td><%=trim(rs("usuario_log"))%></td>
												<td><%=trim(rs("data_log"))%></td>
											</tr>
											 <%
											rs.movenext
										wend
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
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>