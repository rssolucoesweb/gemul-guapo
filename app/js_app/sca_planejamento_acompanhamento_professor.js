// GEMUL - Acompanhamento do planejamento do professor
$(document).ready(function() {

    $("#btnReplicar").click(function(event) {

        event.preventDefault();

        var checkboxes = document.getElementsByName("chkTurma");
        var contChecked = 0;

        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].checked) {
                contChecked++;
            }
        }

        if (contChecked === 0) {
            alert("Nenhuma turma foi selecionada.");
            return;
        }

        $("#btnReplicar").attr("disabled", true);
        $("#btnReplicar").html("Aguarde... Replicando a aula...");

        replicar($('#codigoPlanejamentoProf').val());
    });

});

function abrePlanejamento(aula, cod_curso, curso, cod_periodo, periodo, cod_disciplina, disciplina, cod_turma, turma, bolAulaExtra, dataAula) {
    var frm = document.getElementById("frm");
    frm.txtCodCurso.value = cod_curso;
    frm.txtCurso.value = curso;
    frm.txtCodPeriodo.value = cod_periodo;
    frm.txtPeriodo.value = periodo;
    frm.txtCodDisciplina.value = cod_disciplina;
    frm.txtDisciplina.value = disciplina;
    frm.txtCodTurma.value = cod_turma;
    frm.txtTurma.value = turma;
    frm.bolAulaExtra.value = bolAulaExtra;
    frm.dataAula.value = dataAula;

    $('.form-control').removeAttr('disabled');
    document.getElementById('frm').action = 'sca_planejamento_professor_aula.asp?retorno=sca_planejamento_acompanhamento_professor.asp?cmbMes=' + $("#cmbMes").val() + '&aula=' + aula;
    document.getElementById('frm').submit();
}

function validarTurma(cod_disciplina, codTurma, aulas) {

    if (!confirm("Confirma a validação de TODOS os planejamentos dessa Turma?")) {
        return;
    }

    var frm = document.getElementById("frm");
    $('.form-control').removeAttr('disabled');

    document.getElementById('frm').action = 'sca_planejamento_acompanhamento_professor_cod.asp?acao=VT&cod_disciplina=' + cod_disciplina + '&codTurma=' + codTurma + '&aulas=' + aulas;
    document.getElementById('frm').submit();
}

function desvalidarTurma(cod_disciplina, codTurma, aulas) {

    if (!confirm("Confirma a desvalidação de TODOS os planejamentos dessa Turma?")) {
        return;
    }

    var frm = document.getElementById("frm");
    $('.form-control').removeAttr('disabled');

    document.getElementById('frm').action = 'sca_planejamento_acompanhamento_professor_cod.asp?acao=DT&cod_disciplina=' + cod_disciplina + '&codTurma=' + codTurma + '&aulas=' + aulas;
    document.getElementById('frm').submit();
}

