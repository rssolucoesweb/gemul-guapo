	function conferirLocalizado(codItem){

		window.location = "pat_inventario_itens_cod.asp?acao=ConferirLocalizado&cod_item=" + codItem;
		return true;
	}

	function conferirNaoLocalizado(codItem){

		if (!confirm("Confirma que este bem NÃO foi localizado?")) return false;
		window.location = "pat_inventario_itens_cod.asp?acao=ConferirNaoLocalizado&cod_item=" + codItem;
		return true;
	}

	function conferirDivergencia(codItem){

		var obs = prompt("Descreva a divergência encontrada (local diferente, responsável diferente, estado de conservação diferente, sem etiqueta, etc.):");
		if (obs == null) return false;
		if (obs == "") {
			alert("A descrição da divergência deve ser informada !");
			return false;
		}

		var frmDiv = document.createElement("form");
		frmDiv.method = "post";
		frmDiv.action = "pat_inventario_itens_cod.asp?acao=ConferirDivergencia";

		var campoItem = document.createElement("input");
		campoItem.type = "hidden";
		campoItem.name = "cod_item";
		campoItem.value = codItem;
		frmDiv.appendChild(campoItem);

		var campoObs = document.createElement("input");
		campoObs.type = "hidden";
		campoObs.name = "observacao";
		campoObs.value = obs;
		frmDiv.appendChild(campoObs);

		document.body.appendChild(frmDiv);
		frmDiv.submit();
		return true;
	}

	function adicionarNaoCadastrado(){

		var frm = document.getElementById("frmNaoCadastrado");

		if (frm.descricao_encontrado.value == "") {
			alert("Descreva o item encontrado !");
			frm.descricao_encontrado.focus();
			return false;
		}
		frm.submit();
		return true;
	}
