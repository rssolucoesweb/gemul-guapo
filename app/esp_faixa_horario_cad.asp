<%
	acao = "I"

	strExecutarSubmitSemestre = "S"
	intSemestre 			= request("cmbSemestre")
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	intCodHorario 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
    intCodTurno	        = Trim(Request.Form("cmbTurno"))
	intCodSequenciaAula	= Trim(Request.Form("cmbSequenciaAula"))
	intCodTempoAula		= Trim(Request.Form("cmbTempoAula"))
		
	if trim(intCodHorario) <> "" then
	
		sql = "SELECT codigo, horario, ano_letivo, Cod_Turno, Sequencia, Tempo, aulas, minutos"
		sql = sql & " FROM esp_faixa_horario"
		sql = sql & " where codigo = " & intCodHorario
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodHorario	 		= rs("codigo")
			strAnoLetivo	 		= rs("ano_letivo")
			strDescricao			= rs("horario")
			intCodTurno				= trim(rs("Cod_Turno"))
			strNumeroAula			= rs("aulas")
			strHoraRelogio			= rs("minutos")
			intCodSequenciaAula		= rs("Sequencia")
			intCodTempoAula			= rs("Tempo")
			aulas					= rs("aulas")
			minutos					= rs("minutos")
			
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
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodHorario%>">
							
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" onBlur="submit()"  value="<%=strAnoLetivo%>" maxlength="4" onKeyPress="return formataCampo(this,2,4)">
									</div>
								</div>	
								<div class="col-sm-9">	
									<div class="form-group">
										<label class="form-label">Horário</label>
										<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>" maxlength="40" >
									</div>
								</div>	
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Turno</label>
										<!--#include file="includes/inc_cmdTurno.asp" -->
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Sequencia</label>
										<!--#include file="includes/inc_cmdSequenciaAula.asp"-->
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Tempo</label>
										<select name="cmbTempoAula" id="cmbTempoAula" class="form-control">
										  <option value="0">Selecione...</option>
										  <option <%if intCodTempoAula="1" then response.Write("selected") %> value="1">1&deg; tempo (Antes do intervalo)</option>
										  <option <%if intCodTempoAula="2" then response.Write("selected") %> value="2">2&deg; tempo (Depois do intervalo)</option>
										</select>
									</div>
								</div>									
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Aulas</label>
										<input type="text" id="aulas" name="aulas" class="form-control" value="<%=aulas%>" maxlength="5" onKeyPress="return formataCampo(this,2,5)">
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Total Minutos</label>
										<input type="text" id="minutos" name="minutos" class="form-control" value="<%=minutos%>" maxlength="5" onKeyPress="return formataCampo(this,2,5)">
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group">
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
	
	sql = "SELECT H.*, T.DESC_TURNO "
	sql = sql & " FROM ESP_faixa_HORARIO H"
	sql = sql & " left join SCA_TURNO T on T.COD_TURNO = H.Cod_Turno"
	sql = sql & " Where H.ANO_letivo = " & strAnoLetivo		
	sql = sql & " Order by ANO_letivo, T.DESC_TURNO, horario"
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
									<th><strong>Ano letivo</strong></th>
									<th><strong>Sequência</strong></th>
									<th><strong>Hor&aacute;rio</strong></th>
									<th><strong>Turno</strong></th>
									<th><strong>Aulas</strong></th>
									<th><strong>Minutos</strong></th>
									<th><strong>Tempo</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							  <%
							while not rs.eof
								cont = cont + 1	
					
								strCorLinha = ""
								
								if ucase(trim(rs("DESC_TURNO"))) = "MATUTINO" then
									strCorLinha = "bgcolor='#FFFFCC'"
								end if
								
								if ucase(trim(rs("DESC_TURNO"))) = "VESPERTINO" then
									strCorLinha = "bgcolor='#CAFEB4'"
								end if
								
								if ucase(trim(rs("DESC_TURNO"))) = "NOTURNO" then
									strCorLinha = "bgcolor='#D8D8D8'"
								end if
								
								if ucase(trim(rs("DESC_TURNO"))) = "INTEGRAL" then
									strCorLinha = "bgcolor='#C2CAFC'"
								end if
								%>
								  <tr <%=strCorLinha%> style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("ano_letivo")%></td>
									<td height="20" class="celula"><%=trim(rs("Sequencia"))%></td>
									<td height="20" class="celula"><%=trim(rs("horario"))%></td>
									<td height="20" class="celula"><%=trim(rs("DESC_TURNO"))%></td>
									<td height="20" class="celula"><%=trim(rs("aulas"))%></td>
									<td height="20" class="celula"><%=trim(rs("minutos"))%></td>
									<td height="20" class="celula"><%=trim(rs("Tempo"))%></td>
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
	else
		%>
		<div class="row">
			<div class="col-xl-12">
				ATEN&Ccedil;&Atilde;O: Não existe Faixa de Hor&aacute;rio para ano informado, deseja copiar dados do ano anterior 
				<button onClick="salvar('D')" type="button" class="btn btn-outline-info">Cópiar Faixa</button>
			</div>
		</div> 	  
		<%
	end if
	rs.close
	  
	%>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>