function abreModal(aula, cod_curso, curso, cod_periodo, periodo, cod_disciplina, disciplina, cod_turno, cod_turma, turma, codigoPlanejamentoProf, bolAulaExtra, dataAulaExtra, dataAula) {

    if (codigoPlanejamentoProf !== "0") {

        $('#modalReplicarAula').modal('show');
        $('#codigoPlanejamentoProf').val(codigoPlanejamentoProf);

        // Mantém os dados da aula atual no formulário para as ações do modal.
        var frm = document.getElementById("frm");
        frm.txtCodCurso.value = cod_curso;
        frm.txtCurso.value = curso;
        frm.txtCodPeriodo.value = cod_periodo;
        frm.txtPeriodo.value = periodo;
        frm.txtCodDisciplina.value = cod_disciplina;
        frm.txtDisciplina.value = disciplina;
        frm.txtCodTurma.value = cod_turma;
        frm.txtTurma.value = turma;
        frm.bolAulaExtra.value = bolAulaExtra;
        frm.dataAula.value = dataAula;

        if (bolAulaExtra) {
            $('.spanAulaExtra').html("sábado letivo ");
            $('.numAula').html(dataAulaExtra);
            $('#btnReplicarSemana').prop('disabled', true);
            $('#textoReplicarSemana').html('Esta opção está disponível somente para aulas regulares.');
            $('#dataReplicarDia').val('').prop('disabled', true);
            $('#btnReplicarDia').prop('disabled', true);
            $('#textoReplicarDia').html('Esta opção está disponível somente para aulas regulares.');
        } else {
            $('.spanAulaExtra').html("");
            $('.numAula').html(aula);
            $('#btnReplicarSemana').prop('disabled', false);
            $('#textoReplicarSemana').html('O planejamento será replicado para as próximas aulas desta disciplina e turma, até sexta-feira.');
            $('#dataReplicarDia').val('').prop('disabled', false);
            $('#btnReplicarDia').prop('disabled', false);
            $('#textoReplicarDia').html('Escolha uma data posterior para replicar o planejamento somente para aquela aula.');

            // Impede a escolha da própria aula ou de uma data anterior.
            var partesDataOrigem = dataAula.split('/');
            if (partesDataOrigem.length === 3) {
                var dataOrigemIso = partesDataOrigem[2] + '-' + partesDataOrigem[1] + '-' + partesDataOrigem[0];
                var proximoDia = new Date(dataOrigemIso + 'T00:00:00');
                proximoDia.setDate(proximoDia.getDate() + 1);
                $('#dataReplicarDia').attr('min',
                    proximoDia.getFullYear() + '-' +
                    ('0' + (proximoDia.getMonth() + 1)).slice(-2) + '-' +
                    ('0' + proximoDia.getDate()).slice(-2)
                );
            }
        }

        $('#divListaTurmas').html('carregando turmas...');

        $.post("sca_planejamento_acompanhamento_professor_cod.asp", {
            txtAnoLetivo: $("#txtHiddenAnoLetivo").val(),
            txtSemestre: $("#txtSemestre").val(),
            codPeriodo: cod_periodo,
            txtCodProfessor: $("#txtCodProfessor").val(),
            cod_disciplina: cod_disciplina,
            cod_turno: cod_turno,
            codTurma: cod_turma,
            aula: aula,
            bolAulaExtra: bolAulaExtra,
            dataAula: dataAula,
            acao: 'listarTurmasDisciplinaProfessor'
        })
        .done(function(data) {
            $("#divListaTurmas").html(data);
        })
        .fail(function() {
            toastr.error("Ocorreu um erro");
        });

    } else {
        abrePlanejamento(aula, cod_curso, curso, cod_periodo, periodo, cod_disciplina, disciplina, cod_turma, turma, bolAulaExtra, dataAula);
        return;
    }

    // off/on evita acumular eventos cada vez que o modal é aberto.
    $("#btnVisualizarPlanejamento").off("click").on("click", function(event) {
        event.preventDefault();
        abrePlanejamento(aula, cod_curso, curso, cod_periodo, periodo, cod_disciplina, disciplina, cod_turma, turma, bolAulaExtra, dataAula);
    });

    $("#btnReplicarSemana").off("click").on("click", function(event) {
        event.preventDefault();

        if (bolAulaExtra) {
            return;
        }

        replicarSemana(
            codigoPlanejamentoProf,
            aula,
            dataAula,
            cod_periodo,
            cod_disciplina,
            cod_turno,
            cod_turma
        );
    });

    $("#btnReplicarDia").off("click").on("click", function(event) {
        event.preventDefault();

        if (bolAulaExtra) {
            return;
        }

        replicarDia(codigoPlanejamentoProf, dataAula);
    });
}

function replicar(codigoPlanejamentoProf) {
    document.getElementById('frm').action = 'sca_planejamento_acompanhamento_professor_cod.asp?acao=R&codigoPlanejamentoProf=' + codigoPlanejamentoProf;
    document.getElementById('frm').submit();
}

