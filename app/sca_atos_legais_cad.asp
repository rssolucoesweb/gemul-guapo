<%
	acao = "I"

	strExecutarSubmitCurso 	= "S"
	strExecutarSubmitAtos 	= "S"
	
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	intCodAtos		= Trim(Request("cmbAtos"))
	intCodCurso		= Trim(Request("cmbCurso"))
	
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDataAprovacao 	= Trim(Request.Form("txtDataAprovacao"))
	strDataVencimento 	= Trim(Request.Form("txtDataVencimento"))
	strDataInicioVingencia 	= Trim(Request.Form("txtDataInicioVingencia"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " from SCA_ATOS_LEGALIZACAO "
		sql = sql & " Where codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then	
			intCodAtos			= Trim(rs("cod_atos"))
			strDescricao 		= Trim(rs("descricao"))
			strDataAprovacao 	= Trim(rs("Data_Aprovacao"))
			strDataVencimento 	= Trim(rs("Data_Vencimento"))
			strDataInicioVingencia 	= Trim(rs("Data_Inicio_Vingencia"))
			acao = "AE"
		end if 
		rs.close
	
	end if 
	
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<form id="frm" method="post" action="sca_atos_legais.asp">
		<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
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
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Tipo *</label>
										<!--#include file="includes/inc_cmbAtos.asp" -->
									</div>
								</div>								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Curso *</label>
										<!--#include file="includes/inc_cmdCurso.asp" -->
									</div>
								</div>
								
								<div class="col-sm-7">
									<div class="form-group">
										<label class="form-label">Descrição * </label>
										<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="50" maxlength="200" value="<%=strDescricao%>">
									</div>
								</div>

							</div>
							<br>
							<div class="row">
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Data da Aprovação *</label>
										<input name="txtDataAprovacao" type="text" class="form-control" id="txtDataAprovacao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataAprovacao%>"> 
									</div>
								</div>
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Data de Vencimento *</label>
										<input name="txtDataVencimento" type="text" class="form-control" id="txtDataVencimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataVencimento%>"> 
									</div>
								</div>
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Data Início Vigência *</label>
										<input name="txtDataInicioVingencia" type="text" class="form-control" id="txtDataInicioVingencia" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicioVingencia%>"> 
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
		<%
		cont =0
		if intCodAtos = "" then intCodAtos = "0"
		if intCodCurso = "" then intCodCurso = "0"

		if intCodAtos<>"0" and intCodCurso<>"0" then

			cont =0
			sql = "select * "
			sql = sql & " from SCA_ATOS_LEGALIZACAO "
			sql = sql & " where cod_atos = " & intCodAtos
			sql = sql & " and cod_curso = " & intCodCurso
			sql = sql & " and cod_empresa = " & session("CodEmpresa")
			sql = sql & " Order by cod_atos, data_aprovacao"
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
										<th><strong>Descrição</strong></th>
										<th><strong>Data Aprovação</strong></th>
										<th><strong>Data Vencimento</strong></th>
										<th><strong>Data Início Vigência</strong></th>
									  </tr>
									</thead>
									<tbody>
										<%
										while not rs.eof
											cont = cont + 1	
											%>
											  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
												<td class="celula"><%=trim(rs("descricao"))%></td>
												<td height="20" class="celula"><%=trim(rs("data_aprovacao"))%></td>
												<td height="20" class="celula"><%=trim(rs("data_vencimento"))%></td>
												<td height="20" class="celula"><%=trim(rs("Data_Inicio_Vingencia"))%></td>
											  </tr>
											  <%				
											rs.movenext
										wend
										%>
										<tr>
											<td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
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

		end if
		%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>