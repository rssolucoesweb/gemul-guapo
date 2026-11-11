<%
	acao = "I"

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	
	
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	strNomeRota	 			= Trim(Request.Form("txtNome"))
	strDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
	intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
	strValor	 			= Trim(Request.Form("txtValor"))
	strVeiculo	 			= Trim(Request.Form("txtVeiculo"))
	strPlaca	 			= Trim(Request.Form("txtPlaca"))
	strCor	 				= Trim(Request.Form("txtCor"))
	strData	 				= Trim(Request.Form("txtData"))
	strObservacao			= Trim(Request.Form("txtObservacao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	
	if intCodigo <> "" then
	
		sql = "SELECT Cod_Rota, Cod_Grupo, Descricao, Distancia_percorrida, CodColaborador, Veiculo, Placa, Cor, Data, Observacao, Situacao, "
		sql = sql & " Capacidade_Matutino, Reservado_Matutino, "
		sql = sql & " Capacidade_Vespertino, Reservado_Vespertino, "
		sql = sql & " Capacidade_Noturno, Reservado_Noturno "
		sql = sql & " FROM STE_ROTA"
		sql = sql & " where Cod_Grupo = " & Session("CodGrupo") 
		
		if intCodigo <> "" then 
			sql = sql & " and Cod_Rota=" & intCodigo
		end if
		
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodRota	 			= rs("Cod_Rota")
			strNomeRota            	= rs("Descricao")

			strCapacidadeMatutino  	= rs("Capacidade_Matutino")
			strReservadoMatutino   	= rs("Reservado_Matutino")

			strCapacidadeVespertino = rs("Capacidade_Vespertino")
			strReservadoVespertino 	= rs("Reservado_Vespertino")

			strCapacidadeNoturno	= rs("Capacidade_Noturno")
			strReservadoNoturno		= rs("Reservado_Noturno")

			strDistanciaPercorrida 	= rs("Distancia_percorrida")
			intCodColaborador	 	= rs("CodColaborador")
			strVeiculo	 			= rs("Veiculo")
			strPlaca	 			= rs("Placa")
			strCor	 				= rs("Cor")
			strData	 				= formatadataAP(rs("Data"))
			strObservacao          	= rs("Observacao")
			strSituacao				= rs("Situacao")	
			
			strBloqueia = "readonly"	
			
			acao 					= "AE"
		
		else
			
			strBloqueia = ""
			intCodRota	 			= ""
			strDistanciaPercorrida 	= ""
			intCodColaborador	 	= ""
			strVeiculo	 			= ""
			strPlaca	 			= ""
			strCor	 				= ""
			strData	 				= ""
			strObservacao          	= ""
			
			strCapacidadeMatutino  	= ""
			strReservadoMatutino   	= ""
									  
			strCapacidadeVespertino = ""
			strReservadoVespertino 	= ""
									  
			strCapacidadeNoturno	= ""
			strReservadoNoturno		= ""
			
			strSituacao				= ""
			
			acao 					= "I"
		
			
		end if
		rs.close
	
	else
		acao 					= "I"
	end if 
	
	if strData = "" then strData = formatadataAP(date)
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
							
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Nome da rota:</label>
										<input name="txtNome" type="text" class="form-control" id="txtNome" size="80" maxlength="100" value="<%=strNomeRota%>">
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Dist&acirc;ncia percorrida (km):</label>
										<input name="txtDistanciaPercorrida" type="text" class="form-control" id="txtDistanciaPercorrida" size="11" maxlength="30" value="<%=strDistanciaPercorrida%>">
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Motorista:</label>
										<!--#include file="includes/inc_cmbMotorista.asp" -->
									</div>
								</div>
								
							</div>
							<br>						
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Veículo:</label>
										<input name="txtVeiculo" type="text" class="form-control" id="txtVeiculo" size="80" maxlength="100" value="<%=strVeiculo%>">
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Placa:</label>
										<input name="txtPlaca" type="text" class="form-control" id="txtPlaca" size="11" maxlength="20" value="<%=strPlaca%>">
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Cor:</label>
										<input name="txtCor" type="text" class="form-control" id="txtCor" size="11" maxlength="100" value="<%=strCor%>">
									</div>
								</div>
							</div>
							<br>						
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Capacidade Matutino:</label>
										<input name="txtCapacidadeMatutino" type="text" class="form-control" id="txtCapacidadeMatutino" size="11" maxlength="5" value="<%=strCapacidadeMatutino%>">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Reservada Matutino:</label>
										<input name="txtReservadoMatutino" type="text" class="form-control" id="txtReservadoMatutino" size="11" maxlength="5" value="<%=strReservadoMatutino%>">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Capacidade Vespetino:</label>
										<input name="txtCapacidadeVespertino" type="text" class="form-control" id="txtCapacidadeVespertino" size="11" maxlength="5" value="<%=strCapacidadeVespertino%>">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Reservada Vespetino:</label>
										<input name="txtReservadoVespertino" type="text" class="form-control" id="txtReservadoVespertino" size="11" maxlength="5" value="<%=strReservadoVespertino%>">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Capacidade Noturno:</label>
										<input name="txtCapacidadeNoturno" type="text" class="form-control" id="txtCapacidadeNoturno" size="11" maxlength="5" value="<%=strCapacidadeNoturno%>">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Reservada Noturno:</label>
										<input name="txtReservadoNoturno" type="text" class="form-control" id="txtReservadoNoturno" size="11" maxlength="5" value="<%=strReservadoNoturno%>">
									</div>
								</div>
							</div>
							<br>						
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<label class="form-label">Observa&ccedil;&atilde;o:</label>
										<input name="txtObservacao" type="text" class="form-control" id="txtObservacao" size="80" maxlength="300" value="<%=strObservacao%>">
									</div>
								</div>
							</div>
							<br>						
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Situação</label>
										<!--#include file="includes/inc_cmbSituacao.asp"-->
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
	sql = "SELECT Cod_Rota as codigo, Descricao as nome, Situacao, "
	sql = sql & " Capacidade_Matutino, Reservado_Matutino, "
	sql = sql & " Capacidade_Vespertino, Reservado_Vespertino, "
	sql = sql & " Capacidade_Noturno, Reservado_Noturno "
	sql = sql & " FROM STE_ROTA"
	sql = sql & " where Cod_Grupo =  " & Session("CodGrupo") 			
	sql = sql & " Order by Descricao"
		
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
									<th><strong>Nome da Rota</strong></th>
									<th><strong>Capacidade Matutino</strong></th>
									<th><strong>Reservada Matutino</strong></th>
									<th><strong>Capacidade Vespertino</strong></th>
									<th><strong>Reservada Vespertino</strong></th>
									<th><strong>Capacidade Noturno</strong></th>
									<th><strong>Reservada Noturno</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								situacao = ""
								if rs("situacao") = "A" then situacao = "Ativo"
								if rs("situacao") = "I" then situacao = "Inativo"
								
								Capacidade_Matutino 	= trim(rs("Capacidade_Matutino"))
								Reservado_Matutino 		= trim(rs("Reservado_Matutino"))
								Capacidade_Vespertino 	= trim(rs("Capacidade_Vespertino"))
								Reservado_Vespertino 	= trim(rs("Reservado_Vespertino"))
								Capacidade_Noturno 		= trim(rs("Capacidade_Noturno"))
								Reservado_Noturno 		= trim(rs("Reservado_Noturno"))
								
								if Capacidade_Matutino 		= "0" then  Capacidade_Matutino 	= "" 
								if Reservado_Matutino 		= "0" then  Reservado_Matutino 		= "" 
								if Capacidade_Vespertino 	= "0" then  Capacidade_Vespertino 	= "" 
								if Reservado_Vespertino 	= "0" then  Reservado_Vespertino 	= "" 
								if Capacidade_Noturno 		= "0" then  Capacidade_Noturno 		= "" 
								if Reservado_Noturno 		= "0" then  Reservado_Noturno 		= "" 
								
								
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("nome")%></td>
									<td height="20" class="celula"><%=Capacidade_Matutino%></td>
									<td height="20" class="celula"><%=Reservado_Matutino%></td>
									<td height="20" class="celula"><%=Capacidade_Vespertino%></td>
									<td height="20" class="celula"><%=Reservado_Vespertino%></td>
									<td height="20" class="celula"><%=Capacidade_Noturno%></td>
									<td height="20" class="celula"><%=Reservado_Noturno%></td>
									<td height="20" class="celula"><%=situacao%></td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="8" class="celula">Total Registros : <%=cont%></td>
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