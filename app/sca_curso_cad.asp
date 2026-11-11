<%
	acao = "I"

	strMostraResolucaoCurso	= "S"

	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strDescHistorico	= Trim(Request.Form("txtDescHistorico"))

	strSigla			= Trim(Request.Form("txtSigla"))
	intCodGrau			= Trim(Request.Form("cmbGrau"))
	strGrauAcademico	= Trim(Request.Form("txtGrauAcademico"))
	strModalidade		= Trim(Request.Form("cmbModalidade"))
	strCodigoInep		= Trim(Request.Form("txtCodigoInep"))

	strhabilitacao		= Request.Form("txthabilitacao")
	strReconhecimento	= Request.Form("txtreconhecimento")
	strAutorizacao		= Request.Form("txtautorizacao")
	strDataInicioCurso	= Request.Form("txtDataInicioCurso")

	strDataReconhecimento	= Request.Form("txtDataReconhecimento")
	strDataAutorizacao		= Request.Form("txtDataAutorizacao")
	strCHExigida			= Request.Form("txtCHExigida")
	strsimounao        	 	= Request.Form("cmbSimouNao")
	strSituacao         	= Request.Form("cmbSituacao")
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM SCA_CURSO"
		sql = sql & " Where Cod_curso = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
					
			intCodigo	 		= rs("Cod_curso")
			strDescricao 		= rs("Descricao")
			strDescAbreviada	= rs("Desc_Abreviada")
			strDescHistorico	= rs("Desc_Historico")
			strSigla			= rs("Sigla")
			intCodGrau			= rs("Cod_Grau")
			strGrauAcademico	= rs("Grau_Academico")
			strModalidade		= rs("Modalidade")
			strCodigoInep		= rs("Cod_Inep")
			strhabilitacao		= rs("habilitacao")
			strreconhecimento	= rs("reconhecimento")
			strautorizacao		= rs("autorizacao")
			strDataInicioCurso	= formatadataAP(rs("Inicio_Funcionamento"))
       
			strDataReconhecimento= formatadataAP(rs("DataReconhecimento"))
			strDataAutorizacao	 = formatadataAP(rs("DataAutorizacao"))

			strCHExigida		 = rs("CH_exigida")
			strSimouNao          = rs("processo_seletivo")
			strSituacao		     = rs("Situacao")
			
			acao = "AE"

		end if 
		rs.close
	end if 
	if strDataInicioCurso = "01/01/1900" then strDataInicioCurso = ""
	if strDataReconhecimento = "01/01/1900" then strDataReconhecimento = ""
	if strDataAutorizacao = "01/01/1900" then strDataAutorizacao = ""
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
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Descri&ccedil;&atilde;o (Uso Interno)</label>
										<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>"  maxlength="50">
									</div>
								</div>	
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Descri&ccedil;&atilde;o Abreviada (Hor&aacute;rio)</label>
										<input name="txtDescAbreviada" type="text" class="form-control" id="txtDescAbreviada" size="100" maxlength="150" value="<%=strDescAbreviada%>">
									</div>
								</div>	
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Descri&ccedil;&atilde;o Abreviada (Hist&oacute;rico)</label>
										<input name="txtDescHistorico" type="text" class="form-control" id="txtDescHistorico" size="100" maxlength="150" value="<%=strDescHistorico%>">
									</div>
								</div>
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Sigla</label>
										<input name="txtSigla" type="text" class="form-control" id="txtSigla" size="02" maxlength="02" value="<%=strSigla%>">
									</div>
								</div>	
								
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Grau  Acad&ecirc;mico</label>
										<!--#include file="includes/inc_cmbGrau.asp" -->
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Modalidade</label>
										<select name="cmbModalidade" class="form-control" id="cmbModalidade" >
										  <option value="P" <%if strModalidade = "P" then response.Write("selected") %>>Presencial        </option>
										  <option value="D" <%if strModalidade = "D" then response.Write("selected") %>>Ensino a Distância</option>
										</select>
									</div>
								</div>
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Código inep</label>
										<input name="txtCodigoInep" type="text" class="form-control" id="txtCodigoInep" size="50" maxlength="50" value="<%=strCodigoInep%>">
									</div>
								</div>	
								<!--div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Habilita&ccedil;&atilde;o</label>
										<input name="txtHabilitacao" type="text" class="form-control" id="txtHabilitacao" size="50" maxlength="100" value="<%=strHabilitacao%>">
									</div>
								</div-->	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Situação</label>
										<!--#include file="includes/inc_cmbSituacao.asp"-->
									</div>
								</div>
							</div>	
							<!--br>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Reconhecimento</label>
										<input name="txtReconhecimento" type="text" class="form-control" id="txtReconhecimento" size="50" maxlength="100" value="<%=strReconhecimento%>">
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Publica&ccedil;&atilde;o&nbsp;do reconhecimento</label>
										<input name="txtDataReconhecimento" type="text" class="form-control" id="txtDataReconhecimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataReconhecimento%>">
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Autoriza&ccedil;&atilde;o</label>
										<input name="txtAutorizacao" type="text" class="form-control" id="txtAutorizacao" size="50" maxlength="100" value="<%=strAutorizacao%>">
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Publica&ccedil;&atilde;o&nbsp;da autoriza&ccedil;&atilde;o</label>
										<input name="txtDataAutorizacao" type="text" class="form-control" id="txtDataAutorizacao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataAutorizacao%>">
									</div>
								</div>
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">In&iacute;cio de Funcionamento</label>
										<input name="txtDataInicioCurso" type="text" class="form-control" id="txtDataInicioCurso" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicioCurso%>">
									</div>
								</div>
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">In&iacute;cio de Funcionamento</label>
										<input name="txtCHExigida" type="text" class="form-control" id="txtCHExigida" size="5" maxlength="4" value="<%=strCHExigida%>" onKeyPress="return formataCampo(this, 2, 4)">
									</div>
								</div>
								
								<div class="col-sm-3">
									<div class="form-group">
									</div>
								</div>
							</div-->
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
	sql = "SELECT * "
	sql = sql & " FROM SCA_CURSO"
	sql = sql & " Order by situacao, Descricao"
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
									<th><strong>C&oacute;digo</strong></th>
									<th><strong>Descri&ccedil;&atilde;o</strong></th>
									<th><strong>Modalidade</strong></th>
									<th><strong>C&oacute;digo Inep</strong></th>
									<th><strong>Sigla</strong></th>
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
								
								if trim(rs("Modalidade")) = "D" then
								   strDescricaoModalidade = "EAD"
								else
								   strDescricaoModalidade = "Presencial"
								end if  
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("Cod_curso")%>')">
									<td class="celula"><%=rs("Cod_curso")%></td>
									<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
									<td height="20" class="celula"><%=trim(strDescricaoModalidade)%></td>
									<td height="20" class="celula"><%=trim(rs("Cod_Inep"))%></td>
									<td height="20" class="celula"><%=trim(rs("Sigla"))%></td>
									<td height="20" class="celula"><%=situacao%></td>
								  </tr>
								  <%
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="6" class="celula">Total Registros : <%=cont%></td>
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