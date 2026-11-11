<%
	acao = "I"

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSituacaoAcademica	= Trim(Request.Form("cmbSituacao"))
	strAnoLetivo			= Trim(Session("strAnoLetivo"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Cod_PLANEJAMENTO_METODOLOGIA, descricao, situacao, ano_letivo"
		sql = sql & " FROM SCA_PLANEJAMENTO_METODOLOGIA"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and cod_PLANEJAMENTO_METODOLOGIA = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("Cod_PLANEJAMENTO_METODOLOGIA")
			strDescricao			= rs("Descricao")
			strSituacaoAcademica	= rs("situacao")
			strAnoLetivo			= rs("ano_letivo")
			acao 					= "AE"

		end if 
		rs.close
	end if 
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
							<div class="form-group">
								<label class="form-label">Ano Letivo</label>
								<input readonly type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=strAnoLetivo%>">
							</div>
							<div class="form-group">
								<label class="form-label">Descrição</label>
								<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>">
							</div>
							
							<div class="form-group">
								<label class="form-label">Situação</label>
								<!--#include file="includes/inc_cmbSituacaoAcademica.asp"-->
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
	cont =0

	sql = "SELECT cod_PLANEJAMENTO_METODOLOGIA, descricao, situacao"
	sql = sql & " FROM SCA_PLANEJAMENTO_METODOLOGIA"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " Order by situacao, descricao"
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
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("cod_PLANEJAMENTO_METODOLOGIA")%>')">
									<td class="celula"><%=rs("cod_PLANEJAMENTO_METODOLOGIA")%></td>
									<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
									<td height="20" class="celula"><%=situacao%></td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="3" class="celula">Total Registros : <%=cont%></td>
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