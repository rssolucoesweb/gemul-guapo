function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição (Uso interno) deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDescAbreviada.value == "") {
			alert("A Descrição (Horário) deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		if (frm.txtDescHistorico.value == "") {
			alert("A Descrição (Histórico) Abreviada deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		if (frm.cmbSituacao.value == "0") {
			alert("Sirtuação deve ser selecionada!");
			frm.cmbSituacao.focus();
			return false;
		}

		frm.action="sca_disciplina_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}