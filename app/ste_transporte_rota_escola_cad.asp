<%
	acao = "I"

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	
	
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	strNomeRota	 			= Trim(Request.Form("txtNome"))
	intDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
	intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
	strValor	 			= Trim(Request.Form("txtValor"))
	strVeiculo	 			= Trim(Request.Form("txtVeiculo"))
	strPlaca	 			= Trim(Request.Form("txtPlaca"))
	strCor	 				= Trim(Request.Form("txtCor"))
	strData	 				= Trim(Request.Form("txtData"))
	strObservacao			= Trim(Request.Form("txtObservacao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	
	if intCodigo <> "" or strNomeRota <> "" then
	
		sql = "SELECT Cod_Rota, Cod_Grupo, Descricao, Distancia_percorrida, CodColaborador, Veiculo, Placa, Cor, Data, Observacao, Situacao, capacidade, reservado"
		sql = sql & " FROM SCA_ROTA"
		sql = sql & " where Cod_Grupo = " & Session("CodGrupo") 
		
		if intCodigo <> "" then 
			sql = sql & " and Cod_Rota=" & intCodigo
		end if
		
		if strNomeRota <> "" then 
			sql = sql & " and Descricao = '" & strNomeRota & "'"
		end if
		
		
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodRota	 			= rs("Cod_Rota")
			strNomeRota            	= rs("Descricao")
			strCapacidade          	= rs("Capacidade")
			strReservado           	= rs("Reservado")
			intDistanciaPercorrida 	= rs("Distancia_percorrida")
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
			intDistanciaPercorrida 	= ""
			intCodColaborador	 	= ""
			strVeiculo	 			= ""
			strPlaca	 			= ""
			strCor	 				= ""
			strData	 				= ""
			strObservacao          	= ""
			strCapacidade			= ""
			strReservado			= ""
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
	
	<form id="frm" name="frm" method="post">
	<%
	cont =0
	sql = "SELECT Cod_Rota as codigo, capacidade, Descricao as nome"
		sql = sql & " FROM SCA_ROTA"
		sql = sql & " where situacao = 'A' "
		sql = sql & " Order by Descricao"
		
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
							<span class="fw-300">Para editar clique em editar setor ou editar unidade abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Nome da Rota</strong></th>
									<th><strong>Capacidade</strong></th>
									<th><strong>Setor Vinculado</strong></th>
									<th><strong>Unidade Vinculada</strong></th>
									<th><strong>Setor</strong></th>
									<th><strong>Unidade</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								%>
								  <tr>
									<td class="celula"><%=rs("nome")%></td>
									<td height="20" class="celula"><%=trim(rs("capacidade"))%></td>
									<td height="20" class="celula"></td>
									<td height="20" class="celula"></td>
									<td height="20" class="celula">
										<button onClick="return abreSetores('<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Editar Setor</button>
									</td>
									<td height="20" class="celula">
										<button onClick="return abreModalUnidades('<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-info btn-sm">Editar Unidade</button>
									</td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="6" class="celula">Total Registros : <%=cont%></td>
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
	
	<div class="modal fade" id="modalSetores" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Relação de Setores cadastrados</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true"><i class="fal fa-times"></i></span>
					</button>
				</div>
				<div class="modal-body">
				
					<div id="divListaSetores"></div>	
					
				</div>	
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
				</div>
			</div>
		</div>

	</div>
	
	<div class="modal fade" id="modalUnidades" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Relação de Unidades cadastrados</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true"><i class="fal fa-times"></i></span>
					</button>
				</div>
				<div class="modal-body">
				
					<div id="divListaUnidades"></div>	
					
				</div>	
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
				</div>
			</div>
		</div>

	</div>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
