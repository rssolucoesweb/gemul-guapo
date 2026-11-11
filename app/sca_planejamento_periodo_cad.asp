<%
	acao = ""

	strAnoLetivo	 						= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo="" then strAnoLetivo = year(date)

	strDataInicial						= Trim(Request.Form("txtDataInicial"))
	strDataFinal						= Trim(Request.Form("txtDataFinal"))

		
	strDias = 0
	sql = "SELECT quantidade_dias, bloqueio"
	sql = sql & " FROM SCA_CONTEUDO_MINISTRADO_PERIODO"
	rs.open sql, cnn
	if rs.eof = false then
		strDias = rs("quantidade_dias")
		strBloqueio = rs("bloqueio")
	end if 
	rs.close
	
	acao = "A"
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
							<br>
							<div class="row">
								<div class="col-sm-12">
									<span><strong><h4>Período planejamento liberado<h4></strong></span>
								</div>	
							</div>
							<br>
							<div class="row">
								<div class="col-sm-2">	
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" onBlur="submit()" class="form-control" value="<%=strAnoLetivo%>" maxlength="4"  onKeyPress="return formataCampo(this, 2, 4)">
									</div>
								</div>	
							</div>
							<br>							
							<%
							for i=1 to 12
								strDataInicial_primeiro					= ""
								strDataFinal_primeiro					= ""
								strDataInicial_segundo					= ""
								strDataFinal_segundo					= ""
								
								sql = "SELECT cod_planejamento_periodo, data_inicial_primeiro, data_final_primeiro, data_inicial_segundo, data_final_segundo"
								sql = sql & " FROM SCA_PLANEJAMENTO_PERIODO"
								sql = sql & " where mes = " & i
								sql = sql & " and ano_letivo = " & strAnoLetivo
								rs.open sql, cnn
								if rs.eof = false then
									cod_planejamento_periodo				= rs("cod_planejamento_periodo")
									strDataInicial_primeiro					= formataDataAP(rs("data_inicial_primeiro"))
									strDataFinal_primeiro					= formataDataAP(rs("data_final_primeiro"))

									strDataInicial_segundo					= formataDataAP(rs("data_inicial_segundo"))
									strDataFinal_segundo					= formataDataAP(rs("data_final_segundo"))
								end if 
								rs.close
								
							%>
							<div class="row">
								<div class="col-sm-12">
								<strong><h4><%=ucase(monthName(i))%>/<%=strAnoLetivo%></h4></strong>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-4">
								<strong>Período que poderá ser planejado à 1ª Quinzena:</strong>
								</div>
								<div class="col-sm-4">
								<strong>Período que poderá ser planejado à 2ª Quinzena:</strong>
								</div>
								<div class="col-sm-2">
								
								</div>
							</div>
							<div class="row">
								<div class="col-sm-2">	
									<div class="form-group">
										<label class="form-label">Data Inicial</label>
										<input type="text" id="txtDataInicial_primeiro_<%=i%>" name="txtDataInicial_primeiro_<%=i%>" class="form-control" value="<%=strDataInicial_primeiro%>" maxlength="10" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)">
									</div>
								</div>
								<div class="col-sm-2">	
									<div class="form-group">
										<label class="form-label">Data Final</label>
										<input type="text" id="txtDataFinal_primeiro_<%=i%>" name="txtDataFinal_primeiro_<%=i%>" class="form-control" value="<%=strDataFinal_primeiro%>" maxlength="10" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)">
									</div>
								</div>
								
								<div class="col-sm-2">	
									<div class="form-group">
										<label class="form-label">Data Inicial</label>
										<input type="text" id="txtDataInicial_segundo_<%=i%>" name="txtDataInicial_segundo_<%=i%>" class="form-control" value="<%=strDataInicial_segundo%>" maxlength="10" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)">
									</div>
								</div>
								<div class="col-sm-2">	
									<div class="form-group">
										<label class="form-label">Data Final</label>
										<input type="text" id="txtDataFinal_segundo_<%=i%>" name="txtDataFinal_segundo_<%=i%>" class="form-control" value="<%=strDataFinal_segundo%>" maxlength="10" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)">
									</div>
								</div>
								
							</div>
							<br>							
							<%
							next
							%>
							<br>
							<div class="row">
								<div class="col-sm-12">
									<span><strong><h4>Conteúdo Ministrado<h4></strong></span>
								</div>	
							</div>
							<br>							
							<div class="row">
								<div class="col-sm-2">	
									<div class="form-group">
										<label class="form-label">Quantidade de Dias</label>
										<input type="text" id="txtDias" name="txtDias" class="form-control" value="<%=strDias%>" maxlength="3" onKeyPress="return formataCampo(this, 2, 3)">
									</div>
								</div>
								<div class="col-sm-2">	
									<div class="form-group">
										<label class="form-label">Bloqueio</label>
										<select name="cmbBloqueio" id="cmbBloqueio" class="form-control" >
										  <option <%if strBloqueio = "H" then response.write "selected"%> value="H">Habilitado</option>
										  <option <%if strBloqueio = "D" then response.write "selected"%> value="D">Desabilitado</option>
										</select>

									</div>
								</div>
							</div>	
							
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>