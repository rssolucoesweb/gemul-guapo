function resultadoConsulta(intCodigo) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = intCodigo;
    frm.submit();
}

function salvar(acao) {
    var frm = document.getElementById("frm");

    if (frm.txtAnoLetivo.value == "") {
        alert("O ano letivo deve ser informado!");
        frm.txtAnoLetivo.focus();
        return false;
    }

    if (parseInt(frm.txtAnoLetivo.value, 10) < 2000 || parseInt(frm.txtAnoLetivo.value, 10) > 2100) {
        alert("Informe um ano letivo válido!");
        frm.txtAnoLetivo.focus();
        return false;
    }

    if (frm.cmbPeriodo.value == "0" || frm.cmbPeriodo.value == "") {
        alert("O período deve ser informado!");
        frm.cmbPeriodo.focus();
        return false;
    }
	
    if (frm.txtNomeConsultorio.value.trim() == "") {
        alert("O nome do consultório deve ser informado!");
        frm.txtNomeConsultorio.focus();
        return false;
    }

    if (frm.txtCapacidade.value == "" || parseInt(frm.txtCapacidade.value, 10) <= 0) {
        alert("A capacidade deve ser informada e maior que zero!");
        frm.txtCapacidade.focus();
        return false;
    }

    if (frm.cmbSituacao.value == "0" || frm.cmbSituacao.value == "") {
        alert("A situação deve ser informada!");
        frm.cmbSituacao.focus();
        return false;
    }

    frm.action = "aee_consultorio_cod.asp?acao=" + acao;
    frm.submit();
    return true;
}
