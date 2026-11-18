function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao) {

		var frm = document.getElementById("frm");

		// pega o conteúdo do summernote
		var texto_digitado = $('#txtTexto').summernote('code');

		// debug (opcional)
		// alert(texto_digitado);

		if (frm.txtDescricao.value == "") {
			alert("Descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}

		// remove tags vazias (<p><br></p>)
		if (texto_digitado === "" || texto_digitado === "<p><br></p>") {
			alert("O texto do documento deve ser informado!");
			return false;
		}

		// joga o HTML dentro do textarea antes de enviar
		frm.txtTexto.value = texto_digitado;

		frm.action = "mat_informativo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
