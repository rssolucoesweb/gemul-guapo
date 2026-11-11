function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		var texto_digitado = $('#saveToLocal').summernote("code");
		var frm = document.getElementById("frm");
		if (frm.txtTitulo.value == "") {
			alert("Titulo deve ser informado!");
			frm.txtTitulo.focus();
			return false;
		}		

		//$('#txtTexto').val($('#saveToLocal').summernote("code"));
		if (texto_digitado == "") {
			alert("O texto do documento deve ser informado!");
			return false;
		}

		if (frm.cmbSituacao.value == "0") {
			alert("Situação deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		}
		frm.action="aee_criar_documento_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}