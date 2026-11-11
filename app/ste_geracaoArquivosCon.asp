<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200

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
            GEMUL - relatório de alunos que utilizam o transporte escolar
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<style>
			.verde 
				{
				color: #0dc90d;
				}
			.vermelho 
				{
				color: red;
				}
			
		</style>
    </head>
    <body class="nav-function-top header-function-fixed" style="" >
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "transporte.asp"
		pagina_atual = "/app/ste_geracaoArquivosCon.asp"
		menu_principal = "Relatório"
		sistema = "GEMUL"
		sistema_sigla = "STE"
		modulo = "STE"
		pagina = "Geração de arquivos"
		descricao_pagina = "Geração de arquivos do transporte escolar."
		mensagem_alerta_pagina = ""
		strExecutarSubmitSituacaoTransporte="N"
		strSituacao = "D"
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=ste_geracaoArquivos_con.asp-->
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
		<script src="js_app/ste_geracaoArquivoscon.js"></script>
    </body>
</html>
