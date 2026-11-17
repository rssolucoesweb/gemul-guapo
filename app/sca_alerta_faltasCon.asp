<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"
%>
<!DOCTYPE html>
<!--
GEMUL
Version: 20.1.0
Desenvolvedor: Sérgio Borges
-->
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>GEMUL - Alerta de faltas</title>

    <!--#include file="includes/inc_verificaSessionApp.asp"-->
    <!--#include file="includes/inc_cnn.asp"-->
    <!--#include file="includes/inc_formatadata.asp"-->
    <!--#include file="includes/inc_sqlAlunoTurmaTodasSituacoes.asp"-->
    <!--#include file=inc_meta.asp-->
    <!--#include file=inc_css.asp-->
    <!--#include file=inc_ico.asp-->
	<!--#include file=includes/inc_videoTutorial.asp-->
</head>

<body class="nav-function-top header-function-fixed">
    <script src="js/configuracoes_pagina.js"></script>

    <%
    pagina_inicial_do_modulo = "academico.asp"
    pagina_atual = "/app/sca_alerta_faltasCon.asp"
    menu_principal = "Relatórios"
    sistema = "GEMUL"
    sistema_sigla = "SCA"
    modulo = "SCA"
    pagina = "Alerta de faltas"
    descricao_pagina = "Acompanhamento da frequência e emissão de alerta de faltas."
    mensagem_alerta_pagina = ""
    %>

    <div class="page-wrapper">
        <div class="page-inner">

            <!--#include file=inc_lado_esquerdo.asp-->

            <div class="page-content-wrapper">

                <!--#include file=inc_cabecalho.asp-->

                <!-- INICIO conteudo -->
                <!--#include file=sca_alerta_faltas_con.asp-->
                <!-- FIM conteudo -->

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

    <script type="text/javascript">
        function MarcaTodosAlunos(valor) {
            var form = document.getElementById("frm");

            for (var i = 0; i < form.elements.length; i++) {
                if (form.elements[i].type === "checkbox" && form.elements[i].name === "chkAluno") {
                    form.elements[i].checked = valor;
                }
            }
        }

        function gerar() {
            var frm = document.getElementById("frm");
            var totalMarcados = 0;

            if (!frm.cmbTurma || frm.cmbTurma.value === "" || frm.cmbTurma.value === "0") {
                alert("A turma deve ser informada!");
                return false;
            }

            for (var i = 0; i < frm.elements.length; i++) {
                if (
                    frm.elements[i].type === "checkbox" &&
                    frm.elements[i].name === "chkAluno" &&
                    frm.elements[i].checked
                ) {
                    totalMarcados++;
                }
            }

            if (totalMarcados === 0) {
                alert("Selecione pelo menos um aluno para gerar o alerta de faltas.");
                return false;
            }

            frm.target = "_blank";
            frm.action = "sca_alerta_faltas_rel.asp";
            frm.submit();

            frm.target = "";
            frm.action = "sca_alerta_faltasCon.asp";

            return true;
        }
    </script>
</body>
</html>
