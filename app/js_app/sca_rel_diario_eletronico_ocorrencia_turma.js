function resultadoConsulta(intCodigo) {
	var frm = document.getElementById("frm");

	frm.txtCodigo.value = intCodigo;
	frm.submit();
}

function salvar(acao) {
	var frm = document.getElementById("frm");

	// Mês obrigatório na inclusão e na alteração.
	if ((acao === "I" || acao === "A") && frm.txtMes.value == "") {
		alert("O mês deve ser informado!");
		frm.txtMes.focus();
		return false;
	}

	if (frm.txtObservacao.value == "") {
		alert("A observação deve ser informada!");
		frm.txtObservacao.focus();
		return false;
	}

	frm.action =
		"sca_rel_diario_eletronico_ocorrencia_turma_cod.asp?acao=" + acao;

	frm.submit();

	return true;
}