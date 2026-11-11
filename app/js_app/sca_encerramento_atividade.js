function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAno.value == "") {
			alert("O Ano letivo deve ser informado!");
			frm.txtAno.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.txtDataEncerramento.value == "") {
			alert("A Data de Encerramento deve ser informada!");
			frm.txtDataEncerramento.focus();
			return false;
		}
		
		frm.action="sca_encerramento_atividade_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}