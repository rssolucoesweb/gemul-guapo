	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtSenhaAtual.value == "") {
			alert("A senha atual deve ser informada !");
			frm.txtSenhaAtual.focus();
			return false;
		}
		if (frm.txtSenhaNova.value == "") {
			alert("A senha nova deve ser informada !");
			frm.txtSenhaNova.focus();
			return false;
		}
		if (frm.txtSenhaNovaRepetir.value == "") {
			alert("Confirmar nova senha deve ser informada!");
			frm.txtSenhaRepetir.focus();
			return false;
		}

		if (frm.txtSenhaAtual.value == frm.txtSenhaNova.value) {
			alert("Nova senha deve ser diferente da senha atual!");
			frm.txtSenhaNova.focus();
			return false;
		}
		if (frm.txtSenhaNovaRepetir.value !== frm.txtSenhaNova.value) {
			alert("Nova senha está diferente no campo confirmar nova senha!");
			frm.txtSenhaNova.focus();
			return false;
		}

		frm.action="alterar_Senha_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}