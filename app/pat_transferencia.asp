<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            GEMUL - Transferência de Patrimônio
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
    </head>
    <body class="nav-function-top header-function-fixed" style="">
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "patrimonio.asp"
		pagina_atual = "/app/pat_transferencia.asp"
		menu_principal = "Inicial"
		sistema = "GEMUL"
		sistema_sigla = "PAT"
		modulo = "PAT"
		pagina = "Transferência de Patrimônio"
		descricao_pagina = "Transferência de bens patrimoniais entre unidades (sede/escolas)."
		mensagem_alerta_pagina = ""
		%>
        <div class="page-wrapper">
            <div class="page-inner">
				<!--#include file=inc_lado_esquerdo.asp-->
                <div class="page-content-wrapper">
					<!--#include file=inc_cabecalho.asp-->
					<!--#include file=pat_transferencia_cad.asp-->
					<!--#include file=inc_rodape.asp-->
					<!--#include file=inc_modal_atalho.asp-->
                </div>
            </div>
        </div>
		<!--#include file=inc_menu_rapido.asp-->
		<!--#include file=inc_mensagem.asp-->
        <script src="js/vendors.bundle.js"></script>
        <script src="js/app.bundle.js"></script>
		<script src="js_app/pat_transferencia.js"></script>
        <script type="text/javascript"></script>
    </body>
</html>
