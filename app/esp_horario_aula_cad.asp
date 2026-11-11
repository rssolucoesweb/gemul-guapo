<style>
	body {
		font-family: Arial, sans-serif;
	}

	table {
		width: 100%;
		border-collapse: collapse;
		text-align: center;
	}

	th, td {
		border: 1px solid #ccc;
		padding: 15px;
	}

	th {
		background-color: #f0f0f0;
	}

	.horario {
		width: 100px;
		background-color: #fafafa;
	}
	
	.horario_turno {
		width: 100px;
		padding: 10px !important;
		background-color: #fafafa;
	}
</style>


<%
	acao = "I"
	strExecutarSubmitTurma = "S"
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
	intCodTurma			= Trim(Request("cmbTurma"))
	if intCodTurma = "" then intCodTurma = "0"
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
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Turma</label>
										<!--#include file="includes/inc_cmbTurmaEsporte.asp" -->
									</div>
								</div>	
							</div>
							<br>							
							<div class="row">
								<div class="col-sm-12">
									
										<label class="form-label">Calendário Semanal</label>
										<table>
											<thead>
												<tr>
													<th class="horario">Horário</th>
													<th>Segunda</th>
													<th>Terça</th>
													<th>Quarta</th>
													<th>Quinta</th>
													<th>Sexta</th>
													<th>Sábado</th>
													<th>Domingo</th>
												</tr>
											</thead>
											<tbody>
												<%
												sql = "select h.codigo, h.horario, tu.desc_turno as turno "
												sql = sql & " from esp_faixa_horario h"
												sql = sql & " inner join sca_turno tu on tu.cod_turno = h.cod_turno"
												sql = sql & " where h.ano_letivo = " & strAnoLetivo
												'sql = sql & " and h.cod_turno = " & intCodTurno
												sql = sql & " order by h.sequencia"
												rs.open sql, cnn
												if rs.eof = false then
													while not rs.eof
														if turno<>rs("turno") then
															%>
															<tr>
																<td colspan="8" class="horario_turno"><%=rs("turno")%></td>
															</tr>
															<%
														end if
														
														if intCodTurma<>"0" then
															strExisteHorarioSegunda = ""
															strExisteHorarioTerca	 = ""
															strExisteHorarioQuarta	 = ""
															strExisteHorarioQuinta	 = ""
															strExisteHorarioSexta	 = ""
															strExisteHorarioSabado	 = ""
															strExisteHorarioDomingo = ""
															
															sql = "select dia_semana "
															sql = sql & " from ESP_HORARIO_AULA"
															sql = sql & " where cod_turma = " & intCodTurma
															sql = sql & " and ano_letivo = " & strAnoLetivo
															sql = sql & " and cod_faixa_horario = " & rs("codigo")
															rsAux.open sql, cnn
															if not rsAux.eof then
																while not rsAux.eof
																	acao = "AE"
																	if rsAux("dia_semana") = "1" then strExisteHorarioDomingo 	= " checked "
																	if rsAux("dia_semana") = "2" then strExisteHorarioSegunda 	= " checked "
																	if rsAux("dia_semana") = "3" then strExisteHorarioTerca 	= " checked "
																	if rsAux("dia_semana") = "4" then strExisteHorarioQuarta 	= " checked "
																	if rsAux("dia_semana") = "5" then strExisteHorarioQuinta 	= " checked "
																	if rsAux("dia_semana") = "6" then strExisteHorarioSexta 	= " checked "
																	if rsAux("dia_semana") = "7" then strExisteHorarioSabado 	= " checked "
																
																	rsAux.movenext
																wend
															end if
															rsAux.close
														end if
														
														%>
														<tr>
															<td class="horario"><%=rs("horario")%></td>
															<td><input name="horario_2_<%=rs("codigo")%>" id="horario_2_<%=rs("codigo")%>" value="<%=rs("codigo")%>" type="checkbox" <%=strExisteHorarioSegunda%> /></td>
															<td><input name="horario_3_<%=rs("codigo")%>" id="horario_3_<%=rs("codigo")%>" value="<%=rs("codigo")%>" type="checkbox" <%=strExisteHorarioTerca	%> /></td>
															<td><input name="horario_4_<%=rs("codigo")%>" id="horario_4_<%=rs("codigo")%>" value="<%=rs("codigo")%>" type="checkbox" <%=strExisteHorarioQuarta	%> /></td>
															<td><input name="horario_5_<%=rs("codigo")%>" id="horario_5_<%=rs("codigo")%>" value="<%=rs("codigo")%>" type="checkbox" <%=strExisteHorarioQuinta	%> /></td>
															<td><input name="horario_6_<%=rs("codigo")%>" id="horario_6_<%=rs("codigo")%>" value="<%=rs("codigo")%>" type="checkbox" <%=strExisteHorarioSexta	%> /></td>
															<td><input name="horario_7_<%=rs("codigo")%>" id="horario_7_<%=rs("codigo")%>" value="<%=rs("codigo")%>" type="checkbox" <%=strExisteHorarioSabado	%> /></td>
															<td><input name="horario_1_<%=rs("codigo")%>" id="horario_1_<%=rs("codigo")%>" value="<%=rs("codigo")%>" type="checkbox" <%=strExisteHorarioDomingo%> /></td>
														</tr>
														<%
														turno = rs("turno")
														rs.movenext
													wend
												end if
												rs.close
												%>
												
												<!-- Adicione mais linhas conforme necessário -->
											</tbody>
										</table>
									
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
	
	sql = "SELECT T.COD_TURMA, T.NOME as turma, IIF (SEXO='M','MASCULINO','FEMININO') as sexo,"
	sql = sql & " CASE"
	sql = sql & " 	WHEN HA.DIA_SEMANA=1 THEN 'DOMINGO'"
	sql = sql & " 	WHEN HA.DIA_SEMANA=2 THEN 'SEGUNDA'"
	sql = sql & " 	WHEN HA.DIA_SEMANA=3 THEN 'TERÇA'"
	sql = sql & " 	WHEN HA.DIA_SEMANA=4 THEN 'QUARTA'"
	sql = sql & " 	WHEN HA.DIA_SEMANA=5 THEN 'QUINTA'"
	sql = sql & " 	WHEN HA.DIA_SEMANA=6 THEN 'SEXTA'"
	sql = sql & " 	WHEN HA.DIA_SEMANA=7 THEN 'SÁBADO'"
	sql = sql & " 	END AS DIASEMANA,"
	sql = sql & " 	F.HORARIO,"
	sql = sql & " 	TU.DESC_TURNO AS TURNO,"
	sql = sql & " 	f.sequencia, m.descricao as modalidade,c.descricao as categoria "
	sql = sql & "   FROM ESP_HORARIO_AULA HA"
	sql = sql & "   INNER JOIN ESP_FAIXA_HORARIO F ON F.codigo = HA.cod_faixa_horario"
	sql = sql & "   INNER JOIN SCA_TURNO TU ON F.cod_turno = TU.cod_turno"
	sql = sql & "   INNER JOIN ESP_TURMA T ON T.COD_TURMA = HA.COD_TURMA"
	sql = sql & "   INNER JOIN ESP_MODALIDADE M ON M.COD_MODALIDADE = T.COD_MODALIDADE"
	sql = sql & "   INNER JOIN ESP_CATEGORIA C ON C.COD_CATEGORIA = T.COD_CATEGORIA"
	sql = sql & "   where ha.ano_letivo = " & strAnoLetivo		
	if intCodTurma<>"0" then
		sql = sql & "   and ha.cod_turma = " & intCodTurma		
	end if
	sql = sql & "   ORDER BY M.DESCRICAO, C.DESCRICAO, T.NOME	"
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
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Modalidade</strong></th>
									<th><strong>Categoria</strong></th>
									<th><strong>Sexo</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Horário</strong></th>
									<th><strong>Dia Semana</strong></th>
									<th><strong>Turno</strong></th>
									<th><strong>Sequencia</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							  <%
							while not rs.eof
								cont = cont + 1	
					
								strCorLinha = ""
								
								if ucase(trim(rs("TURNO"))) = "MATUTINO" then
									strCorLinha = "bgcolor='#FFFFCC'"
								end if
								
								if ucase(trim(rs("TURNO"))) = "VESPERTINO" then
									strCorLinha = "bgcolor='#CAFEB4'"
								end if
								
								if ucase(trim(rs("TURNO"))) = "NOTURNO" then
									strCorLinha = "bgcolor='#D8D8D8'"
								end if
								
								if ucase(trim(rs("TURNO"))) = "INTEGRAL" then
									strCorLinha = "bgcolor='#C2CAFC'"
								end if
								%>
								  <tr <%=strCorLinha%> >
									<td class="celula"><%=rs("modalidade")%></td>
									<td height="20" class="celula"><%=trim(rs("categoria"))%></td>
									<td height="20" class="celula"><%=trim(rs("sexo"))%></td>
									<td height="20" class="celula"><%=trim(rs("turma"))%></td>
									<td height="20" class="celula"><%=trim(rs("horario"))%></td>
									<td height="20" class="celula"><%=trim(rs("diasemana"))%></td>
									<td height="20" class="celula"><%=trim(rs("turno"))%></td>
									<td height="20" class="celula"><%=trim(rs("Sequencia"))%></td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td align="left" height="21" colspan="8" class="celula">Total Registros : <%=cont%></td>
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