function resultadoConsulta(intCodigo) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = intCodigo;
    frm.submit();
}

function obterHorariosSelecionados() {
    return Array.prototype.slice.call(document.querySelectorAll('input[name="chkHorario"]:checked'));
}

function marcarTodosHorarios(marcar) {
    var horarios = document.querySelectorAll('input[name="chkHorario"]:not(:disabled)');
    for (var i = 0; i < horarios.length; i++) {
        horarios[i].checked = marcar;
    }
}

function marcarTurno(codTurno, marcar) {
    var horarios = document.querySelectorAll('input[name="chkHorario"][data-turno="' + codTurno + '"]:not(:disabled)');
    for (var i = 0; i < horarios.length; i++) {
        horarios[i].checked = marcar;
    }
}

function salvar(acao) {
    var frm = document.getElementById("frm");

    if (frm.txtAnoLetivo.value === "" || parseInt(frm.txtAnoLetivo.value, 10) <= 0) {
        alert("O Ano Letivo deve ser informado!");
        frm.txtAnoLetivo.focus();
        return false;
    }

    var semestre = document.getElementById("cmbSemestre");
    if (!semestre || semestre.value === "0") {
        alert("O Semestre deve ser informado!");
        if (semestre) semestre.focus();
        return false;
    }

    if (frm.cmbConsultorio.value === "0") {
        alert("O Consultório deve ser informado!");
        frm.cmbConsultorio.focus();
        return false;
    }

    if (frm.cmbProfissional.value === "0") {
        alert("O Profissional deve ser informado!");
        frm.cmbProfissional.focus();
        return false;
    }

    var horariosSelecionados = obterHorariosSelecionados();
    if (horariosSelecionados.length === 0) {
        alert("Selecione pelo menos um Horário de Atendimento!");
        return false;
    }

    if (acao === "A" && horariosSelecionados.length > 1) {
        alert("Para alterar um vínculo, selecione somente um Horário de Atendimento!");
        return false;
    }

    frm.action = "aee_atendimento_cod.asp?acao=" + acao;
    frm.submit();
    return true;
}
