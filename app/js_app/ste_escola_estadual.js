//Transporte > Cadastro > Escola estadual
function resultadoConsulta(codigo) {
	var frm = document.getElementById("frm");
	frm.txtCodigo.value = codigo;
	frm.action = "ste_escola_estadual.asp";
	frm.submit();
}

function eeBuscar() {
	var frm = document.getElementById("frm");
	frm.txtCodigo.value = "";
	frm.action = "ste_escola_estadual.asp";
	frm.submit();
}

function eeSoNumero(e) {
	var k = e.which || e.keyCode;
	return k < 32 || (k >= 48 && k <= 57);
}

function eeMascaraCep(campo) {
	var v = campo.value.replace(/\D/g, "").substring(0, 8);
	if (v.length > 5) v = v.substring(0, 5) + "-" + v.substring(5);
	campo.value = v;
}

function salvar(acao) {
	var frm = document.getElementById("frm");

	if (acao == "E") {
		if (!confirm("Excluir esta escola estadual?")) return false;
	} else {
		if (acao == "I") {
			var cod = frm.txtCodigoNovo.value.replace(/\D/g, "");
			if (cod == "" || cod == "0") {
				alert("Informe o código da escola (somente números).");
				frm.txtCodigoNovo.focus();
				return false;
			}
			if (parseFloat(cod) > 2147483647) {
				alert("Código inválido.");
				frm.txtCodigoNovo.focus();
				return false;
			}
		}
		var campos = [
			["txtNome", "o nome da escola"],
			["txtEndereco", "o endereço"],
			["txtBairro", "o bairro"],
			["txtMunicipio", "o município"]
		];
		for (var i = 0; i < campos.length; i++) {
			var c = frm[campos[i][0]];
			if (c.value.replace(/^\s+|\s+$/g, "") == "") {
				alert("Informe " + campos[i][1] + ".");
				c.focus();
				return false;
			}
		}
		if (frm.txtCep.value.replace(/\D/g, "").length != 8) {
			alert("Informe o CEP com 8 números.");
			frm.txtCep.focus();
			return false;
		}
	}
	frm.action = "ste_escola_estadual_cod.asp?acao=" + acao;
	frm.submit();
	return true;
}
