<%
	strTipo = request("tp")
	if strTipo = "C" then strDescTipo = "Conveniadas"
	if strTipo = "M" then strDescTipo = "Municipais"
	if strTipo = "CMEI" then strDescTipo = "CMEI"
	if strTipo = "EMEI" then strDescTipo = "EMEI"
	if strTipo = "ESCOLA" then strDescTipo = "ESCOLA"
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
	
	<!--#include file="dashboard_inc_voltar.asp" -->
	
	
	<div class="row">
		<div class="col-xl-4">
			<div class="row">
				<div class="col-xl-12">
					<div id="divMatriculados" id="panel-1" class="panel" style="background-color: lightgreen;">
						<div class="panel-hdr">
							<h2>
								ESCOLAS <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<a href="dashboard_escola_Cmei_EmeiCon.asp?tp=ESCOLA" style="text-decoration: none; display: block;">
							<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
								<span class="qtde" id="qtdeEMEI_CMEI">0</span>
								<span style="qtde-descricao"><i class="fal fa-school" aria-hidden="true"></i> Total de Escolas</span>
							</div>
							</a>
						</div>
					</div>
				</div>
			</div>					
		</div>		

		<div class="col-xl-4">
			<div class="row">
				<div class="col-xl-12">
					<div id="panel-1" class="panel" style="background-color: #fff3c5;">
						<div class="panel-hdr">
							<h2>
								CMEI <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<a href="dashboard_escola_Cmei_EmeiCon.asp?tp=CMEI" style="text-decoration: none; display: block;">
							<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
								<span class="qtde" id="qtdeCMEI">0</span>
								<span style="qtde-descricao"><i class="fal fa-school" aria-hidden="true"></i> Total de CMEI</span>
							</div>
							</a>
						</div>
					</div>
				</div>
			</div>					
		</div>

		<div class="col-xl-4">
			<div class="row">
				<div class="col-xl-12">
					<div id="panel-1" class="panel" style="background-color: #ebd8ff;">
						<div class="panel-hdr">
							<h2>
								EMEI <span class="fw-300"><i></i></span>
							</h2>
							<div class="panel-toolbar">
								<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
								<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
							</div>
						</div>
						<div class="panel-container show">
							<a href="dashboard_escola_Cmei_EmeiCon.asp?tp=EMEI" style="text-decoration: none; display: block;">
							<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
								<span class="qtde" id="qtdeEMEI">0</span>
								<span style="qtde-descricao"><i class="fal fa-school" aria-hidden="true"></i> Total de EMEI</span>
							</div>
							</a>
						</div>
					</div>
				</div>
			</div>					
		</div>		

	</div>
	<%if strTipo<>"" then%>
	<div class="row">
		<div class="col-xl-12">

			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2 style="display: flex; gap: 10px;">
						Escolas <%=strDescTipo%>
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
								<th style="width:390px;font-weight: bold;">Unidade</th>
								<th style="font-weight: bold;">Tipo</th>
								<th style="font-weight: bold;">Bairro</th>
								<th style="font-weight: bold;">Telefone</th>
								<th style='font-weight: bold;'>Alunos</th>
							</tr>
						</thead>
						<tbody>
						
						<%

						sql = "select UPPER(t.Descricao) as tipo ,t.codigo, e.codigo, e.RAZAOSOCIAL as unidade, e.ENDERECO, upper(e.BAIRRO) as bairro, isnull(e.cep,' ') as cep, e.TELEFONE, e.CONTATO,"
						sql = sql & " 						("
						sql = sql & " select "
						sql = sql & " count(*)" 
						sql = sql & " from sca_aluno_turma at"
						sql = sql & " inner join sca_aluno a on a.CODIGO = at.COD_ALUNO"
						sql = sql & " inner join SCA_SITUACAOALUNO sa on sa.Cod_SituacaoAluno = a.COD_SITUACAOALUNO"
						sql = sql & " where at.cod_empresa = e.codigo "
						sql = sql & " and at.situacao='A' "
						sql = sql & " and sa.Desc_SituacaoAluno = 'ATIVO'"
						sql = sql & " and at.Ano_Letivo = year(getdate())) as alunos "						
						sql = sql & " from SEG_EMPRESA e"
						sql = sql & " inner join SEG_TipoEmpresa t on t.CODIGO = e.CodTipoEmpresa and e.COD_GRUPO = t.COD_GRUPO"
						sql = sql & " where e.BLOQUEIO = 'N'"
						sql = sql & " and e.COD_GRUPO = " & session("CODGRUPO")


						'1 - CMEIS	
						'2 - ENSINO FUNDAMENTAL	
						'3 - Convêniadas	
						'4 - EMEI	
						'5 - Gabinete	


						if strTipo = "M" then
							sql = sql & " and t.CODIGO in (1,2,4)"
						end if
						if strTipo = "C" then
							sql = sql & " and t.CODIGO in (3)"
						end if
						if strTipo = "CMEI" then
							sql = sql & " and t.CODIGO in (1)"
						end if
						if strTipo = "EMEI" then
							sql = sql & " and t.CODIGO in (4)"
						end if
						if strTipo = "ESCOLA" then
							sql = sql & " and t.CODIGO in (2)"
						end if
						sql = sql & " order by tipo, unidade"
						'response.write sql
						rs.open sql, cnn
						if not rs.eof then 
							cont = 0
							while not rs.eof 
								%>
								<tr>
								  <td><font color="#000"><%=RS("unidade")%></font></th>
								  <td><font color="#000"><strong><%=RS("tipo")%></strong></font></td>
								  <td><font color="#000"><strong><%=rs("bairro")%></strong></font></td>
								  <td><font color="#000"><strong><%=RS("TELEFONE")%></strong></font></td>
								  <td><font color="#000"><strong><%=RS("alunos")%></strong></font></td>
								</tr>
								<%
								rs.movenext
							wend
						end if
						rs.close
						   %>
						</tbody>																							
					</table>

				</div>
			</div>		

		</div>
	</div>
	<%end if%>
	<div style="display:none">
	<span class="qtde" id="qtdeEscolas">0</span>
	<span class="qtde" id="qtdeEscolasConveniadas">0</span>
	<span class="qtde" id="qtdeEscolasMunicipais">0</span>
	</div>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>


