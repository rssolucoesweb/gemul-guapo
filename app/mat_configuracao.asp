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
            GEMUL - Configurações
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="../includes/inc_periodoFuncionalidade.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<style>
			.cfg-liberado { color: #1e7e34; font-weight: 600; }
			.cfg-bloqueado { color: #e60000; font-weight: 600; }
			.cfg-tabela input[type=datetime-local] { min-width: 200px; }
			.cfg-tabela select.cfg-perfis { height: auto !important; min-width: 260px; }
			.cfg-tabela select.cfg-perfis option:checked { background: #1a5ea8 linear-gradient(0deg, #1a5ea8 0%, #1a5ea8 100%); color: #ffffff; font-weight: 600; }
		</style>
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "matricula.asp"
		pagina_atual = "/app/mat_configuracao.asp"
		menu_principal = "Cadastro"
		sistema = "GEMUL"
		sistema_sigla = "MAT"
		modulo = "MAT"
		pagina = "Configurações"
		descricao_pagina = "Períodos de funcionamento (início e fim) das funcionalidades da matrícula."
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">

				<!--#include file=inc_lado_esquerdo.asp-->

                <div class="page-content-wrapper">

					<!--#include file=inc_cabecalho.asp-->

                    <!-- INICIO conteudo -->
					<!--#include file=mat_configuracao_cad.asp-->
					<!-- FIM conteudo -->

					<!--#include file=inc_rodape.asp-->

					<!--#include file=inc_modal_atalho.asp-->

                </div>
            </div>
        </div>
        <!-- FIm pagina -->

		<!--#include file=inc_menu_rapido.asp-->

		<!--#include file=inc_mensagem.asp-->

        <script src="js/vendors.bundle.js"></script>
        <script src="js/app.bundle.js"></script>
		<script src="js_app/mat_configuracao.js"></script>
        <script type="text/javascript">
        </script>
    </body>
</html>
