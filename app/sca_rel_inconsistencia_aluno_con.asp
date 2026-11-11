<%
	
	intCodEmpresaGrupo		= Trim(Request.Form("cmbEmpresaGrupo"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	
	strAnoLetivo               = Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then
		strAnoLetivo 			= session("strAnoLetivo")
	end if
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_rel_mae_alunoCon.asp">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
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
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Unidade:</label>
									 <!--#include file="includes/inc_cmbEmpresaGrupo.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-12">
								<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
									<tr>
									  <td  colspan="6" class="texto1"><strong>Selecione o(s) campo(s) que deseja checar incosistencias:<br></strong></td>
									</tr>
									<tr>
									  <td align="right" class="texto1"><input type="checkbox" name="nomealuno" id="nomealuno" value="S"></td>
									  <td width="13%"><span class="texto1">Nome do Aluno</span></td>
									  <td width="2%" align="right" class="texto1"><input type="checkbox" name="datamatricula" id="datamatricula" value="S"></td>
									  <td width="14%"><span class="texto1">Data da matr&iacute;cula</span></td>
									  <td width="2%" align="right" class="texto1"><input type="checkbox" name="datanascimento" id="datanascimento" value="S"></td>
									  <td width="67%"><span class="texto1">Data de nascimento</span></td>
									</tr>
									<tr>
									  <td align="right" class="texto1"><input type="checkbox" name="sexo" id="sexo" value="S"></td>
									  <td><span class="texto1">Sexo</span></td>
									  <td align="right" class="texto1"><input type="checkbox" name="naturalidade" id="naturalidade" value="S"></td>
									  <td><span class="texto1">Naturalidade</span></td>
									  <td align="right" class="texto1"><input type="checkbox" name="ufnaturalidade" id="ufnaturalidade" value="S"></td>
									  <td><span class="texto1">UF naturalidade</span></td>
									</tr>
									<tr>
									  <td align="right" class="texto1"><input type="checkbox" name="etnia" id="etnia" value="S"></td>
									  <td><span class="texto1">Etnia</span></td>
									  <td align="right" class="texto1"><input type="checkbox" name="logradouro" id="logradouro" value="S"></td>
									  <td><span class="texto1">Logradouro</span></td>
									  <td align="right" class="texto1"><input type="checkbox" name="nomemae" id="nomemae" value="S"></td>
									  <td><span class="texto1">Nome da m&atilde;e</span></td>
									</tr>
									<tr>
									  <td class="texto1">&nbsp;</td>
									  <td colspan="5">&nbsp;</td>
									</tr>
								  </table>
							
							</div>
						</div>
						
						<br>
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