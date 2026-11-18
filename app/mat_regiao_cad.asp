<%
	acao = "I"
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	if trim(intCodigo) <> "" and isnumeric(intCodigo) then
		sql = "SELECT Codigo, Descricao FROM MAT_REGIAO where Cod_grupo = " & Session("CodGrupo") & " and Codigo = " & clng(intCodigo)
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo	 	= rs("CODIGO")
			strDescricao	= rs("DESCRICAO")
			acao = "AE"
		end if
		rs.close
	end if
%>
<main id="js-page-content" role="main" class="page-content">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small><%=descricao_pagina%></small>
		</h1>
	</div>
	<form id="frm" name="frm" method="post" action="mat_regiao.asp">
	<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
	<input name="txtRegiao" type="hidden" id="txtRegiao" value="">
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2><%=pagina%></h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Descrição</label>
									<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" maxlength="100" value="<%=strDescricao%>">
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
							<button type="button" class="btn btn-outline-secondary" onClick="window.location='mat_regiao_sem_vinculo.asp'">Setor / unidade sem vínculo</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont = 0
	sql = "SELECT m.Codigo, m.Descricao,"
	sql = sql & " (select count(*) from MAT_regiao_setores where cod_regiao = m.codigo) as setor_vinculado,"
	sql = sql & " (select count(*) from MAT_regiao_empresa where cod_regiao = m.codigo) as unidade_vinculada"
	sql = sql & " FROM MAT_REGIAO m where m.Cod_grupo = " & Session("CodGrupo") & " Order by m.Descricao"
	rs.open sql, cnn
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Regiões cadastradas</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag">Para editar clique no nome da região. Use os botões para vincular setores e escolas.</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed"><tr>
									<th>Região</th>
									<th class="text-center">Setores vinculados</th>
									<th class="text-center">Escolas vinculadas</th>
									<th class="text-center">Vincular</th>
								</tr></thead>
								<tbody>
								<%while not rs.eof
									cont = cont + 1
									strRegiaoJs = replace(replace(trim(rs("Descricao") & ""), "\", ""), "'", "\'")%>
								<tr>
									<td style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("Codigo")%>')"><%=trim(rs("Descricao"))%></td>
									<td class="text-center"><%=rs("setor_vinculado")%></td>
									<td class="text-center"><%=rs("unidade_vinculada")%></td>
									<td class="text-center text-nowrap">
										<button type="button" class="btn btn-xs btn-outline-primary" onClick="return vincula('mat_regiao_setor.asp', '<%=rs("Codigo")%>', '<%=strRegiaoJs%>')">Setores</button>
										<button type="button" class="btn btn-xs btn-outline-primary" onClick="return vincula('mat_regiao_unidade.asp', '<%=rs("Codigo")%>', '<%=strRegiaoJs%>')">Escolas</button>
									</td>
								</tr>
								<%rs.movenext
								wend%>
								<tr><td colspan="4"><strong>Total de registros: <%=cont%></strong></td></tr>
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
	</form>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
