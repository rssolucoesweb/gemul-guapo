<%
	strExecutarSubmit                   = "S" 
	strExecutarSubmitTurma				= "S"
	strReloadDisciplinaQuadro			= "S"
	
	strPaginaTitulo 					= "FichaDescritivaNotas_cad.asp"
	
	intCodigo   					 	= Trim(Request.QueryString("codigo"))	
	if trim(intCodigo) <> "" then
		sql = "SELECT F.*, A.NOMEALUNO AS ALUNO, I.IMAGEM"
		sql = sql & " FROM SCA_ALUNO_JUSTIFICATIVA_FALTAS F"
		sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = F.COD_ALUNO"
		sql = sql & " LEFT JOIN SCA_ALUNO_JUSTIFICATIVA_FALTAS_IMAGEM I ON F.CODIGO = I.COD_ALUNO_JUSTIFICATIVA_FALTAS"
		sql = sql & " Where F.CODIGO = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			strAluno				= rs("aluno")
			intCodAluno				= rs("COD_ALUNO")
			intCodTurma 			= rs("COD_TURMA")
			strDataInicial 			= FORMATADATAAP(rs("DATAINICIAL"))
			strDataFinal 			= FORMATADATAAP(rs("DATAFINAL"))
			strJustificativa 		= rs("Justificativa")
			strImagem		 		= rs("imagem")
			strPeriodo				= formatadataAP(rs("dataInicial")) & " a " & formatadataAP(rs("dataFinal"))
		end if 
		rs.close
	end if
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
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
						<%=strAluno%> | <%=strPeriodo%><span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
									
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Justificativa:</label>
									 <%=strJustificativa%>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<%=strImagem%>
								</div>
							</div>
						</div>
						
						<br>
						<div class="frame-wrap">
							<button onClick="window.close()"  type="button" class="btn btn-outline-danger">Fechar</button>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
	

</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>