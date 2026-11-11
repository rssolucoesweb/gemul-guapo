<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_ata_resultadoCon.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
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
			<div id="panel-8" class="panel">
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
						
						<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
						<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
						<input name="txtPodeEditar" value="<%=strPodeEditar%>" type="hidden">
						<div class="row">
							<div class="col-sm-12">
								
								<div class="table-responsive-lg">
									<table class="table table-bordered table-hover m-0">
										<thead class="thead-themed">
										  <tr>
											<th><input name="chkTodos" type="checkbox" value="" onClick="return MarcaTodosAlunos(this.checked)"></th>
											<th><strong>Código</strong></th>
											<th><strong>Assunto</strong></th>
											<th><strong>Data</strong></th>
										  </tr>
										</thead>
										<tbody>
								
								  <%					
									sql = "SELECT Codigo, Cod_empresa, Assunto, descricao, data, TextoAta"
									sql = sql & " FROM SCA_ATA"
									sql = sql & " Where Cod_empresa = " & session("codEmpresa")
									sql = sql & " Order by codigo"
									rs.open sql, cnn
									if rs.eof = false then
										while not rs.eof
											%>
										  <tr  style="cursor: pointer">
											<td><input type="checkbox" id="chkAta" name="chkAta" value="<%=rs("codigo")%>"></td>
											<td><%=rs("Codigo")%></td>
											<td><%=rs("Assunto")%>&nbsp;</td>
											<td><%=FORMATADATAAP(rs("data"))%>&nbsp;</td>
										  </tr>
										  <%
											rs.movenext
										wend
									else
									%>
									  <tr> 
										<td colspan="4" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
									  </tr>
									  <%
									end if
									rs.close
									%>
								</table>
								<br>
								<br>
							</div>
							
						</div>
						
						
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>