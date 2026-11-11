<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Buffer = false

strControlePagina = request.querystring("pagina")
if strControlePagina = "" then request.form("pagina")

if strControlePagina = "pp" then
	strTituloPagina = "Planejamento professor por turma"
	strDescricaoPagina = "Cadastro do Planejamento do Professor por Turma, opções de inclusão, alteração, exclusão e consulta."
else
	strTituloPagina = "Conteúdo Ministrado"
	strDescricaoPagina = "Cadastro do Conteúdo Ministrado do Professor, opções de inclusão, alteração, exclusão e consulta."
end if

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
            GEMUL - <%=strTituloPagina%>
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<link rel="stylesheet" media="screen, print" href="css/notifications/toastr/toastr.css">
		<!--#include file=inc_ico.asp-->
		<!--#include file="includes/inc_formatadata.asp"-->

		<style>
			
			.estilo_legenda{
				max-width: 100%;
				//width: 260px;
				height: 40px;
				margin-left: auto;
				margin-right: auto; 
				display: flex;
				justify-content: center;
				align-items: center;
			}
			.amarelo{
				background: #FFFAF0;
				padding: 15px 5px;
			}
			.azul{
				background: #bce5fa;
				padding: 15px 5px;
			}
			.vermelho{
				background: #edb6c3;
				padding: 15px 5px;
			}
			.verde{
				background: #a2e798;
				padding: 15px 5px;
			}
			.laranja{
				background: #FEDC9D;
				padding: 15px 5px;
			}

		</style>

    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<script src="js/js_funcoes_gerais.js"></script>
		<%
		pagina_inicial_do_modulo = "academico.asp"
		pagina_atual = "/app/sca_planejamento_professor.asp?pagina=" & strControlePagina
		menu_principal = "Manutenção"
		sistema = "GEMUL"
		sistema_sigla = "PLA"
		modulo = "PLA"
		pagina = strTituloPagina
		descricao_pagina = strDescricaoPagina
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file="includes/inc_aguarde.asp"-->
					<!--#include file=sca_planejamento_professor_cad.asp-->
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
		<script src="js/notifications/toastr/toastr.js"></script>
		<script src="js_app/sca_planejamento_professor.js?v=<%=now%>"></script>
        <script type="text/javascript">

				aguarde.style.display="none";
					
        </script>
    </body>
</html>
