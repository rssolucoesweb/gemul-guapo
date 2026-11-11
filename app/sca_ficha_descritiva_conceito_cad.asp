<%
	acao = "I"

	 strExecutarSubmit 		= "S"	
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strSigla	 			= Trim(Request.Form("txtSigla"))
	intCodFichaDescritiva	= Trim(Request.form("cmbFichaDescritiva"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strValorInicial 		= Trim(Request.Form("txtValorInicial"))
	strValorFinal 			= Trim(Request.Form("txtValorFinal"))
    if intCodFichaDescritiva = "" then intCodFichaDescritiva = "0"
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Sigla, Cod_Ficha_Descritiva, Descricao, ValorInicial, ValorFinal"
		sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO"
		sql = sql & " where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 				= rs("Codigo")
			intCodFichaDescritiva		= rs("Cod_Ficha_Descritiva")
			strSigla				    = rs("Sigla")
			
			strDescricao			    = rs("Descricao")
			strValorInicial			    = rs("ValorInicial")
			strValorFinal			    = rs("ValorFinal")
			
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
								
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Ficha Descritiva</label>
										<!--#include file="includes/inc_cmdFichaDescritiva.asp"-->
									</div>
								</div>	
								<div class="col-sm-8">	
									<div class="form-group">
										<label class="form-label">Descrição</label>
										<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>" maxlength="100">
									</div>
								</div>
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Sigla</label>
										<input type="text" id="txtSigla" name="txtSigla" class="form-control" value="<%=strSigla%>" maxlength="100">
									</div>
								</div>
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Valor Inicial</label>
										<input type="text" id="txtValorInicial" name="txtValorInicial" class="form-control" onKeyPress="return formataCampo(this, 6, 5)"  size="11" maxlength="5" value="<%=strValorInicial%>">
									</div>
								</div>
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Valor Final</label>
										<input type="text" id="txtValorFinal" name="txtValorFinal" class="form-control" onKeyPress="return formataCampo(this, 6, 5)"  size="11" maxlength="5" value="<%=strValorFinal%>">
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
	<%
	cont =0
	sql = "SELECT Codigo, Sigla, Descricao, ValorInicial, ValorFinal"
	sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO"
	sql = sql & " WHERE Cod_Ficha_Descritiva = " & intCodFichaDescritiva			
	sql = sql & " Order by Codigo"
	rs.open sql, cnn
			
	if rs.eof = false then
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
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>C&oacute;digo</strong></th>
									<th><strong>Sigla</strong></th>
									<th><strong>Descrição</strong></th>
									<th><strong>Valor Inicial</strong></th>
									<th><strong>Valor Final</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							  <%
							while not rs.eof
								cont = cont + 1	
					
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("codigo")%></td>
									<td height="20" class="celula"><%=trim(rs("Sigla"))%></td>
									<td height="20" class="celula"><%=trim(rs("Descricao"))%></td>
									<td height="20" class="celula"><%=trim(rs("ValorInicial"))%></td>
									<td height="20" class="celula"><%=trim(rs("ValorFinal"))%></td>
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