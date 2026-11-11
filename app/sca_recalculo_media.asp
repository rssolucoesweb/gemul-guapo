<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
response.ContentType = "text/html"
response.Expires = 0
Server.ScriptTimeOut = 5000
Response.Buffer = false
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>GEMUL - Recálculo de Média por Turma</title>
    <!--#include file="includes/inc_verificaSessionApp.asp"-->
    <!--#include file="includes/inc_cnn.asp"-->
    <!--#include file=inc_meta.asp-->
    <!--#include file=inc_css.asp-->
    <!--#include file=inc_ico.asp-->
    <!--#include file="../includes/inc_formatadata.asp"-->
    <!--#include file="includes/inc_aguarde.asp"-->
</head>
<body class="nav-function-top header-function-fixed">
<script src="js/configuracoes_pagina.js"></script>
<%
pagina_inicial_do_modulo = "academico.asp"
pagina_atual = "/app/sca_recalculo_media.asp"
menu_principal = "Inicial"
sistema = "GEMUL"
sistema_sigla = "SCA"
modulo = "SCA"
pagina = "Recálculo de Média por Turma"
descricao_pagina = "Recalcula as médias dos alunos selecionados para uma disciplina ou para todas as disciplinas da turma."
mensagem_alerta_pagina = ""
%>
<div class="page-wrapper">
    <div class="page-inner">
        <!--#include file=inc_lado_esquerdo.asp-->
        <div class="page-content-wrapper">
            <!--#include file=inc_cabecalho.asp-->
            <!--#include file=sca_recalculo_media_cad.asp-->
            <!--#include file=inc_rodape.asp-->
            <!--#include file=inc_modal_atalho.asp-->
        </div>
    </div>
</div>
<!--#include file=inc_menu_rapido.asp-->
<!--#include file=inc_mensagem.asp-->
<script src="js/vendors.bundle.js"></script>
<script src="js/app.bundle.js"></script>
<script>
function marcarTodos(origem) {
    var itens = document.querySelectorAll('input[name="chkAluno"]');
    for (var i = 0; i < itens.length; i++) {
        itens[i].checked = origem.checked;
    }
    atualizarQuantidade();
}

function atualizarQuantidade() {
    var marcados = document.querySelectorAll('input[name="chkAluno"]:checked').length;
    var el = document.getElementById("qtdSelecionados");
    if (el) el.innerHTML = marcados;
}

var recalculoEmAndamento = false;

function recalcularMedia() {

    // Impede duplo clique / segunda execução
    if (recalculoEmAndamento) {
        return false;
    }

    var frm = document.getElementById("frm");
    var turma = document.getElementById("cmbTurma") || 
                document.getElementById("cmbTurmaProfessor");

    var semestre = document.getElementById("cmbSemestre");
    var selecionados = document.querySelectorAll(
        'input[name="chkAluno"]:checked'
    );

    if (semestre && semestre.value == "0") {
        alert("O Semestre deve ser informado!");
        semestre.focus();
        return false;
    }

    if (!turma || turma.value == "" || turma.value == "0") {
        alert("A Turma deve ser informada!");

        if (turma) {
            turma.focus();
        }

        return false;
    }

    if (selecionados.length == 0) {
        alert("Selecione pelo menos um aluno para recalcular.");
        return false;
    }

    var disciplina =
        document.getElementById("cmbDisciplinaTurma") ||
        document.getElementById("cmbDisciplinaDoProfessor");

    var textoDisciplina = "TODAS AS DISCIPLINAS";

    if (
        disciplina &&
        disciplina.value != "" &&
        disciplina.value != "0"
    ) {
        textoDisciplina =
            disciplina.options[disciplina.selectedIndex].text;
    }

    var msg =
        "Confirma o recálculo de média para " +
        selecionados.length +
        " aluno(s)?\n\n";

    msg += "Disciplina: " + textoDisciplina + "\n\n";

    msg +=
        "Os campos calculados automaticamente serão " +
        "recalculados conforme o critério de avaliação.";

    if (!confirm(msg)) {
        return false;
    }


    // Impede uma segunda execução
	recalculoEmAndamento = true;

	// Bloqueia os dois botões
	var btn1 = document.getElementById("btnRecalcular");
	var btn2 = document.getElementById("btnRecalcularRodape");

	if (btn1) {
		btn1.disabled = true;
		btn1.innerHTML = "Recalculando...";
	}

	if (btn2) {
		btn2.disabled = true;
		btn2.innerHTML = "Recalculando...";
	}

	// IMPORTANTE:
	// Não desabilitar os chkAluno.
	// Campos disabled não são enviados pelo formulário.

	frm.action = "sca_recalculo_media_cod.asp";
	frm.submit();

	return false;
}
</script>
</body>
</html>