function replicarSemana(codigoPlanejamentoProf, aula, dataAula, codPeriodo, codDisciplina, codTurno, codTurma) {

    if (!confirm("Confirma a replicação do planejamento desta aula para as próximas aulas da mesma disciplina e turma até sexta-feira?\n\nAulas que já possuem planejamento não serão alteradas.")) {
        return;
    }

    var botao = $("#btnReplicarSemana");
    var textoOriginal = botao.html();

    botao.prop("disabled", true);
    botao.html("Aguarde... Replicando...");

    $.post("sca_planejamento_acompanhamento_professor_cod.asp", {
        acao: "replicarSemana",
        codigoPlanejamentoProf: codigoPlanejamentoProf,
        aula: aula,
        dataAula: dataAula,
        txtAnoLetivo: $("#txtHiddenAnoLetivo").val(),
        txtSemestre: $("#txtSemestre").val(),
        codPeriodo: codPeriodo,
        cod_disciplina: codDisciplina,
        cod_turno: codTurno,
        codTurma: codTurma,
        txtCodProfessor: $("#txtCodProfessor").val()
    })
    .done(function(data) {

        var retorno = $.trim(data).split("|");

        if (retorno[0] === "OK") {

            var encontradas = retorno[1] || "0";
            var replicadas = retorno[2] || "0";
            var ignoradas = retorno[3] || "0";

            alert(
                "Replicação concluída.\n\n" +
                "Aulas encontradas na semana: " + encontradas + "\n" +
                "Aulas replicadas: " + replicadas + "\n" +
                "Aulas ignoradas por já possuírem planejamento: " + ignoradas
            );

            window.location.reload();

        } else {
            var mensagem = retorno.length > 1 ? retorno.slice(1).join("|") : "Não foi possível replicar a aula para a semana.";
            toastr.error(mensagem);
            botao.prop("disabled", false);
            botao.html(textoOriginal);
        }
    })
    .fail(function() {
        toastr.error("Ocorreu um erro ao replicar a aula para a semana.");
        botao.prop("disabled", false);
        botao.html(textoOriginal);
    });
}

function replicarDia(codigoPlanejamentoProf, dataAulaOrigem) {

    var dataAulaDestino = $.trim($("#dataReplicarDia").val());

    if (dataAulaDestino === "") {
        toastr.warning("Selecione o dia para o qual o planejamento será replicado.");
        $("#dataReplicarDia").focus();
        return;
    }

    var partesDestino = dataAulaDestino.split("-");
    var dataDestinoTela = partesDestino.length === 3
        ? partesDestino[2] + "/" + partesDestino[1] + "/" + partesDestino[0]
        : dataAulaDestino;

    if (!confirm(
        "Confirma a replicação do planejamento desta aula para o dia " + dataDestinoTela + "?\n\n" +
        "A data precisa ser um dia letivo com aula desta disciplina para a turma."
    )) {
        return;
    }

    var botao = $("#btnReplicarDia");
    var textoOriginal = botao.html();

    botao.prop("disabled", true).html("Aguarde... Replicando...");

    $.post("sca_planejamento_acompanhamento_professor_cod.asp", {
        acao: "replicarDia",
        codigoPlanejamentoProf: codigoPlanejamentoProf,
        dataAula: dataAulaOrigem,
        dataAulaDestino: dataAulaDestino
    })
    .done(function(data) {
        var retorno = $.trim(data).split("|");

        if (retorno[0] === "OK") {
            alert(
                "Replicação concluída com sucesso.\n\n" +
                "Aula de destino: " + (retorno[1] || "") + "\n" +
                "Data: " + (retorno[2] || dataDestinoTela)
            );
            window.location.reload();
        } else {
            var mensagem = retorno.length > 1
                ? retorno.slice(1).join("|")
                : "Não foi possível replicar a aula para o dia escolhido.";
            toastr.error(mensagem);
            botao.prop("disabled", false).html(textoOriginal);
        }
    })
    .fail(function() {
        toastr.error("Ocorreu um erro ao replicar a aula para o dia escolhido.");
        botao.prop("disabled", false).html(textoOriginal);
    });
}
