	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.cmbSexo.value == "0") {
			alert("O sexo deve ser informado!");
			frm.cmbSexo.focus();
			return false;
		}
		if (frm.cmbSituacao.value == "0") {
			alert("A situação deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		}
		
		
		frm.action="esp_categoria_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}