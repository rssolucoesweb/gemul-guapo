<%
	if trim(SESSION("UsuarioWeb")) <> "" then
		
		sql = "select USUA_NOME_COMPLETO AS NOME"
		sql = sql & " from SEG_USUARIOS_SISTEMA"
		sql = sql & " where USUA_CODG='" & SESSION("UsuarioWeb") & "'"
		sql = sql & " AND USUA_STAT='A'"
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strNome	 			= ucase(rs("nome"))
			
			acao 					= "A"

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
		<div class="col-xl-8">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%>&nbsp;-&nbsp;<strong><%=strNome%></strong>
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
							<div class="form-group">
								<label class="form-label">Senha atual</label>
								<input type="password" id="txtSenhaAtual" name="txtSenhaAtual"  maxlength="50" class="form-control" >
							</div>
							<div class="form-group">
								<label class="form-label">Nova senha</label>
								<input type="password" id="txtSenhaNova" name="txtSenhaNova" maxlength="50" class="form-control" >
							</div>
							<div class="form-group">
								<label class="form-label">Confirmar nova senha</label>
								<input type="password" id="txtSenhaNovaRepetir" name="txtSenhaNovaRepetir" maxlength="50" class="form-control" >
							</div>
							
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>