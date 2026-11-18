<%
	'Guapó: junta as telas antigas setorSemVinculo_con e unidadeSemVinculo_con
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
			<i class='subheader-icon fal fa-unlink'></i> <%=pagina%>
			<small><%=descricao_pagina%></small>
		</h1>
	</div>
	<%
	cont = 0
	sql = "select descricao from mat_setores where cod_grupo = " & Session("CodGrupo")
	sql = sql & " and codigo not in (select cod_setores from MAT_regiao_setores) order by 1"
	rs.open sql, cnn
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>Setores sem vínculo</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if rs.eof then%>
						<div class="alert alert-secondary m-0">Nenhum registro sem vínculo.</div>
						<%else%>
						<table class="table table-bordered table-hover table-sm m-0">
							<tbody>
							<%while not rs.eof
								cont = cont + 1%>
							<tr><td><%=trim(rs("descricao"))%></td></tr>
							<%rs.movenext
							wend%>
							<tr><td><strong>Total de registros: <%=cont%></strong></td></tr>
							</tbody>
						</table>
						<%end if%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%rs.close%>
	<%
	cont = 0
	sql = "select razaosocial as descricao from seg_empresa where CodTipoEmpresa <> 3 and BLOQUEIO = 'N' and cod_grupo = " & Session("CodGrupo")
	sql = sql & " and codigo not in (select cod_empresa from MAT_regiao_empresa) order by 1"
	rs.open sql, cnn
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Unidades sem vínculo</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if rs.eof then%>
						<div class="alert alert-secondary m-0">Nenhum registro sem vínculo.</div>
						<%else%>
						<table class="table table-bordered table-hover table-sm m-0">
							<tbody>
							<%while not rs.eof
								cont = cont + 1%>
							<tr><td><%=trim(rs("descricao"))%></td></tr>
							<%rs.movenext
							wend%>
							<tr><td><strong>Total de registros: <%=cont%></strong></td></tr>
							</tbody>
						</table>
						<%end if%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%rs.close%>
	<button type="button" class="btn btn-outline-info" onClick="window.location='mat_regiao.asp'"><i class="fal fa-arrow-left mr-1"></i> Voltar</button>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
