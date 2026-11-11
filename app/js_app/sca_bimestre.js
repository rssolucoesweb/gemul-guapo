	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtDataInicio.value == "") {
			alert("O Período inicial deve ser informado!");
			frm.txtDataInicio.focus();
			return false;
		}
		if (frm.txtDataFim.value == "") {
			alert("O Período final deve ser informado!");
			frm.txtDataFim.focus();
			return false;
		}
		
		frm.action="sca_bimestre_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}