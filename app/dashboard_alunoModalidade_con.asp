<%

	strModalidade = request("strModalidade")
	intCodTipoEmpresa = request("cmbTipoEmpresa")
	intCodEmpresaGrupo = request("cmbEmpresaGrupo")
	strAnoLetivo  = request("cmbAnoLetivo")
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<input type="hidden" id="strModalidade" value="<%=strModalidade%>" />
<input type="hidden" id="intCodTipoEmpresa" value="<%=intCodTipoEmpresa%>" />
<input type="hidden" id="intCodEmpresaGrupo" value="<%=intCodEmpresaGrupo%>" />
<input type="hidden" id="strAnoLetivo" value="<%=strAnoLetivo%>" />

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

	<!--#include file="dashboard_inc_filtro.asp" -->

	<div class="row">
		<div class="col-xl-3 ">
			<div id="divMatriculados" class="panel" style="background-color: lightgreen;">
				<div class="panel-hdr">
					<h2>
						Matriculados <span class="fw-300"> - <i><%=strModalidade%></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde" id="total">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> alunos</span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-3">
			<div id="divEdInfantil" class="panel">
				<div class="panel-hdr">
					<h2>
						Transporte Escolar <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde" id="totatTransporteEscolar">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> alunos</span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-3">
			<div id="divEF" class="panel">
				<div class="panel-hdr">
					<h2>
						Atendimento Especial <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde"  id="totatAtendimentoEspecial">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> alunos</span>
					</div>
				</div>
			</div>
		</div>	

		<div class="col-xl-3">
			<div id="divEJA" class="panel">
				<div class="panel-hdr">
					<h2>
						Bolsa Família <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span class="qtde" id="totatBolsaFamilia">0</span>
						<span style="qtde-descricao"><i class="fal fa-user-circle" aria-hidden="true"></i> alunos</span>
					</div>
				</div>
			</div>
		</div>						
	</div>	

	<div class="row">
		<div class="col-xl-10">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Quantidade de alunos por série <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="width:100%; height:300px; position:relative;">
						<!--div class="panel-tag">Quantidade de alunos por modalidade</div-->
						<canvas id="alunosPorSerie" style="width:100%; height: 100%"></canvas>
					</div>
				</div>

			</div>
		</div>
		<div class="col-xl-2">
			<div class="row">
				<div class="col-xl-12">
					<div id="panel-1" class="panel">
						<div class="panel-hdr">
							<h2>
								Alunos por Turno <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<div class="panel-content" style="width:100%; height:300px; position:relative;">
								<canvas id="alunosPorTurno" style="width:100%; height: 100%"></canvas>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>

	<div class="row" id="divAlunosNominal">
		<div class="col-xl-12">

			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2 style="display: flex; gap: 10px;">
						Alunos por Série 
						<div class="form-group" style="flex: auto">
						<select name="cmbSerie" id="cmbSerie" onChange="fetchAlunos('<%=strModalidade%>',this.value)" class="form-control" style="width: 150px;">
							<option value="0">Selecione...</option>
							<%
							IF strModalidade <>"" THEN
								SQL = "SELECT DISTINCT P.DESCRICAO FROM SCA_PERIODO P"
								SQL=SQL & " INNER JOIN SCA_CURSO C ON P.Cod_Curso = C.Cod_curso"
								SQL=SQL & " WHERE C.Descricao = '" & strModalidade & "'"
								SQL=SQL & " AND P.situacao = 'A'"
								SQL=SQL & " AND C.Situacao='A'"
								rs.open SQL, cnn
								if rs.eof = false then
									while not rs.eof
										response.write "<option value='" & rs("DESCRICAO") & "'>" & rs("DESCRICAO") & "</option>"
										rs.movenext
									wend
								end if
							END IF
							%>
						</select>
						</div>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show" style="padding: 12px;">

					<table id="alunos" style="width:100%;">
						<thead>
							<tr style="height: 30px;">
								<th style="width:100px;font-weight: bold;">Matricula</th>
								<th style="font-weight: bold;">Nome</th>
								<th style="font-weight: bold;">Data Nascimento</th>
								<th style="font-weight: bold;">Série</th>
								<th style="font-weight: bold;">Turma</th>
								<th style='text-align: end;font-weight: bold;'>Ficha</th>
							</tr>
						</thead>
						<tbody>
						</tbody>																							
					</table>

				</div>
			</div>		

		</div>
	</div>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>