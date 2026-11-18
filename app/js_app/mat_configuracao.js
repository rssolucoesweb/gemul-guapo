	//Matrícula > Configurações: períodos de funcionamento
	function limparPeriodo(cod){
		var ini = document.getElementById("txtInicio_" + cod);
		var fim = document.getElementById("txtFim_" + cod);
		if (ini) ini.value = "";
		if (fim) fim.value = "";
	}

	function salvar(){
		var frm = document.getElementById("frm");
		var campos = frm.querySelectorAll("input[name='txtFuncionalidade']");
		for (var i = 0; i < campos.length; i++) {
			var cod = campos[i].value;
			var ini = document.getElementById("txtInicio_" + cod);
			var fim = document.getElementById("txtFim_" + cod);
			var desc = ini.getAttribute("data-desc");
			//valor do datetime-local: aaaa-mm-ddThh:mm (comparação como texto funciona)
			if (ini.value != "" && fim.value != "" && fim.value < ini.value) {
				alert(desc + ":\nA data de fim deve ser maior ou igual à data de início.");
				fim.focus();
				return false;
			}
		}
		if (!confirm("Confirma a gravação dos períodos de funcionamento?"))
			return false;

		var btn = document.getElementById("btnSalvar");
		if (btn) {
			btn.disabled = true;
			btn.innerHTML = "Gravando, aguarde...";
		}
		frm.action = "mat_configuracao_cod.asp";
		frm.submit();
		return true;
	}
