<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"
%>
<!DOCTYPE html>
<!--
GEMUL
AEE - Acompanhamento do Paciente
-->
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>GEMUL - Acompanhamento do Paciente</title>

    <!--#include file="includes/inc_verificaSessionApp.asp"-->
    <!--#include file="includes/inc_cnn.asp"-->
    <!--#include file="includes/inc_formatadata.asp"-->
    <!--#include file=inc_meta.asp-->
    <!--#include file=inc_css.asp-->
    <!--#include file=inc_ico.asp-->
</head>

<body class="nav-function-top header-function-fixed">
    <script src="js/configuracoes_pagina.js"></script>
    <script src="js/js_funcoes_gerais.js"></script>

    <%
    pagina_inicial_do_modulo = "aee.asp"
    pagina_atual = "/app/aee_acompanhamento.asp"
    menu_principal = "Atendimento"
    sistema = "GEMUL"
    sistema_sigla = "AEE"
    modulo = "AEE"
    pagina = "Atendimento do Paciente"
    descricao_pagina = "Registro dos atendimentos realizados ao paciente AEE, seja aluno da rede ou paciente externo, com possibilidade de anexar arquivos e links."
    mensagem_alerta_pagina = ""
    %>

    <div class="page-wrapper">
        <div class="page-inner">

            <!--#include file=inc_lado_esquerdo.asp-->

            <div class="page-content-wrapper">

                <!--#include file=inc_cabecalho.asp-->

                <!--#include file=aee_acompanhamento_cad.asp-->

                <!--#include file=inc_rodape.asp-->

                <!--#include file=inc_modal_atalho.asp-->

            </div>
        </div>
    </div>

    <!--#include file=inc_menu_rapido.asp-->
    <!--#include file=inc_mensagem.asp-->

    <script src="js/vendors.bundle.js"></script>
    <script src="js/app.bundle.js"></script>
    <script src="js/js_funcoes_gerais.js"></script>
    <script src="js_app/aee_acompanhamento.js"></script>
</body>
</html>
