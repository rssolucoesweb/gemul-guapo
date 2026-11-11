<%
	acao = "I"
	strExecutarSubmitDepto	= "S"
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strAssunto 				= Trim(Request.Form("txtAssunto"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDataAta 				= Trim(Request.Form("txtDataAta"))
	strTextoAta 			= Trim(Request.Form("txtTextoAta"))
	intCodDepartamento		= Trim(Request.Form("cmbDepartamento"))
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	intSemestre		= Trim(Request.Form("cmbSemestre"))
	
	
	if TRIM(Session("NivelPermissao")) = "A" then
	   strMostraSomenteDeptoAtual = "" 'mostra todos os deptos
    else   
	   strMostraSomenteDeptoAtual = "S" 'mostra somente o depto atual
	end if	
	
	if intCodDepartamento = "" then  intCodDepartamento = "0"
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, cod_departamento, Assunto, descricao, data, TextoAta, AnoLetivo , Semestre	"
		sql = sql & " FROM SCA_ATA"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_empresa = " & session("codEmpresa")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			strAssunto 				= rs("Assunto")
			strDescricao 			= rs("descricao")
			strDataAta 				= formatadataAP(rs("data"))
			strTextoAta				= rs("TextoAta")
			intCodDepartamento		= rs("cod_departamento")
			strAnoLetivo			= rs("AnoLetivo")
			intSemestre				= rs("Semestre")
			
			acao = "AE"
		end if 
		rs.close
	end if 
	
	if trim(strDataAta) = "" then strDataAta = formatadataAP(date)
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
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Assunto</label>
										<input name="txtAssunto" type="text" class="form-control" id="txtAssunto" size="40" maxlength="40" value="<%=strAssunto%>">
									</div>
                                </div>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Descrição</label>
										<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>">
									</div>
                                </div>
                            </div>
							
							<br>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Data</label>
										<input name="txtDataAta" type="text" class="form-control" id="txtDataAta" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataAta%>">
									</div>
                                </div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Ano letivo</label>
										<input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
									</div>
                                </div>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Semestre</label>
										<!--#include file="includes/inc_cmdSemestre.asp"-->
									</div>
                                </div>
                            </div>
							
							<textarea id="txtTexto" name="txtTexto"><%=strTextoAta%></textarea>
							<div class="row">
								<div class="col-xl-12">
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            <div class="js-summernote" id="saveToLocal">
												
											</div>
											
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
			
	sql = "SELECT Codigo, Cod_empresa, Assunto, descricao, data, TextoAta"
	sql = sql & " FROM SCA_ATA"
	sql = sql & " Where Cod_empresa = " & session("codEmpresa")
	sql = sql & " Order by codigo desc"
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
									<th><strong>Assunto</strong></th>
									<th><strong>Descrição</strong></th>
									<th><strong>Data</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("codigo")%></td>
									<td height="20" class="celula"><%=trim(rs("assunto"))%></td>
									<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
									<td height="20" class="celula"><%=formatadataAP(trim(rs("data")))%></td>
								  </tr>
								  <%
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
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
