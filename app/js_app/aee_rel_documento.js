function resultadoConsulta(intCodigo) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = intCodigo;
    frm.action = "aee_rel_documento.asp";
    frm.submit();
    return false;
}

function buscarPaciente() {
    var frm = document.getElementById("frm");
    var busca = (frm.txtBuscaPaciente.value || "").trim();
    if (busca === "") {
        alert("Informe a matrícula do aluno da rede ou o CPF do paciente externo.");
        frm.txtBuscaPaciente.focus();
        return false;
    }
    frm.txtCodigo.value = "0";
    frm.txtCodFichaPaciente.value = "";
    frm.action = "aee_rel_documento.asp";
    frm.submit();
    return false;
}

function abrirConsultaPaciente() {
    var url = "aee_ficha_paciente_con.asp?modo=selecao&consultar=S";
    var tipo = document.getElementById("cmbTipoPacienteBusca");
    if (tipo && tipo.value) url += "&cmbTipoPaciente=" + encodeURIComponent(tipo.value);
    window.open(url, "consultaPacienteAEE", "width=1100,height=720,scrollbars=yes,resizable=yes");
    return false;
}

function selecionarPacienteAEE(codFicha, tipo, matricula, cpf, nome) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = "0";
    frm.txtCodFichaPaciente.value = codFicha;
    frm.txtBuscaPaciente.value = (tipo === "R" ? matricula : cpf) || "";
    frm.action = "aee_rel_documento.asp";
    frm.submit();
}

function gerar(){
	var frm = document.getElementById("frm");
	frm.action = "aee_rel_documento_rel.asp";
	frm.submit();
	return true;	
}
