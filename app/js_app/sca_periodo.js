function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbCurso.value == "0") {
			alert("O Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}
		
		if (frm.txtSequencia.value == "") {
			alert("A Sequencia deve ser informada !");
			frm.txtSequencia.focus();
			return false;
		}
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="sca_Periodo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}