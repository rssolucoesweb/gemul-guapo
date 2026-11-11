<%
	'PERFIL COORDENADORES - 17
	'PERFIL PROFESSORES   - 11
	'PERFIL ADMINISTRADOR - 2	
	strCodPefilAcesso = "17,2,11"
%>
<!--#include file="includes/inc_VerificaAcessoPerfilAdmProfessor.asp"-->
<%
	acao = "I"
	strBotaoVoltaTelaAnterior = "N"
	strExecutarSubmitCurso = "S"
	strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre = session("strSemestre")
	strConsultar			= Trim(Request("strConsultar"))
	intCodTurnoRH			= Trim(Request("cmbTurnoRH"))
	if intCodTurnoRH = "" then intCodTurnoRH = "0"

	if strAcessoPerfil <> "PROFESSOR" then
		intCodProfessor	        = Trim(Request("cmbProfessor"))
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
			<div  align="right">
				<ul class="list-table m-0">
					<li class="pl-3"><a href="#" onClick="abreHelp('<%=pagina_tutorial%>')" class="text-secondary fw-700"><font color="blue">Tutorial</font></a></li>
					<li class="pl-1 fs-xl"><a href="#"  onClick="abreHelp('<%=pagina_tutorial%>')" class="text-secondary"><font color="blue"><i class="fal fa-question-circle" aria-hidden="true"></i></font></a></li>
				</ul>
			</div>
		</h1>
	</div>
	<form id="frm" name="frm" method="post">
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
						
							<input name="txtCodCurso" 		type="hidden" id="txtCodCurso">
							<input name="txtCodTurno" 		type="hidden" id="txtCodTurno">
							<input name="txtTurno" 			type="hidden" id="txtTurno">
							<input name="txtSemestre" 		type="hidden" id="txtSemestre" value="<%=intSemestre%>">
							<input name="txtCodProfessor" 	type="hidden" id="txtCodProfessor">
							<input name="txtProfessor" 		type="hidden" id="txtProfessor">
							<input name="strConsultar" 		type="hidden" id="strConsultar" value="S">
							
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=strAnoLetivo%>"  maxlength="4">
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Turno</label>
										<%
										filtroTurno="S"
										strExecutarSubmitTurnoRH="S"
										%>
										<!--#include file="includes/inc_cmbTurnoRH.asp" -->
									</div>
								</div>	
								
							</div>
							<div class="row">
								
								
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Professor</label>
										<!--#include file="includes/inc_cmdProfessorHorarioAulaTurno.asp" -->
									</div>
								</div>	
							
							</div>	
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_consulta_novo.asp"-->
							</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	
	IF strConsultar = "S" then
		cont =0
		
		sql = " SELECT distinct ha.anoLetivo, c.nome as professor, HA.Cod_Colaborador as codProfessor, tu.cod_turno, tu.desc_turno as turno "
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO "
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador "
		sql = sql & " INNER JOIN SRH_TURNO TU ON TU.Cod_Turno = H.CodTurno "
		sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo 
		sql = sql & " AND tu.Cod_Turno = " & intCodTurnoRH
		if intCodProfessor <> "0" then
			sql = sql & " AND HA.Cod_Colaborador = " & intCodProfessor 
		end if
		sql = sql & " order by ANOLETIVO, professor, turno"
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
										<th><strong>Ano Letivo</strong></th>
										<th><strong>Professor</strong></th>
										<th><strong>Turno</strong></th>
									  </tr>
									</thead>
									<tbody>
										<%
										while not rs.eof
											%>
											<tr height="20" style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("cod_turno")%>','<%=rs("turno")%>','<%=rs("codProfessor")%>','<%=rs("professor")%>')">
												<td><%=rs("anoLetivo")%></td>
												<td><%=rs("professor")%></td>
												<td><%=rs("turno")%></td>
											</tr>
											<%
											rs.movenext
										wend
										%>
										<tr>
											<td height="21" colspan="3" class="celula">Total Registros : <%=cont%></td>
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
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>