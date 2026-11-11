<%
	acao = "I"

	strExecutarSubmitCurso 	= "S"

	intCodPeriodo			= Trim(Request.Form("txtCodigo"))
	intCodCurso				= Trim(Request("cmbCurso"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSequencia 			= Trim(Request.Form("txtSequencia"))
	strTipo		 			= Trim(Request.Form("cmbTipo"))
	strMatricula			= Trim(Request.Form("cmbMatricula"))
		
	if trim(intCodPeriodo) <> "" then
	
		sql = "SELECT Cod_Periodo, Cod_Curso, Descricao, Sequencia, Tipo, Matricula, idade_limite"
		sql = sql & " FROM SCA_PERIODO"
		sql = sql & " where Cod_Periodo = " & intCodPeriodo
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodPeriodo	 	= rs("Cod_Periodo")
			intCodCurso			= rs("Cod_Curso")
			strDescricao		= rs("Descricao")
			strSequencia		= rs("Sequencia")
			strTipo				= rs("Tipo")
			strMatricula		= rs("Matricula")
			strIdadeLimite		= rs("idade_limite")
			
			acao = "AE"

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	if trim(session("NivelPermissao")) = "A" then
	else
		if acao = "AE" then
			acao = "E" 
		end if
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
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodPeriodo%>">
							
							<div class="form-group">
								<label class="form-label">Curso</label>
								<!--#include file="includes/inc_cmdCurso.asp" -->
							</div>
							
							<div class="form-group">
								<label class="form-label">Sequencia</label>
								<input name="txtSequencia" type="text" class="form-control" id="txtSequencia" size="2" maxlength="2" value="<%=strSequencia%>"  onKeyPress="return formataCampo(this, 2, 2)" >
							</div>
							
							<div class="form-group">
								<label class="form-label">Descrição</label>
								<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="50" maxlength="50" value="<%=strDescricao%>">
							</div>
							
							<div class="form-group">
								<label class="form-label">Idade Limite</label>
								<input name="txtIdadeLimite" type="text" class="form-control" id="txtIdadeLimite" size="2" maxlength="2" value="<%=strIdadeLimite%>"  onKeyPress="return formataCampo(this, 2, 2)" >
							</div>
							
							<div class="form-group">
								<label class="form-label">Tipo</label>
									<select name="cmbTipo" id="cmbTipo" class="form-control">
										<option <%if strTipo = "D" then response.Write("selected")%> value="D">Disciplinar</option>
										<option <%if strTipo = "I" then response.Write("selected")%> value="I">Interdisciplinar</option>
									</select>
							</div>
							
							<div class="form-group">
								<label class="form-label">Aparecer na Matrícula</label>
									<select name="cmbMatricula" id="cmbMatricula" class="form-control">
										<option <%if strMatricula = "N" then response.Write("selected")%> value="N">Não</option>
										<option <%if strMatricula = "S" then response.Write("selected")%> value="S">Sim</option>
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

	<%
	cont =0
	if intCodCurso = "" then intCodCurso = 0
	if intCodCurso <> "0" then
		sql = " SELECT SCA_CURSO.Descricao as descCurso, SCA_PERIODO.Descricao, SCA_PERIODO.idade_limite , SCA_PERIODO.Cod_Periodo, SCA_PERIODO.Sequencia, SCA_PERIODO.tipo, SCA_PERIODO.Matricula"
		sql = sql & " FROM SCA_CURSO INNER JOIN SCA_PERIODO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso "
		sql = sql & " where 1=1"
		if intCodCurso <> "0" then
			sql = sql & " and SCA_PERIODO.Cod_Curso = " & intCodCurso
		end if
		sql = sql & " ORDER BY 	SCA_PERIODO.Sequencia, SCA_CURSO.Descricao, SCA_PERIODO.Descricao"
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
									<th><strong>C&oacute;digo</strong></th>
									<th><strong>Curso</strong></th>
									<th><strong>Sequencia</strong></th>
									<th><strong>Descri&ccedil;&atilde;o</strong></th>
									<th><strong>Idade limite</strong></th>
									<th><strong>Tipo</strong></th>
									<th><strong>Aparece na Matricula</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									while not rs.eof
										cont = cont + 1	
										strDescTipo = ""
										if rs("tipo") = "D" then strDescTipo = "Disciplinar"
										if rs("tipo") = "I" then strDescTipo = "Interdisciplinar"
									
										if rs("Matricula") = "S" then strMatricula = "Sim"
										if rs("Matricula") = "N" then strMatricula = "Não"
										
										%>
										  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("Cod_Periodo")%>')">
											<td class="celula"><%=rs("Cod_Periodo")%>&nbsp;</td>
											<td height="20" class="celula"><%=trim(rs("descCurso"))%></td>
											<td height="20" class="celula"><%=trim(rs("sequencia"))%></td>
											<td class="celula"><%=trim(rs("Descricao"))%></td>
											<td height="20" class="celula"><%=trim(rs("idade_limite"))%></td>
											<td class="celula"><%=trim(strDescTipo)%>&nbsp;</td>
											<td class="celula" align="center"><%=trim(strMatricula)%>&nbsp;</td>
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
	end if
	  
	%>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>