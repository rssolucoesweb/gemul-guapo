function resultadoConsulta(intCodigo) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = intCodigo;
    frm.action = "aee_horario.asp";
    frm.submit();
}

function salvar(acao) {
    var frm = document.getElementById("frm");

    if (frm.txtAnoLetivo.value == "") {
        alert("O ano letivo deve ser informado!");
        frm.txtAnoLetivo.focus();
        return false;
    }

    var anoLetivo = parseInt(frm.txtAnoLetivo.value, 10);
    if (isNaN(anoLetivo) || anoLetivo < 2000 || anoLetivo > 2100) {
        alert("Informe um ano letivo válido!");
        frm.txtAnoLetivo.focus();
        return false;
    }

    if (frm.cmbSemestre.value == "0" || frm.cmbSemestre.value == "") {
        alert("O semestre deve ser informado!");
        frm.cmbSemestre.focus();
        return false;
    }

    if (frm.cmbTurno.value == "0" || frm.cmbTurno.value == "") {
        alert("O turno deve ser informado!");
        frm.cmbTurno.focus();
        return false;
    }

    if (!validarNumero(frm.txtHoraInicio, 0, 23, "A hora inicial deve ser informada entre 0 e 23!")) return false;
    if (!validarNumero(frm.txtMinutoInicio, 0, 59, "O minuto inicial deve ser informado entre 0 e 59!")) return false;
    if (!validarNumero(frm.txtHoraTermino, 0, 23, "A hora de término deve ser informada entre 0 e 23!")) return false;
    if (!validarNumero(frm.txtMinutoTermino, 0, 59, "O minuto de término deve ser informado entre 0 e 59!")) return false;

    var inicio = (parseInt(frm.txtHoraInicio.value, 10) * 60) + parseInt(frm.txtMinutoInicio.value, 10);
    var termino = (parseInt(frm.txtHoraTermino.value, 10) * 60) + parseInt(frm.txtMinutoTermino.value, 10);

    if (termino <= inicio) {
        alert("O horário de término deve ser maior que o horário inicial!");
        frm.txtHoraTermino.focus();
        return false;
    }

    frm.action = "aee_horario_cod.asp?acao=" + acao;
    frm.submit();
    return true;
}

function validarNumero(campo, minimo, maximo, mensagem) {
    if (campo.value === "") {
        alert(mensagem);
        campo.focus();
        return false;
    }

    var valor = parseInt(campo.value, 10);
    if (isNaN(valor) || valor < minimo || valor > maximo) {
        alert(mensagem);
        campo.focus();
        return false;
    }

    return true;
}

function gerarHorariosPadrao() {
    var frm = document.getElementById("frm");

    if (frm.txtAnoLetivo.value == "") {
        alert("Informe o ano letivo para gerar os horários padrão!");
        frm.txtAnoLetivo.focus();
        return false;
    }

    var anoLetivo = parseInt(frm.txtAnoLetivo.value, 10);
    if (isNaN(anoLetivo) || anoLetivo < 2000 || anoLetivo > 2100) {
        alert("Informe um ano letivo válido!");
        frm.txtAnoLetivo.focus();
        return false;
    }

    if (frm.cmbSemestre.value == "0" || frm.cmbSemestre.value == "") {
        alert("Informe o semestre para gerar os horários padrão!");
        frm.cmbSemestre.focus();
        return false;
    }

    if (!confirm("Deseja cadastrar automaticamente os 8 horários padrão do Matutino e Vespertino para o ano e semestre informados?")) {
        return false;
    }

    frm.action = "aee_horario_cod.asp?acao=P";
    frm.submit();
    return true;
}
