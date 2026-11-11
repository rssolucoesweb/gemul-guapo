<%
	acao = "I"

	strExecutarSubmit				= "S"
	strPaginaTitulo 				= "FichaDescritivaPergunta_cad.asp"
	intCodigo						= Trim(Request.Form("txtCodigo"))
	
	if request.QueryString("CodFichaDescritivao") <> "" then
		intCodFichaDescritiva	= Trim(Request.QueryString("CodFichaDescritivao"))
	else
		intCodFichaDescritiva			= Trim(Request.Form("cmbFichaDescritiva"))
	end if
	
	strSubtitulo 					= Trim(Request.Form("txtSubtitulo"))
	strDescricao 					= Trim(Request.Form("txtDescricao"))
	if intCodFichaDescritiva = "" then intCodFichaDescritiva = "0"
	
	
	' Consulta Ficha Descritiva
	if trim(intCodFichaDescritiva) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Situacao, observacoes, rodape, Publicar"
		sql = sql & " FROM SCA_FICHA_DESCRITIVA"
		sql = sql & " Where Codigo = " & intCodFichaDescritiva
		rs.open sql, cnn
		if rs.eof = false then
			strDescricaoFichaDescritiva			= rs("Descricao")
		end if 
		rs.close

	end if 
	
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, cod_ficha_descritiva, Subtitulo, Descricao "
		sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA"
		sql = sql & " Where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo								= rs("Codigo")
			intCodFichaDescritiva	 				= rs("Cod_ficha_descritiva")
			strSubtitulo							= trim(rs("Subtitulo"))
			strDescricao							= trim(rs("Descricao"))

			acao = "AE"
			

		end if 
		rs.close
	end if 
	
	if intCodAvaliacaoInstitucional = "" then intCodAvaliacaoInstitucional = 0
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
						
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<div class="row">
								
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Ficha Descritiva</label>
										<!--#include file="includes/inc_cmdFichaDescritiva.asp"-->
									</div>
								</div>	
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Subt&iacute;tulo <i>(M&aacute;ximo 300 caracteres)</i></label>
										<input type="text" id="txtSubtitulo" name="txtSubtitulo" class="form-control" value="<%=strSubtitulo%>" maxlength="100">
									</div>
								</div>
								<div class="col-sm-4">	
									<div class="form-group">
										<label class="form-label">Pergunta <i>(M&aacute;ximo 300 caracteres)</i></label>
										<input type="text" id="txtDescricao" name="txtDescricao" class="form-control" value="<%=strDescricao%>" maxlength="100">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<span><strong>Obs: Informar o subt&iacute;tulo somente quando houver a necessidade de quebrar um determinado assunto dentro do question&aacute;rio.</strong></span>
								</div>	
							</div>					
							<br>
							<br>
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont =0
	
	if intCodFichaDescritiva <> "0" then
	
		sql = "SELECT Codigo, cod_ficha_descritiva, Subtitulo, Descricao "
		sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA"
		sql = sql & " WHERE cod_ficha_descritiva = " & intCodFichaDescritiva
		sql = sql & " Order by Codigo"
						
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
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><input type="checkbox" name="chkTodos" onClick="return MarcaTodasPerguntas(this.checked)"></th>
									<th><strong>Ordem</strong></th>
									<th><strong>Cod.Quest&atilde;o</strong></th>
									<th><strong>Descrição</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							  <%
							while not rs.eof
								cont = cont + 1	
								if trim(rs("Subtitulo")) <> "" then
								   %>
								   <tr bgcolor="#E5E5E5">
								   <td height="21" colspan="4" class="celula"><%=trim(rs("Subtitulo"))%></td>
								   </tr>
								   <%
								end if   
					
								%>
								  <tr style="cursor: pointer">
									<td height="20" class="celula"><input type="checkbox" id="chkPergunta" name="chkPergunta" value="<%=rs("codigo")%>"></td>
									<td height="20" class="celula" onClick="return resultadoConsulta('<%=rs("codigo")%>')"><%=cont%></td>
									<td height="20" class="celula" onClick="return resultadoConsulta('<%=rs("codigo")%>')"><%=trim(rs("Codigo"))%></td>
									<td height="20" class="celula" onClick="return resultadoConsulta('<%=rs("codigo")%>')"><%=trim(rs("Descricao"))%></td>
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
	end if
	  
	%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>