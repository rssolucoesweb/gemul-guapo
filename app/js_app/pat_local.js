	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbEmpresa.value == "") {
			alert("A Unidade (Sede/Escola) deve ser informada !");
			frm.cmbEmpresa.focus();
			return false;
		}
		if (frm.cmbTipoLocal.value == "") {
			alert("O Tipo de Local deve ser informado !");
			frm.cmbTipoLocal.focus();
			return false;
		}
		if (frm.txtDescricao.value == "") {
			alert("A Descrição do local deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.cmbSituacao.value == "0") {
			alert("A situação deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		}
		frm.action="pat_local_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
