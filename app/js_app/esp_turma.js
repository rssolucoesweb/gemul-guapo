	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.ano_letivo.value == "") {
			alert("O ano letivo deve ser informado!");
			frm.ano_letivo.focus();
			return false;
		}
		if (frm.nome.value == "") {
			alert("O nome da turma deve ser informada!");
			frm.nome.focus();
			return false;
		}
		if (frm.cmbModalidade.value == "0") {
			alert("A modalidade deve ser informada!");
			frm.cmbModalidade.focus();
			return false;
		}
		if (frm.cmbCategoria.value == "0") {
			alert("A categoria deve ser informada!");
			frm.cmbCategoria.focus();
			return false;
		}
		if (frm.cmbTurno.value == "0") {
			alert("O turno deve ser informado!");
			frm.cmbTurno.focus();
			return false;
		}
		if (frm.capacidade.value == "") {
			alert("A capacidade deve ser informada!");
			frm.capacidade.focus();
			return false;
		}
		if (frm.cmbSituacao.value == "0") {
			alert("A situação deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		}
		
		
		frm.action="esp_turma_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}