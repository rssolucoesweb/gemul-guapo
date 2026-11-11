	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbCriterio.value == "0") {
			alert("Critério deve ser informado!");
			frm.cmbCriterio.focus();
			return false;
		}
		
		if (frm.cmbTipoCalculo.value == "0") {
			alert("O tipo de cáculo deve ser informado!");
			frm.cmbTipoCalculo.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		if (frm.cmbTipoLancamento.value == "0") {
			alert("Tipo de lançamento deve ser informado !");
			frm.cmbTipoLancamento.focus();
			return false;
		}
		frm.action="sca_calculo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}