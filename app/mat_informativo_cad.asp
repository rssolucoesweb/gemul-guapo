<%
	acao = "I"
	intCodGrupo	 			= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodTipoEmpresa		= Trim(Request("cmbTipoEmpresa"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDados 				= Trim(Request.Form("txtDados"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_grupo, CodTipoEmpresa, Descricao, Dados"
		sql = sql & " FROM MAT_Dados"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & Session("CodGrupo")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			intCodTipoEmpresa 		= rs("CodTipoEmpresa")
			strDescricao	 		= rs("Descricao")
			strDados	 			= rs("Dados")
			acao = "AE"
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			
		else
			acao = "I"
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		
		end if 
		rs.close
	else
		acao = "I"
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
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
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<label class="form-label">Tipo de unidade</label>
										<!--#include file="includes/inc_cmbTipoEmpresa.asp"-->
									
									</div>
                                </div>
                            </div>
							<br>
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<label class="form-label">Descrição</label>
										<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>"  maxlength="50">
									</div>
                                </div>
                            </div>
							<br>
							
							<div class="row">
								<div class="col-xl-12">
                                    <div class="panel-container show">
                                        <div class="panel-content">
										
                                            <textarea
												id="txtTexto"
												name="txtTexto"
												class="js-summernote"
											>
												<%=strDados%>
											</textarea>

											
                                            <div class="mt-3">
                                                <div class="custom-control custom-checkbox">
                                                    <input type="checkbox" class="custom-control-input" id="autoSave">
                                                </div>
                                            </div>
                                        </div>
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
					
	sql = "SELECT Codigo, Cod_grupo, CodTipoEmpresa, Descricao, Dados"
	sql = sql & " FROM MAT_Dados"
	sql = sql & " Where Cod_grupo = " & session("CodGrupo")
	sql = sql & " Order by codigo"
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
									<th><strong>C&oacute;digo</strong></th>
									<th><strong>Título</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								%>
									<tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("codigo")%></td>
									<td height="20" class="celula"><%=trim(rs("Descricao"))%></td>
								  </tr>
								  </tr>
								  <%
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="2" class="celula">Total Registros : <%=cont%></td>
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
