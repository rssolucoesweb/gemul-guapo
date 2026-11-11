function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){

		var frm = document.getElementById("frm");
		
		if (frm.cmbFichaDescritiva.value == "0"){
			alert("A Ficha Descritiva deve ser informada.");
			frm.cmbFichaDescritiva.focus();
			return false;
		}

		if (frm.cmbFichaDescritivaPergunta.value == "0"){
			alert("A Pergunta deve ser informada.");
			frm.cmbFichaDescritivaPergunta.focus();
			return false;
		}

		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descricao deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtValorInicial.value == "") {
			alert("O Valor Inicial deve ser informado !");
			frm.txtValorInicial.focus();
			return false;
		}
		
		if (frm.txtValorFinal.value == "") {
			alert("O Valor Final deve ser informado !");
			frm.txtValorFinal.focus();
			return false;
		}

		frm.action="sca_ficha_descritiva_conceito_pergunta_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}