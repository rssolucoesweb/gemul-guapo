	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		var frm = document.getElementById("frm");
		
		if (frm.cmbAtosLegais.value == "0") {
			alert("O Ato legal deve ser informado!");
			frm.cmbAtosLegais.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A renovação deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtDataRenovacao.value == "") {
			alert("Data de renovação deve ser informada!");
			frm.txtDataRenovacao.focus();
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
		frm.action="sca_atos_legais_renovacao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}