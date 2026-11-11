<%
	acao = "I"

	strExecutarSubmitTipoCriterio 	= "S"
	strExecutarSubmitCurso 	= "S"
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	intCodTipoCriterio		= Trim(Request("cmbTipoCriterio"))
	
	intCodCurso		= Trim(Request("cmbCurso"))
	strDescricao 	= Trim(Request.Form("txtDescricao"))
	strPosicao	 	= Trim(Request.Form("cmbPosicao"))
	strSigla		= Trim(Request.Form("txtSigla"))
	intCodAvaliacaoAgrupamento		= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
	strFormula		= Trim(Request.Form("txtFormula"))
	strDigitar		= Trim(Request.Form("txtDigitar"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM SCA_TIPO_AVALIACAO"
		sql = sql & " Where codigo = " & intCodigo
		sql = sql & " and cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then	
			if not isnull(rs("cod_curso")) then intCodCurso				= rs("cod_curso")
			strDescricao			= rs("descricao")
			strSigla				= rs("sigla")
			intCodAvaliacaoAgrupamento				= rs("bimestre")
			intCodTipoCriterio		= rs("cod_tipo_criterio")
			strPosicao				= rs("posicao")
			strFormula				= rs("formula")
			strDigitar				= trim(rs("digitar"))
			
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
		<div class="col-xl-10">
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
								<label class="form-label">Tipo critério</label>
								<!--#include file="includes/inc_cmdTipoCriterio.asp" -->
							</div>
							
							<div class="form-group">
								<label class="form-label">Curso</label>
								<!--#include file="includes/inc_cmdCurso.asp" -->
							</div>
							
							<div class="form-group">
								<label class="form-label">Descrição</label>
								<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="50" maxlength="50" value="<%=strDescricao%>">
							</div>
							
							<div class="form-group">
								<label class="form-label">Sigla</label>
								<input name="txtSigla" type="text" class="form-control" id="txtSigla" size="15" maxlength="10" value="<%=strSigla%>">
							</div>
							
							<div class="form-group">
								<label class="form-label">Tipo</label>
								<!--#include file="includes/inc_cmdTipoAvaliacaoAgrupamento.asp" -->
							</div>
							
							<div class="form-group">
								<label class="form-label">Campo</label>
								<select name="cmbPosicao" class="form-control" id="cmbPosicao" >
									<%for i=1 to 25%>
									<option value="<%=i%>" <%if strPosicao = i then response.Write("selected") %>>C<%=i%></option>
									<%next%>
								</select>
							
							<div class="form-group">
								<label class="form-label">Formula</label>
								<input name="txtFormula" type="text" class="form-control" id="txtFormula" size="100" maxlength="200" value="<%=strFormula%>">
							</div>
							
							
							<div class="form-group">
								<label class="form-label">Digitar</label>
								<select name="txtDigitar" class="form-control" id="txtDigitar">
									<option value="S" <%if trim(strDigitar) = "S" then response.Write("selected") %>>Sim</option>
									<option value="N" <%if trim(strDigitar) = "N" then response.Write("selected") %>>N&atilde;o</option>
								  </select>
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
</div>
	<%
	cont =0
	if intCodCurso = "" then intCodCurso = "0"
		if intCodTipoCriterio = "" then intCodTipoCriterio = "0"
		
		'if trim(intCodCurso) <> "0" and intCodTipoCriterio <> "0" then
			cont =0
			sql = "SELECT SCA_TIPO_AVALIACAO_AGRUPAMENTO.DESCRICAO AS AGRUPAMENTO, SCA_TIPO_AVALIACAO.codigo, SCA_TIPO_AVALIACAO.Descricao, SCA_TIPO_AVALIACAO.Sigla, SCA_TIPO_AVALIACAO.bimestre, SCA_TIPO_AVALIACAO.posicao, SCA_TIPO_AVALIACAO.formula, SCA_TIPO_AVALIACAO.digitar, SCA_CURSO.sigla AS CURSO"
			sql = sql & " FROM SCA_TIPO_AVALIACAO"
			sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO ON SCA_TIPO_AVALIACAO_AGRUPAMENTO.CODIGO = SCA_TIPO_AVALIACAO.BIMESTRE"
			sql = sql & " LEFT JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_TIPO_AVALIACAO.COD_CURSO"
			sql = sql & " where SCA_TIPO_AVALIACAO.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and 	SCA_CURSO.COD_CURSO = "& intCodCurso
			sql = sql & " and 	SCA_TIPO_AVALIACAO.COD_TIPO_CRITERIO = "& intCodTipoCriterio
			sql = sql & " Order by posicao"
			rs.open sql, cnn
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-10">
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
									<th><strong>Curso</strong></th>
									<th><strong>Descrição</strong></th>
									<th><strong>Sigla</strong></th>
									<th><strong>Tipo</strong></th>
									<th><strong>Campo</strong></th>
									<th><strong>F&oacute;rmula</strong></th>
									<th><strong>Digitar</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									while not rs.eof
										cont = cont + 1	
										if trim(rs("bimestre")) = "1" or trim(rs("bimestre")) = "2" or trim(rs("bimestre")) = "3" or trim(rs("bimestre")) = "4" then
											bimestre = trim(rs("bimestre")) & "º Bimestre"
										else
											bimestre = rs("bimestre") & " - "& trim(rs("AGRUPAMENTO"))
										end if

										if not isnull(rs("posicao")) then posicao = trim(rs("posicao"))
										%>
										  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
											<td class="celula"><%=rs("CURSO")%>&nbsp;</td>
											<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
											<td height="20" class="celula"><%=trim(rs("sigla"))%></td>
											<td class="celula"><%=bimestre%></td>
											<td height="20" class="celula">C<%=posicao%></td>
											<td class="celula"><%=trim(rs("formula"))%>&nbsp;</td>
											<td class="celula" align="center"><%=trim(rs("digitar"))%>&nbsp;</td>
										  </tr>
										  <%				
										rs.movenext
									wend
									%>
									<tr>
										<td height="21" colspan="7" class="celula">Total Registros : <%=cont%></td>
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