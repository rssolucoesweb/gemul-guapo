<%
	acao = "I"
	parecer_integral_sim = ""
	parecer_integral_nao = ""
	travar_regiao_sim = ""
	travar_regiao_nao = ""
	ano_letivo = ""
	sql = "SELECT *"
	sql = sql & " FROM MAT_configura_transferencia"
	rs.open sql, cnn
	
	if rs.eof = false then
		ano_letivo = rs("ano_letivo")
		parecer_integral = rs("parecer_integral")
		if parecer_integral = "S" then parecer_integral_sim = "checked"
		if parecer_integral = "N" then parecer_integral_nao = "checked"

		travar_regiao = rs("travar_regiao")
		if travar_regiao = "S" then travar_regiao_sim = "checked"
		if travar_regiao = "N" then travar_regiao_nao = "checked"
		
		acao = "A"
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	rs.close
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
			<i class='subheader-icon fal fa-cog'></i> <%=pagina%>
			<small><%=descricao_pagina%></small>
		</h1>
	</div>
	<form id="frm" name="frm" method="post">
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>Configurar transferência</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row">
							<div class="col-sm-4">
								<label class="form-label">Parecer turno integral</label>
								<div class="frame-wrap">
									<div class="custom-control custom-radio custom-control-inline"><input type="radio" class="custom-control-input" id="pi_s" name="parecer_integral" value="S" <%=parecer_integral_sim%>><label class="custom-control-label" for="pi_s">Sim</label></div>
									<div class="custom-control custom-radio custom-control-inline"><input type="radio" class="custom-control-input" id="pi_n" name="parecer_integral" value="N" <%=parecer_integral_nao%>><label class="custom-control-label" for="pi_n">Não</label></div>
								</div>
							</div>
							<div class="col-sm-4">
								<label class="form-label">Travar por região</label>
								<div class="frame-wrap">
									<div class="custom-control custom-radio custom-control-inline"><input type="radio" class="custom-control-input" id="tr_s" name="travar_regiao" value="S" <%=travar_regiao_sim%>><label class="custom-control-label" for="tr_s">Sim</label></div>
									<div class="custom-control custom-radio custom-control-inline"><input type="radio" class="custom-control-input" id="tr_n" name="travar_regiao" value="N" <%=travar_regiao_nao%>><label class="custom-control-label" for="tr_n">Não</label></div>
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano letivo</label>
									<input name="ano_letivo" type="text" class="form-control" id="ano_letivo" maxlength="4" value="<%=ano_letivo%>" onKeyPress="return formataCampo(this, 2, 4)">
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	sql = " SELECT * FROM MAT_configura_transferencia_log ORDER BY codigo_log DESC "
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Histórico de alterações</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="table-responsive-lg">
							<table class="table table-bordered table-sm m-0">
								<thead class="thead-themed"><tr><th>Parecer integral</th><th>Travar região</th><th>Alterado por</th></tr></thead>
								<tbody>
								<%WHILE NOT RS.EOF%>
								<tr><td><%=RS("parecer_integral")%></td><td><%=RS("travar_regiao")%></td><td><%=RS("usuario_log")%> <%=RS("data_log")%></td></tr>
								<%RS.MOVENEXT
								WEND%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	END IF
	RS.CLOSE
	%>
	</form>
</main>
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
