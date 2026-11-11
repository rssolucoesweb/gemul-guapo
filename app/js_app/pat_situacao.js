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
		if (frm.cmbSituacao.value == "0") {
			alert("A situação do cadastro deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		}
		frm.action="pat_situacao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
