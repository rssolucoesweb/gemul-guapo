function resultadoConsulta(intCodigo) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = intCodigo;
    frm.submit();
}

function salvar(acao) {
    var frm = document.getElementById("frm");

    if (frm.cmbColaborador.value == "0" || frm.cmbColaborador.value == "") {
        alert("O colaborador deve ser informado!");
        frm.cmbColaborador.focus();
        return false;
    }

    if (frm.cmbEspecialidade.value == "0" || frm.cmbEspecialidade.value == "") {
        alert("A especialidade deve ser informada!");
        frm.cmbEspecialidade.focus();
        return false;
    }

    frm.action = "aee_profissional_cod.asp?acao=" + acao;
    frm.submit();
    return true;
}
