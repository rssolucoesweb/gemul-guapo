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
	sql = "select s.cod_rota as codigo, s.descricao as nome, s.capacidade_matutino, s.capacidade_vespertino, s.capacidade_noturno, count(v.Cod_rota_vincula_setores) as qtde_setores, count(u.Cod_rota_vincula_unidade_setores) as qtde_unidades"
	sql = sql & " from STE_ROTA s"
	sql = sql & " left join STE_ROTA_VINCULA_SETORES v on v.cod_Rota = s.cod_rota "
	sql = sql & " left join STE_ROTA_VINCULA_UNIDADE_SETORES u on u.Cod_setores = v.Cod_setores " 
	sql = sql & " group by s.cod_rota, s.descricao, s.capacidade_matutino, s.capacidade_vespertino, s.capacidade_noturno"
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
						<div class="panel-tag">
							<span class="fw-300">Para editar clique em editar setor ou editar unidade abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Nome da Rota</strong></th>
									<th><strong>Capacidade Matutino</strong></th>
									<th><strong>Capacidade Vespertino</strong></th>
									<th><strong>Capacidade Noturno</strong></th>
									<th><strong>Setor Vinculado</strong></th>
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
									<td height="20" class="celula"><%=trim(rs("capacidade_matutino"))%></td>
									<td height="20" class="celula"><%=trim(rs("capacidade_vespertino"))%></td>
									<td height="20" class="celula"><%=trim(rs("capacidade_noturno"))%></td>
									<td height="20" class="celula"><%if rs("qtde_setores")>0 then%><%=trim(rs("qtde_setores"))%><%end if%></td>
									<td height="20" class="celula"><%if rs("qtde_unidades")>0 then%><%=trim(rs("qtde_unidades"))%><%end if%></td>
									<td height="20" class="celula">
										<button onClick="return abreModalSetores('<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Vincular Setor</button>
									</td>
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
				Nenhuma rota cadastrada. Efetuar o cadastramento das rotas antes de fazer o vinculo!
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
					<div>
						<button onClick="salvarSetores()"  type="button" class="btn btn-success waves-effect waves-themed">Salvar</button>
						<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
					</div>
					<br>
					<div id="divListaSetores"></div>	
					
				</div>	
				<div class="modal-footer">
					<button onClick="salvarSetores()"  type="button" class="btn btn-success waves-effect waves-themed">Salvar</button>
					<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
				</div>
			</div>
		</div>

	</div>
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
