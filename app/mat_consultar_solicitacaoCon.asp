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
            GEMUL - Turmas
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file="includes/inc_formataCPF.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<style>
		.col-1, .col-2, .col-3, .col-4, .col-5, .col-6, .col-7, .col-8, .col-9, .col-10, .col-11, .col-12, .col, .col-auto, .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12, .col-sm, .col-sm-auto, .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12, .col-md, .col-md-auto, .col-lg-1, .col-lg-2, .col-lg-3, .col-lg-4, .col-lg-5, .col-lg-6, .col-lg-7, .col-lg-8, .col-lg-9, .col-lg-10, .col-lg-11, .col-lg-12, .col-lg, .col-lg-auto, .col-xl-1, .col-xl-2, .col-xl-3, .col-xl-4, .col-xl-5, .col-xl-6, .col-xl-7, .col-xl-8, .col-xl-9, .col-xl-10, .col-xl-11, .col-xl-12, .col-xl, .col-xl-auto {
			padding-top: 0.75rem;
		}
		
		  table td,
		  table th {
			vertical-align: middle !important;
		  }

		  table input.form-control {
			display: inline-block;
			width: auto;
			margin: 0 auto;
		  }
		  
		.situacao-aguardando {
			color: orange;
			font-weight: bold;
		}
		.situacao-cont {
			color: green;
			font-weight: bold;
		}
		.situacao-efet {
			color: blue;
			font-weight: bold;
		}
		.situacao-canc {
			color: red;
			font-weight: bold;
		}

/* Estilo base do alerta */
		.alerta {
			padding: 15px 20px;
			border-radius: 5px;
			margin: 20px 0;
			font-family: Arial, sans-serif;
			font-size: 1.1em;
			font-weight: bold;
			display: flex;
			align-items: center;
			border-left: 6px solid #f0ad4e; /* barra de destaque */
			background-color: #fff3cd;       /* fundo amarelo */
			color: #856404;                  /* texto escuro */
			box-shadow: 0 2px 6px rgba(0,0,0,0.1);
		}

		/* Ícone opcional */
		.alerta .icone {
			margin-right: 10px;
			font-size: 1.5em;
		}

		/* Cores alternativas */
		.alerta.sucesso {
			background-color: #d4edda;
			color: #155724;
			border-left-color: #28a745;
		}

		.alerta.erro {
			background-color: #f8d7da;
			color: #721c24;
			border-left-color: #dc3545;
		}

		.alerta.info {
			background-color: #d1ecf1;
			color: #0c5460;
			border-left-color: #17a2b8;
		}

		/* Animação de fade-in */
		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(-10px); }
			to { opacity: 1; transform: translateY(0); }
		}

		.alerta {
			animation: fadeIn 0.5s ease-in-out;
		}
	</style>
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "matricula.asp"
		pagina_atual = session("urlRaizLocalSistema") & "/app/mat_consultar_solicitacaoCon.asp"
		menu_principal = "Matrícula"
		sistema_sigla = "MAT"
		modulo = "MAT"
		pagina = "Consultar solicitação"
		descricao_pagina = "Consultar alunos."
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=mat_consultar_solicitacao_con.asp-->
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
		
				function cancelarSolicitacao(cod){
					var frm = document.getElementById("frm");
					if (!confirm('Deseja realmente cancelar essa solicitação?'))
						return false;
					else{
						frm.action = "mat_cancelar_solicitacao_cod.asp?cod="+cod;
						frm.submit();
						return true;	
					}
				}

        </script>
    </body>
</html>
