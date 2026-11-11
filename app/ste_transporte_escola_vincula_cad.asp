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
	
	<form id="frm" name="frm" method="post" action="ste_transporte_escola_vincula.asp">
	<%
	cont =0
	
	rede = request("rede")
	if rede = "" then rede = "0"
	
	
	sql = "select s.codigo, s.descricao as nome, count(v.Cod_rota_vincula_unidade_setores) as qtde_unidades"
	sql = sql & " from MAT_SETORES s"
	sql = sql & " left join STE_ROTA_VINCULA_UNIDADE_SETORES v on v.cod_setores = s.codigo"
	if rede = "M" then
		sql = sql & " and v.Cod_empresa is not null"
	elseif rede = "E" then
		sql = sql & " and v.codigo_escola_estadual is not null"
	end if
	sql = sql & " group by s.codigo, s.descricao"
	sql = sql & " Order by s.Descricao"
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
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Qual Rede?</label>
									<select class="form-control" id="rede" name="rede" onchange="submit()">
										<option <%if rede = "0" then response.write "selected"%> value="0">Selecione...</option>
										<option <%if rede = "M" then response.write "selected"%> value="M">MUNICIPAL</option>
										<option <%if rede = "E" then response.write "selected"%> value="E">ESTADUAL</option>
									</select>
								</div>
							</div>
						</div>
						<br>
						<%if rede <> "0" then%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Setor</strong></th>
									<th><strong>Unidade Vinculada</strong></th>
									<th><strong>Ação</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								%>
								  <tr>
									<td class="celula"><%=rs("nome")%></td>
									<td height="20" class="celula"><%if rs("qtde_unidades")>0 then%><%=trim(rs("qtde_unidades"))%><%end if%></td>
									<td height="20" class="celula">
										<button onClick="return abreModalUnidades('<%=rs("CODIGO")%>','<%=rede%>')" type="button" class="btn btn-outline-success btn-sm">Vincular Unidade</button>
									</td>
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
					<%end if%>
					</div>
				</div>
			</div>
		</div>
	</div> 
	<%
	else
	%>
	<div class="alert alert-warning alert-dismissible fade show">
		<button type="button" class="close" data-dismiss="alert" aria-label="Close">
			<span aria-hidden="true"><i class="fal fa-times"></i></span>
		</button>
		<div class="d-flex align-items-center">
			<div class="alert-icon width-8">
				<span class="icon-stack icon-stack-xl">
					<i class="base-2 icon-stack-3x color-warning-400"></i>
					<i class="base-10 text-white icon-stack-1x"></i>
					<i class="ni md-profile color-warning-800 icon-stack-2x"></i>
				</span>
			</div>
			<div class="flex-1 pl-1">
				<span class="h2">
					Atenção:
				</span>
				<br>
				Os setores não foram cadastrados. Efetuar o cadastramento antes de fazer o vinculo com a unidade escolar!
			</div>
		</div>
	</div>
	<%
	end if
	rs.close
	  
	%>
	
	<div class="modal fade" id="modalUnidades" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Relação de Unidades cadastradas</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true"><i class="fal fa-times"></i></span>
					</button>
				</div>
				
				<div class="modal-body">
					<div>
						<button onClick="salvarUnidades()"  type="button" class="btn btn-success waves-effect waves-themed">Salvar</button>
						<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
					</div>
					<br>
					<div id="divListaUnidades"></div>	
					
				</div>	
				<div class="modal-footer">
					<button onClick="salvarUnidades()"  type="button" class="btn btn-success waves-effect waves-themed">Salvar</button>
					<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
				</div>
			</div>
		</div>

	</div>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
