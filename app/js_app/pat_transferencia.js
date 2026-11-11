	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbEmpresaOrigem.value == "") {
			alert("A Unidade de Origem deve ser informada !");
			frm.cmbEmpresaOrigem.focus();
			return false;
		}
		if (frm.cmbEmpresaDestino.value == "") {
			alert("A Unidade de Destino deve ser informada !");
			frm.cmbEmpresaDestino.focus();
			return false;
		}
		if (frm.cmbEmpresaOrigem.value == frm.cmbEmpresaDestino.value) {
			alert("A Unidade de Destino deve ser diferente da Unidade de Origem !");
			frm.cmbEmpresaDestino.focus();
			return false;
		}
		frm.action="pat_transferencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function marcarTodos(chkCabecalho){

		var checkboxes = document.querySelectorAll('input[name="chkBem"]');
		for (var i = 0; i < checkboxes.length; i++) {
			// só marca/desmarca as linhas visíveis (respeita o filtro aplicado)
			var linha = checkboxes[i].closest("tr");
			if (linha && linha.style.display !== "none") {
				checkboxes[i].checked = chkCabecalho.checked;
			}
		}
	}

	function filtrarListaBens(){

		var filtro = document.getElementById("txtFiltroLista").value.toUpperCase();
		var tabela = document.getElementById("tabelaBensDisponiveis");
		if (!tabela) return;
		var linhas = tabela.getElementsByTagName("tr");

		for (var i = 1; i < linhas.length; i++) { // pula o cabeçalho
			var texto = linhas[i].textContent || linhas[i].innerText;
			linhas[i].style.display = (texto.toUpperCase().indexOf(filtro) > -1) ? "" : "none";
		}
	}

	function adicionarSelecionados(){

		var checkboxes = document.querySelectorAll('input[name="chkBem"]:checked');
		if (checkboxes.length == 0) {
			alert("Marque ao menos um bem para adicionar !");
			return false;
		}
		document.getElementById("frmSelecionados").submit();
		return true;
	}

	function removerItem(codItem){

		if (!confirm("Confirma a remoção deste item da transferência?")) return false;
		window.location = "pat_transferencia_itens_cod.asp?acao=RemoverItem&cod_item=" + codItem;
		return true;
	}

	function concluirTransferencia(){

		var codTransferencia = document.getElementById("txtCodigo").value;
		if (!confirm("Confirma a conclusão desta transferência?\n\nTodos os bens listados serão movimentados para a unidade de destino. Esta ação não pode ser desfeita.")) return false;
		window.location = "pat_transferencia_itens_cod.asp?acao=Concluir&cod=" + codTransferencia;
		return true;
	}

	function cancelarTransferencia(){

		var codTransferencia = document.getElementById("txtCodigo").value;
		var motivo = prompt("Informe o motivo do cancelamento:");
		if (motivo == null) return false;
		if (motivo == "") {
			alert("O motivo do cancelamento deve ser informado !");
			return false;
		}

		var frmCancelar = document.createElement("form");
		frmCancelar.method = "post";
		frmCancelar.action = "pat_transferencia_itens_cod.asp?acao=Cancelar";

		var campoCod = document.createElement("input");
		campoCod.type = "hidden";
		campoCod.name = "cod_transferencia";
		campoCod.value = codTransferencia;
		frmCancelar.appendChild(campoCod);

		var campoMotivo = document.createElement("input");
		campoMotivo.type = "hidden";
		campoMotivo.name = "motivo_cancelamento";
		campoMotivo.value = motivo;
		frmCancelar.appendChild(campoMotivo);

		document.body.appendChild(frmCancelar);
		frmCancelar.submit();
		return true;
	}
