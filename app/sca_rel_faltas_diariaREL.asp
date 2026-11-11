<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!DOCTYPE html>
<!-- 
GEMUL 
Version: 20.1.0
Desenvolvedor: Sérgio Borges
Website: http://gemul.com.br
Contato: sergio@rssolucoesweb.com.br
-->
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            GEMUL - Faltas diária
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<style>
		.col-1, .col-2, .col-3, .col-4, .col-5, .col-6, .col-7, .col-8, .col-9, .col-10, .col-11, .col-12, .col, .col-auto, .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12, .col-sm, .col-sm-auto, .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12, .col-md, .col-md-auto, .col-lg-1, .col-lg-2, .col-lg-3, .col-lg-4, .col-lg-5, .col-lg-6, .col-lg-7, .col-lg-8, .col-lg-9, .col-lg-10, .col-lg-11, .col-lg-12, .col-lg, .col-lg-auto, .col-xl-1, .col-xl-2, .col-xl-3, .col-xl-4, .col-xl-5, .col-xl-6, .col-xl-7, .col-xl-8, .col-xl-9, .col-xl-10, .col-xl-11, .col-xl-12, .col-xl, .col-xl-auto {
			padding-top: 0.75rem;
		}
	</style>
    </head>
    <body class="mod-bg-1 ">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "academico.asp"
		pagina_atual = "/app/sca_rel_faltas_diaria.asp"
		menu_principal = "Relatórios"
		sistema = "GEMUL"
		modulo = "Acadêmico"
		pagina = "Relatório de faltas diária"
		descricao_pagina = "Visualização das faltas diária dos alunos com opções de impressão."
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					
					<main id="js-page-content" role="main" class="page-content">
					<ol class="breadcrumb page-breadcrumb">
						<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
						<li class="breadcrumb-item"><%=modulo%></li>
						<li class="breadcrumb-item active"><%=pagina%></li>
						<li class="position-absolute pos-top pos-right d-none d-sm-block"><span class="js-get-date"></span></li>
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
					
										<!--#include file=sca_rel_faltas_diaria_rel.asp-->
										
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- FIM conteudo -->
					
					<!--#include file=inc_rodape.asp-->
					
					<!--#include file=inc_modal_atalho.asp-->
					
                </div>
            </div>
        </div>
        <!-- FIm pagina -->
		
		<!--#include file=inc_menu_rapido.asp-->
        
		<!--#include file=inc_mensagem.asp-->
        
        <!-- base vendor bundle: 
			 DOC: if you remove pace.js from core please note on Internet Explorer some CSS animations may execute before a page is fully loaded, resulting 'jump' animations 
						+ pace.js (recommended)
						+ jquery.js (core)
						+ jquery-ui-cust.js (core)
						+ popper.js (core)
						+ bootstrap.js (core)
						+ slimscroll.js (extension)
						+ app.navigation.js (core)
						+ ba-throttle-debounce.js (core)
						+ waves.js (extension)
						+ smartpanels.js (extension)
						+ src/../jquery-snippets.js (core) -->
        <script src="js/vendors.bundle.js"></script>
        <script src="js/app.bundle.js"></script>
		<script src="js/js_funcoes_gerais.js"></script>
        <script type="text/javascript">
        </script>
    </body>
</html>
