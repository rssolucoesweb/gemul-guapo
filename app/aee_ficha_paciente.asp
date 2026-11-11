<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>GEMUL - Ficha do Paciente AEE</title>
    <!--#include file="includes/inc_verificaSessionApp.asp"-->
    <!--#include file="includes/inc_cnn.asp"-->
    <!--#include file="inc_meta.asp"-->
    <!--#include file="inc_css.asp"-->
    <!--#include file="inc_ico.asp"-->
    <!--#include file="includes/inc_formatadata.asp"-->
    <!--#include file="includes/inc_replaceRequest.asp"-->
    <!--#include file="includes/inc_formataCPF.asp"-->
</head>
<body class="nav-function-top header-function-fixed">
    <script src="js/configuracoes_pagina.js"></script>
    <script src="js/js_funcoes_gerais.js"></script>
    <script src="js/jquery-2.1.3.min.js"></script>
    <script src="js/jquery.mask.min.js"></script>

    <%
    pagina_inicial_do_modulo = "aee.asp"
    pagina_atual = "/app/aee_ficha_paciente.asp"
    menu_principal = "Atendimento Educacional"
    sistema = "GEMUL"
    sistema_sigla = "AEE"
    modulo = "AEE"
    pagina = "Ficha do Paciente"
    descricao_pagina = "Cadastro e manutenção da ficha do paciente atendido pelo AEE."
    mensagem_alerta_pagina = ""
    %>

    <div class="page-wrapper">
        <div class="page-inner">
            <!--#include file="inc_lado_esquerdo.asp"-->
            <div class="page-content-wrapper">
                <!--#include file="inc_cabecalho.asp"-->
                <!--#include file="aee_ficha_paciente_cad.asp"-->
                <!--#include file="inc_rodape.asp"-->
                <!--#include file="inc_modal_atalho.asp"-->
            </div>
        </div>
    </div>

    <!--#include file="inc_menu_rapido.asp"-->
    <!--#include file="inc_mensagem.asp"-->

    <script src="js/vendors.bundle.js"></script>
    <script src="js/app.bundle.js"></script>
    <script src="js_app/aee_ficha_paciente.js?v=1"></script>
    <script>
        $(document).ready(function () {
            $("#txtCepresidencia").on("blur", function () {
                var cep = ($(this).val() || "").replace(/\D/g, "");
                if (cep.length !== 8 || $("#txtTipoPaciente").val() === "R") return;

                $.getJSON("https://viacep.com.br/ws/" + cep + "/json/")
                    .done(function (endereco) {
                        if (!endereco || endereco.erro) return;
                        $("#txtLogradouro").val($.trim(endereco.logradouro || ""));
                        $("#txtBairroaluno").val(endereco.bairro || "");
                        $("#txtComp_endereco").val(endereco.complemento || "");
                        $("#txtCidaderesidencia").val(endereco.localidade || "");
                    });
            });
        });
    </script>
</body>
</html>
