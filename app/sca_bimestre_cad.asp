<%
	acao = "I"
	strExecutarSubmitTipoCriterio = "S"
	intCodCriterio 		= Trim(Request.Form("cmbCriterio"))
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
	strPeriodo			= Trim(Request.Form("txtPeriodo"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	if intCodCriterio = "" then 	intCodCriterio  = "0"
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT codigo, data_inicio, data_fim, descricao, ano_letivo, semestre, cod_criterio"
		sql = sql & " FROM SCA_bimestre"
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodCriterio				= rs("cod_criterio")
			strDescricao				= rs("descricao")
			strDescricaoAntiga			= rs("descricao")
			data_inicio					= formataDataAP(rs("data_inicio"))
			data_fim					= formataDataAP(rs("data_fim"))
			strAnoLetivo 				= Trim(rs("Ano_Letivo"))
			intSemestre 				= Trim(rs("Semestre"))
			acao = "AE"

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
								<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
							</div>
							
							<div class="form-group">
								<label class="form-label">Semestre</label>
								<!--#include file="includes/inc_cmdSemestre.asp" -->
							</div>
							
							<div class="form-group">
								<label class="form-label">Critério</label>
								<!--#include file="includes/inc_cmdCriterio.asp" -->
							</div>
							
							<div class="form-group">
								<label class="form-label">Bimestre</label>
								<input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="50" maxlength="50" value="<%=strDescricaoAntiga%>"></td>
								<%if intCodCriterio = "1" then%>
								<select name="txtDescricao" id="txtDescricao" class="form-control" <%=strFuncao%>>
									<option value="1º BIMESTRE" <%IF strDescricao = "1º BIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>1º BIMESTRE</option>			
									<option value="2º BIMESTRE" <%IF strDescricao = "2º BIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>2º BIMESTRE</option>			
									<option value="3º BIMESTRE" <%IF strDescricao = "3º BIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>3º BIMESTRE</option>
									<option value="4º BIMESTRE" <%IF strDescricao = "4º BIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>4º BIMESTRE</option>
								</select>
								<%end if%>
								<%if intCodCriterio = "2" then%>
								<select name="txtDescricao" id="txtDescricao" class="form-control" <%=strFuncao%>>
									<option value="1º TRIMESTRE" <%IF strDescricao = "1º TRIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>1º TRIMESTRE</option>			
									<option value="2º TRIMESTRE" <%IF strDescricao = "2º TRIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>2º TRIMESTRE</option>			
									<option value="3º TRIMESTRE" <%IF strDescricao = "3º TRIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>3º TRIMESTRE</option>
								</select>
								<%end if%>
							</div>
							
							<div class="form-group">
								<label class="form-label">Período inicial</label>
								<input type="text" id="txtDataInicio" name="txtDataInicio" class="form-control" value="<%=data_inicio%>" maxlength="10" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)">
							</div>
							<div class="form-group">
								<label class="form-label">Período final</label>
								<input type="text" id="txtDataFim" name="txtDataFim" class="form-control" value="<%=data_fim%>" maxlength="10" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)">
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
	
	sql = "SELECT codigo, data_inicio, data_fim, descricao, ano_letivo, semestre"
	sql = sql & " FROM SCA_bimestre"
	sql = sql & " where ano_letivo = " & strAnoLetivo	
	if intSemestre <> "0" then
		sql = sql & " and semestre in (" & intSemestre & ")"
	End if
	
	sql = sql & " Order by descricao"
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
									<th><strong>Período</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								periodo = formataDataAP(rs("data_inicio")) & " a " & formataDataAP(rs("data_fim"))
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("codigo")%></td>
									<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
									<td height="20" class="celula"><%=periodo%></td>
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