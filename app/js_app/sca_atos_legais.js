	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		var frm = document.getElementById("frm");
		
		if (frm.cmbAtos.value == "0") {
			alert("Tipo deve ser informado!");
			frm.cmbAtos.focus();
			return false;
		}
		if (frm.cmbCurso.value == "0") {
			alert("Curso deve ser informado!");
			frm.cmbCurso.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtDataAprovacao.value == "") {
			alert("Data de aprovação deve ser informada!");
			frm.txtDataAprovacao.focus();
			return false;
		}
		if (frm.txtDataVencimento.value == "") {
			alert("Data de vencimento deve ser informada!");
			frm.txtDataVencimento.focus();
			return false;
		}
		if (frm.txtDataInicioVingencia.value == "") {
			alert("Data do início da vigência deve ser informada!");
			frm.txtDataInicioVingencia.focus();
			return false;
		}
		frm.action="sca_atos_legais_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}