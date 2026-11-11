function resultadoConsulta(intCodigo) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = intCodigo;
    frm.submit();
}

function salvar(acao) {
    var frm = document.getElementById("frm");

    if (frm.txtCodigo.value == "" || parseInt(frm.txtCodigo.value, 10) <= 0) {
        alert("O código da especialidade deve ser informado!");
        frm.txtCodigo.focus();
        return false;
    }

    if (frm.txtDescricao.value.trim() == "") {
        alert("A descrição deve ser informada!");
        frm.txtDescricao.focus();
        return false;
    }

    if (frm.cmbSituacao.value == "0" || frm.cmbSituacao.value == "") {
        alert("A situação deve ser informada!");
        frm.cmbSituacao.focus();
        return false;
    }

    frm.action = "aee_especialidade_cod.asp?acao=" + acao;
    frm.submit();
    return true;
}
