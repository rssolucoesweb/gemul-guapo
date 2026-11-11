<%
	acao = "I"

	strExecutarSubmit				= "S"
    strSimouNao_submit           	= "N"
	strMostraPerguntas				= ""
	strPaginaTitulo 				= "FichaDescritiva_cad.asp"
	strExecutarSubmitCurso			= "S"
	strExecutarSubmitPeriodo			= "S"

	intCodigo						= Trim(Request.Form("txtCodigo"))
	intAnoLetivo					= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 					= Trim(Request.Form("txtSemestre"))
	strDescricao 					= Trim(Request.Form("txtDescricao"))
	strDescricaoAbreviada			= Trim(Request.Form("txtDescricaoAbreviada"))
	strSituacao						= Trim(Request.Form("cmbSituacao"))
	intCodTipoEmpresa 				= Trim(Request.Form("cmbTipoEmpresa"))
	intCodCurso	 					= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 						= Trim(Request.Form("cmbPeriodo"))
	
    strObservacao	                = Trim(Request.Form("txtObservacao"))
    strRodape	                    = Trim(Request.Form("txtRodape"))
	strSimouNao         			= Trim(Request.Form("cmbSimouNao"))
	filtroSituacao         			= Trim(Request.Form("filtroSituacao"))
	if filtroSituacao = "" then filtroSituacao= "A"
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, Descricao, descricao_abreviada, Ano_Letivo, Semestre, cod_curso, cod_periodo, "
		sql = sql & " Situacao, CodTipoEmpresa , observacoes, rodape, Publicar "
		sql = sql & " FROM SCA_FICHA_DESCRITIVA"
		sql = sql & " Where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodigo	 			= rs("Codigo")
			strDescricao			= rs("Descricao")
			strDescricaoAbreviada	= rs("descricao_abreviada")
			intAnoLetivo			= rs("Ano_Letivo")
			intSemestre				= rs("Semestre")
			strSituacao				= rs("Situacao")
			intCodTipoEmpresa		= rs("CodTipoEmpresa")
			strObservacao			= rs("Observacoes")
			strRodape				= rs("Rodape")
			strSimouNao				= rs("Publicar")
			
			intCodCurso				= rs("cod_curso")
			intCodPeriodo			= rs("cod_periodo")

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
							<br>
							<div class="row">
								<div class="col-sm-12">
									<span><strong>Fechamento do ano letivo</strong></span>
								</div>	
							</div>					
							<br>

							<div class="row">
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Ano</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=intAnoLetivo%>" maxlength="4"  onKeyPress="return formataCampo(this,2,4)">
									</div>
								</div>
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Semestre</label>
										<!--#include file="includes/inc_cmdSemestre.asp"-->
									</div>
								</div>	
								<div class="col-sm-6">	
									<div class="form-group">
										<label class="form-label">Descri&ccedil;&atilde;o</label>
										<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>" maxlength="100">
									</div>
								</div>
								
							</div>	
							<br>
							<div class="row">
								
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Liberar para proefessor(a)?</label>
										<!--#include file="includes/inc_cmbSimouNao.asp"-->
									</div>
								</div>	
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Situa&ccedil;&atilde;o</label>
										<!--#include file="includes/inc_cmdSituacao.asp"-->
									</div>
								</div>
								<div class="col-sm-6">	
									<div class="form-group">
										<label class="form-label">Descri&ccedil;&atilde;o abreviada</label>
										<input type="text" id="txtDescricaoAbreviada" name="txtDescricaoAbreviada" class="form-control" value="<%=strDescricaoAbreviada%>" maxlength="15">
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Tipo Empresa</label>
										<!--#include file="includes/inc_cmbTipoEmpresa.asp"-->
									</div>
								</div>
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Curso</label>
										<!--#include file="includes/inc_cmdCursoGrupo.asp"-->
									</div>
								</div>	
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Per&iacute;odo</label>
										<!--#include file="includes/inc_cmdPeriodoGrupo.asp"-->
									</div>
								</div>
								
							</div>							
							<br>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Observações com máximo de 3000 caracteres <br><i><b>(será mostrado somente para o professor)</b></i></label>
										<textarea name="txtObservacao" cols="90" rows="6" class="form-control" id="txtObservacao"><%=strObservacao%></textarea> 
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Rodap&eacute; com M&aacute;ximo 200 caracteres <br><i><b>(será mostrado somente na impressão)</b></i></label>
										<textarea name="txtRodape" cols="90" rows="6" class="form-control" id="txtRodape"><%=strRodape%></textarea>
									</div>
								</div>
							</div>
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Situação</label>
										<select name="filtroSituacao" class="form-control" id="filtroSituacao" onChange="submit()">
										  <option value="A" <%if filtroSituacao = "A" then response.Write("selected") %>>Ativo</option>
										  <option value="I" <%if filtroSituacao = "I" then response.Write("selected") %>>Inativo</option>
										</select>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont =0
	sql = "SELECT p.Codigo, p.Cod_empresa, p.Descricao, p.descricao_abreviada, p.Ano_Letivo, p.Semestre, p.Situacao, p.Publicar, c.descricao as curso, p.descricao as periodo"
	sql = sql & " FROM SCA_FICHA_DESCRITIVA p inner join sca_periodo pe on pe.cod_periodo = p.cod_periodo"
	sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
	sql = sql & " WHERE p.Cod_grupo = " & Session("CodGrupo")	
	if filtroSituacao<>"" then
		sql = sql & " and p.situacao = '" & filtroSituacao & "'"
	end if
	sql = sql & " Order by p.Ano_Letivo, p.Semestre, p.Descricao"
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
									<th><strong>Ano/Semestre</strong></th>
									<th><strong>Descrição</strong></th>
									<th><strong>Abreviada</strong></th>
									<th><strong>Curso</strong></th>
									<th><strong>Per&iacute;odo</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
									<th><strong>Liberado</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							  <%
							while not rs.eof
								cont = cont + 1	
					
								if rs("Situacao") = "A" then strSituacao = "Ativo" 
								if rs("Situacao") = "I" then strSituacao = "Inativo" 
								if not isnull(rs("Publicar")) then
									if rs("Publicar") = "S" then strPublicar = "Sim" 
									if rs("Publicar") = "N" then strPublicar = "N&atilde;o"
								else	
									strPublicar = "" 
								end if
								strSemestre = ""
								if rs("semestre") = "3" then strSemestre = "Anual" 
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("codigo")%></td>
									<td height="20" class="celula"><%=trim(rs("Ano_Letivo"))%>/<%=strSemestre%></td>
									<td height="20" class="celula"><%=trim(rs("Descricao"))%></td>
									<td height="20" class="celula"><%=trim(rs("descricao_abreviada"))%></td>
									<td height="20" class="celula"><%=trim(rs("curso"))%></td>
									<td height="20" class="celula"><%=trim(rs("periodo"))%></td>
									<td height="20" class="celula"><%=trim(strSituacao)%></td>
									<td height="20" class="celula"><%=trim(strPublicar)%></td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="8" class="celula">Total Registros : <%=cont%></td>
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