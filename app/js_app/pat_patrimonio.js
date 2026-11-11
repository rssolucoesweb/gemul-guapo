	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição do bem deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.cmbTipoBem.value == "") {
			alert("O Tipo de Bem deve ser informado !");
			frm.cmbTipoBem.focus();
			return false;
		}
		if (frm.cmbEmpresa.value == "") {
			alert("A Unidade (Sede/Escola) deve ser informada !");
			frm.cmbEmpresa.focus();
			return false;
		}
		if (frm.cmbLocal.value == "") {
			alert("O Local deve ser informado !");
			frm.cmbLocal.focus();
			return false;
		}
		if (frm.cmbSituacao.value == "") {
			alert("A Situação do bem deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		}
		if (acao == "I" && frm.txtQuantidade) {
			var qtd = parseInt(frm.txtQuantidade.value, 10);
			if (!qtd || qtd < 1) {
				alert("A Quantidade deve ser pelo menos 1 !");
				frm.txtQuantidade.focus();
				return false;
			}
			var seriesTexto = frm.txtNumerosSerieLote.value.replace(/\r\n/g, "\n").trim();
			if (seriesTexto !== "") {
				var linhas = seriesTexto.split("\n");
				if (linhas.length !== qtd) {
					alert("A quantidade de linhas em 'Números de Série' (" + linhas.length + ") deve ser igual à Quantidade informada (" + qtd + ").");
					frm.txtNumerosSerieLote.focus();
					return false;
				}
			}
		}
		frm.action="pat_patrimonio_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
