<%
	acao = "I"

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	ano_letivo	 			= Trim(Request.Form("ano_letivo"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT cod_turma,nome,cod_modalidade,cod_categoria,cod_turno,ano_letivo,capacidade,situacao"
		sql = sql & " FROM ESP_TURMA"
		sql = sql & " where Cod_turma = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("cod_turma")
			nome				= rs("nome")
			cod_modalidade		= rs("cod_modalidade")
			cod_categoria		= rs("cod_categoria")
			intCodTurno			= rs("cod_turno")
			ano_letivo			= rs("ano_letivo")
			capacidade			= rs("capacidade")
			strSituacao			= rs("situacao")
			
			acao 					= "AE"

		end if 
		rs.close
	end if 
	
	strAnoLetivo 			= session("strAnoLetivo")
	
	if ano_letivo="" then ano_letivo = strAnoLetivo
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
		<div class="col-xl-8">
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
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="ano_letivo" name="ano_letivo" class="form-control" onBlur="submit()"  value="<%=ano_letivo%>" maxlength="4" onKeyPress="return formataCampo(this,2,4)">
									</div>
								</div>	
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Nome da Turma</label>
										<input type="text" id="nome" name="nome" class="form-control" value="<%=nome%>" maxlength="50">
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Modalidade</label>
										<!--#include file="includes/inc_cmbModalidade.asp" -->
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Categoria</label>
										<!--#include file="includes/inc_cmbCategoria.asp" -->
									</div>
								</div>	
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Turno</label>
										<!--#include file="includes/inc_cmdTurno.asp" -->
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Capacidade</label>
										<input type="text" id="capacidade" name="capacidade" class="form-control" value="<%=capacidade%>" maxlength="4" onKeyPress="return formataCampo(this,2,4)">
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Situação</label>
										<!--#include file="includes/inc_cmbSituacao.asp" -->
									</div>
								</div>	
							</div>	
							<hr>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont =0
	sql = "select t.cod_turma as codigo, t.nome, t.ano_letivo, iif(t.situacao='A','ATIVO','INATIVO') as situacao, iif(c.sexo='M','MASCULINO','FEMININO') as sexo, m.descricao as modalidade, c.descricao as categoria "
	sql = sql & " from esp_turma t"
	sql = sql & " inner join esp_modalidade m on m.cod_modalidade = t.cod_modalidade"
	sql = sql & " inner join esp_categoria c on c.cod_categoria = t.cod_categoria"
	sql = sql & " inner join sca_turno tu on tu.cod_turno = t.cod_turno"
	sql = sql & " order by m.descricao, c.descricao, t.nome"
	rs.open sql, cnn
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-8">
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
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>C&oacute;digo</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Modalidade</strong></th>
									<th><strong>Categoria</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("codigo")%></td>
									<td height="20" class="celula"><%=trim(rs("nome"))%></td>
									<td height="20" class="celula"><%=trim(rs("modalidade"))%></td>
									<td height="20" class="celula"><%=trim(rs("categoria"))%> - <%=trim(rs("sexo"))%></td>
									<td height="20" class="celula"><%=trim(rs("situacao"))%></td>
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