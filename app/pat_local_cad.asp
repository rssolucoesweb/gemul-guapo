<%
	acao = "I"

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodEmpresa			= Trim(Request.Form("cmbEmpresa"))
	strDescricao			= Trim(Request.Form("txtDescricao"))
	intCodTipoLocal			= Trim(Request.Form("cmbTipoLocal"))
	strLocalOrigem			= Trim(Request.Form("txtLocalOrigem"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT codigo, cod_empresa, descricao, cod_tipo_local, cod_local_origem, isnull(situacao,'A') as situacao"
		sql = sql & " FROM PAT_LOCAL"
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodigo	 		= rs("codigo")
			intCodEmpresa		= rs("cod_empresa")
			strDescricao		= rs("descricao")
			intCodTipoLocal		= rs("cod_tipo_local")
			strLocalOrigem		= rs("cod_local_origem")
			strSituacao			= rs("situacao")
			acao 				= "AE"
		end if 
		rs.close
	end if 
%>

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
			<small><%=descricao_pagina%></small>
		</h1>
	</div>
	<div class="row">
		<div class="col-xl-8">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2><%=pagina%> <span class="fw-300"><i></i></span></h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag"><%=mensagem_alerta_pagina%></div>
						<%end if%>
						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">

							<div class="row">
								<div class="col-md-6">
									<div class="form-group">
										<label class="form-label">Unidade (Sede/Escola)</label>
										<%
										strCmbId = "cmbEmpresa"
										strCmbName = "cmbEmpresa"
										strCmbSelecionado = intCodEmpresa
										strCmbAtributos = ""
										%>
										<!--#include file="includes/inc_cmbEmpresaPat.asp"-->
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label class="form-label">Tipo de Local</label>
										<%
										strCmbId = "cmbTipoLocal"
										strCmbName = "cmbTipoLocal"
										strCmbSelecionado = intCodTipoLocal
										strCmbAtributos = ""
										%>
										<!--#include file="includes/inc_cmbTipoLocalPat.asp"-->
									</div>
								</div>
							</div>

							<div class="form-group">
								<label class="form-label">Descrição do local</label>
								<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" placeholder="Ex: Sala 01, Secretaria, Cozinha..." value="<%=strDescricao%>">
							</div>

							<div class="form-group">
								<label class="form-label">Referência da estrutura física antiga (opcional)</label>
								<input type="text" id="txtLocalOrigem" name="txtLocalOrigem" class="form-control" value="<%=strLocalOrigem%>">
								<small class="form-text text-muted">Só preencher se este local vier de uma migração da estrutura física existente.</small>
							</div>

							<div class="form-group">
								<label class="form-label">Situação</label>
								<!--#include file="includes/inc_cmbSituacao.asp"-->
							</div>

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
	cont = 0
	sql = "SELECT l.codigo, l.descricao, isnull(l.situacao,'A') as situacao, e.RAZAOSOCIAL as nome_empresa, t.descricao as descricao_tipo_local"
	sql = sql & " FROM PAT_LOCAL l"
	sql = sql & " INNER JOIN SEG_EMPRESA e ON e.CODIGO = l.cod_empresa"
	sql = sql & " INNER JOIN PAT_TIPO_LOCAL t ON t.codigo = l.cod_tipo_local"
	sql = sql & " Order by e.RAZAOSOCIAL, l.situacao, l.descricao"

	rs.open sql, cnn

	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-8">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2><%=pagina%> cadastrados</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag"><span class="fw-300">Para editar clique na linha abaixo.</span></div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>C&oacute;digo</strong></th>
									<th><strong>Unidade</strong></th>
									<th><strong>Tipo de Local</strong></th>
									<th><strong>Descri&ccedil;&atilde;o</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								situacao = ""
								if rs("situacao") = "A" then situacao = "Ativo"
								if rs("situacao") = "I" then situacao = "Inativo"
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("codigo")%></td>
									<td height="20" class="celula"><%=trim(rs("nome_empresa"))%></td>
									<td height="20" class="celula"><%=trim(rs("descricao_tipo_local"))%></td>
									<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
									<td height="20" class="celula"><%=situacao%></td>
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
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
