<%
	acao = "I"

	strTemAcessoAdministrador = ""
	SQL = "SELECT ACES_PERF_CODG" 'SCA(ADMINISTRADOR)
	SQL = SQL & " FROM SEG_ACESSOS_USUARIO"
	SQL = SQL & " WHERE ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
	SQL = SQL & " AND ACES_PERF_CODG in (2)"
	rs.open sql, cnn
	if not rs.EOF then	
		strTemAcessoAdministrador = "S"
	end if
	rs.close

	intCodDisciplina	= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strDescHistorico	= Trim(Request.Form("txtDescHistorico"))
		
	if trim(intCodDisciplina) <> "" then
	
		sql = "SELECT COD_Disciplina, DESC_Disciplina, Desc_Abreviada, Desc_historico, situacao, uso_historico"
		sql = sql & " FROM SCA_DISCIPLINA"
		sql = sql & " Where COD_Disciplina = " & intCodDisciplina
		
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("COD_Disciplina")
			strDescricao			= rs("DESC_Disciplina")
			strDescAbreviada		= rs("Desc_Abreviada")
			strDescHistorico		= rs("Desc_Historico")
			strSituacao				= rs("situacao")
			strUsoHistorico			= rs("uso_historico")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			
			acao = "E"
			if Session("UsuarioMaster") = "S" or strTemAcessoAdministrador = "S" then
				acao = "AE"
			end if
			
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
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
								<label class="form-label">Descrição (Uso Interno)</label>
								<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>">
							</div>
							
							<div class="form-group">
								<label class="form-label">Descri&ccedil;&atilde;o Abreviada (Hor&aacute;rio)</label>
								<input name="txtDescAbreviada" type="text" class="form-control" id="txtDescAbreviada" size="20" maxlength="20" value="<%=strDescAbreviada%>">
							</div>
							
							<div class="form-group">
								<label class="form-label">Descri&ccedil;&atilde;o (Hist&oacute;rico) </label>
								<input name="txtDescHistorico" type="text" class="form-control" id="txtDescHistorico" size="100" maxlength="120" value="<%=strDescHistorico%>">
							</div>
							<div class="form-group">
								<label class="form-label">Situação</label>
								<!--#include file="includes/inc_cmbSituacao.asp"-->
							</div>
							
							<div class="form-group">
								<label class="form-label">Somente no Histórico Escolar</label>
								<select name="cmbUsoHistorico" id="cmbUsoHistorico" class="form-control">
									<option value="0">Selecione...</option>
									<option <%if strUsoHistorico = "S" then response.write "selected"%> value="S">Sim</option>
									<option <%if strUsoHistorico = "N" then response.write "selected"%> value="N">Não</option>
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

	sql = "SELECT COD_Disciplina, DESC_Disciplina, Desc_Abreviada, Desc_Historico, situacao, uso_historico"
	sql = sql & " FROM SCA_DISCIPLINA"
	sql = sql & " Order by situacao, uso_historico, DESC_Disciplina"
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
									<th><strong>Descri&ccedil;&atilde;o (Uso Interno)</strong></th>
									<th><strong>Descri&ccedil;&atilde;o (Hor&aacute;rio) </strong></th>
									<th><strong>Descri&ccedil;&atilde;o (Hist&oacute;rico) </strong></th>
									<th><strong>Situação</strong></th>
									<th><strong>Somente Histórico</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								situacao = ""
								if trim(rs("situacao")) = "A" then situacao = "Ativo"
								if trim(rs("situacao")) = "I" then situacao = "Inativo"
								uso_historico = ""
								if trim(rs("uso_historico")) = "S" then uso_historico = "Sim"
								if trim(rs("uso_historico")) = "N" then uso_historico = "Não"
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("COD_Disciplina")%>')">
									<td class="celula"><%=rs("COD_Disciplina")%></td>
									<td height="20" class="celula"><%=trim(rs("DESC_Disciplina"))%></td>
									<td height="20" class="celula"><%=trim(rs("Desc_Abreviada"))%></td>
									<td height="20" class="celula"><%=trim(rs("Desc_Historico"))%></td>
									<td height="20" class="celula"><%=trim(situacao)%></td>
									<td height="20" class="celula"><%=trim(uso_historico)%></td>
									
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