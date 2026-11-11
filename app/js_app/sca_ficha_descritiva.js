	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAnoLetivo.value == ""){
			alert("O Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0"){
			alert("O Semestre deve ser informado.");
			frm.cmbSemestre.focus();
			return false;
		}
	
		if (frm.txtDescricao.value == "") {
			alert("A Descrição da Avaliação deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
	
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="sca_ficha_descritiva_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}