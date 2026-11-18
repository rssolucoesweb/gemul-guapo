<%

	sql = "SELECT *"
	sql = sql & " FROM MAT_periodo_curso"
	rs.open sql, cnn
	
	if rs.eof = false then
		while not rs.eof
			if rs("codigo") = "1"  then dt_inicial_I = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "2"  then dt_inicial_II = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "3"  then dt_inicial_III = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "9"  then dt_inicial_IV = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "10" then dt_inicial_V = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "12" then dt_inicial_ef = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "13" then dt_inicial_regra_especial = formataDataAP(rs("dt_inicial"))

			if rs("codigo") = "1"  then dt_final_I = formataDataAP(rs("dt_final"))
			if rs("codigo") = "2"  then dt_final_II = formataDataAP(rs("dt_final"))
			if rs("codigo") = "3"  then dt_final_III = formataDataAP(rs("dt_final"))
			if rs("codigo") = "9"  then dt_final_IV = formataDataAP(rs("dt_final"))
			if rs("codigo") = "10" then dt_final_V = formataDataAP(rs("dt_final"))
			if rs("codigo") = "12" then dt_final_ef = formataDataAP(rs("dt_final"))
			if rs("codigo") = "13" then dt_final_regra_especial = formataDataAP(rs("dt_final"))
			rs.movenext
		wend
		
	end if 
	rs.close
	
	sql = "SELECT *"
	sql = sql & " FROM MAT_periodo_valido_matricula"
	rs.open sql, cnn
	
	if rs.eof = false then
		while not rs.eof
			if rs("codigo") = "5"  then dt_inicial_ei_V = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "6"  then dt_inicial_ef_V = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "8"  then dt_inicial_minima_ei = formataDataAP(rs("dt_inicial"))

			if rs("codigo") = "5"  then dt_final_ei_V = formataDataAP(rs("dt_final"))
			if rs("codigo") = "6"  then dt_final_ef_V = formataDataAP(rs("dt_final"))
			if rs("codigo") = "12"  then dt_final_minima_ef = formataDataAP(rs("dt_final"))
			
			rs.movenext
		wend
		
	end if 
	rs.close
	
	sql = "SELECT periodo_dinamico"
	sql = sql & " FROM MAT_configuracoes where cod_grupo=" & session("codGrupo")
	rs.open sql, cnn
	
	if rs.eof = false then
		periodo_dinamico = rs("periodo_dinamico")
	end if 
	rs.close
	
		acao = "A"
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
	<form id="frm" name="frm" method="post">
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>Faixa etária para matrícula - Educação Infantil</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row d-none d-sm-flex"><div class="col-sm-4"></div><div class="col-sm-3"><strong>Data inicial</strong></div><div class="col-sm-3"><strong>Data final</strong></div></div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Agrupamento I</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_I" type="text" class="form-control" id="dt_inicial_I" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_I%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_I" type="text" class="form-control" id="dt_final_I" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_I%>"></div></div>
						</div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Agrupamento II</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_II" type="text" class="form-control" id="dt_inicial_II" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_II%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_II" type="text" class="form-control" id="dt_final_II" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_II%>"></div></div>
						</div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Agrupamento III</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_III" type="text" class="form-control" id="dt_inicial_III" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_III%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_III" type="text" class="form-control" id="dt_final_III" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_III%>"></div></div>
						</div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Agrupamento IV</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_IV" type="text" class="form-control" id="dt_inicial_IV" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_IV%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_IV" type="text" class="form-control" id="dt_final_IV" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_IV%>"></div></div>
						</div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Agrupamento V</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_V" type="text" class="form-control" id="dt_inicial_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_V%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_V" type="text" class="form-control" id="dt_final_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_V%>"></div></div>
						</div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Dois agrupamentos (regra especial)</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_regra_especial" type="text" class="form-control" id="dt_inicial_regra_especial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_regra_especial%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_regra_especial" type="text" class="form-control" id="dt_final_regra_especial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_regra_especial%>"></div></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-2" class="panel">
				<div class="panel-hdr">
					<h2>Faixa etária para matrícula - Ensino Fundamental (1º ao 9º ano)</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row d-none d-sm-flex"><div class="col-sm-4"></div><div class="col-sm-3"><strong>Data inicial</strong></div><div class="col-sm-3"><strong>Data final</strong></div></div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Ensino Fundamental</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_ef" type="text" class="form-control" id="dt_inicial_ef" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_ef%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_ef" type="text" class="form-control" id="dt_final_ef" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_ef%>"></div></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-3" class="panel">
				<div class="panel-hdr">
					<h2>Validação do período</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row d-none d-sm-flex"><div class="col-sm-4"></div><div class="col-sm-3"><strong>Data inicial</strong></div><div class="col-sm-3"><strong>Data final</strong></div></div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Educação Infantil</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_ei_V" type="text" class="form-control" id="dt_inicial_ei_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_ei_V%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_ei_V" type="text" class="form-control" id="dt_final_ei_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_ei_V%>"></div></div>
						</div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Ensino Fundamental</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_ef_V" type="text" class="form-control" id="dt_inicial_ef_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_ef_V%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_ef_V" type="text" class="form-control" id="dt_final_ef_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_ef_V%>"></div></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-4" class="panel">
				<div class="panel-hdr">
					<h2>Validação de idade mínima</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row d-none d-sm-flex"><div class="col-sm-4"></div><div class="col-sm-3"><strong>Data inicial</strong></div><div class="col-sm-3"><strong>Data final</strong></div></div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Educação Infantil</label></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_inicial_minima_ei" type="text" class="form-control" id="dt_inicial_minima_ei" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_inicial_minima_ei%>"></div></div>
							<div class="col-sm-3"><div class="form-group"><span class="form-control-plaintext">&nbsp;</span></div></div>
						</div>
						<div class="row">
							<div class="col-sm-4"><label class="form-label mt-2">Ensino Fundamental</label></div>
							<div class="col-sm-3"><div class="form-group"><span class="form-control-plaintext">&nbsp;</span></div></div>
							<div class="col-sm-3"><div class="form-group"><input name="dt_final_minima_ef" type="text" class="form-control" id="dt_final_minima_ef" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=dt_final_minima_ef%>"></div></div>
						</div>
						<div class="custom-control custom-checkbox mt-3">
							<input type="checkbox" class="custom-control-input" value="S" name="periodo_dinamico" id="periodo_dinamico" onClick="periodo()" <%if periodo_dinamico="S" then response.write "checked"%>>
							<label class="custom-control-label" for="periodo_dinamico">Período dinâmico após a matrícula</label>
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
	sql = " SELECT * FROM MAT_periodo_curso_log where codigo_log <> 1 and year(data_log) = year(getdate()) ORDER BY codigo_log DESC "
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-5" class="panel">
				<div class="panel-hdr">
					<h2>Histórico de alterações - faixa etária</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="table-responsive-lg">
							<table class="table table-bordered table-sm m-0">
								<thead class="thead-themed"><tr><th>Curso/Série</th><th>Data inicial</th><th>Data final</th><th>Alterado por</th></tr></thead>
								<tbody>
								<%WHILE NOT RS.EOF%>
								<tr><td><%=RS("curso")%></td><td><%=formatadataap(RS("dt_inicial"))%></td><td><%=formatadataap(RS("dt_final"))%></td><td><%=RS("usuario_log")%> <%=RS("data_log")%></td></tr>
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
	<%
	sql = " SELECT * FROM MAT_periodo_valido_matricula_log where codigo_log <> 1 and codigo <> 7 and year(data_log) = year(getdate()) ORDER BY codigo_log DESC "
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-6" class="panel">
				<div class="panel-hdr">
					<h2>Histórico de alterações - validação do período</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="table-responsive-lg">
							<table class="table table-bordered table-sm m-0">
								<thead class="thead-themed"><tr><th>Curso/Série</th><th>Data inicial</th><th>Data final</th><th>Alterado por</th></tr></thead>
								<tbody>
								<%WHILE NOT RS.EOF%>
								<%
								dt_ini_log = RS("dt_inicial") : dt_fim_log = RS("dt_final")
								if rs("codigo") = "12" then dt_ini_log = ""
								if rs("codigo") = "8" then dt_fim_log = ""
								%>
								<tr><td><%=replace(RS("curso") & "","- 6ao9","- MÍNIMA")%></td><td><%=formatadataap(dt_ini_log)%></td><td><%=formatadataap(dt_fim_log)%></td><td><%=RS("usuario_log")%> <%=RS("data_log")%></td></tr>
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
	<%
	sql = " SELECT * FROM MAT_configuracoes_log where codigo_log <> 1 and year(data_log) = year(getdate()) ORDER BY codigo_log DESC "
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-7" class="panel">
				<div class="panel-hdr">
					<h2>Histórico de alterações - período dinâmico</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="table-responsive-lg">
							<table class="table table-bordered table-sm m-0">
								<thead class="thead-themed"><tr><th>Marcou</th><th>Alterado por</th></tr></thead>
								<tbody>
								<%WHILE NOT RS.EOF%>
								<tr><td><%if RS("periodo_dinamico") = "S" then%>SIM<%elseif RS("periodo_dinamico") = "N" then%>NÃO<%end if%></td><td><%=RS("usuario_log")%> <%=RS("data_log")%></td></tr>
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
