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
		frm.action="pat_inventario_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function gerarItens(){

		var cod = document.getElementById("txtCodigo").value;
		if (!confirm("Confirma a geração dos itens deste inventário?\n\nTodos os bens ativos da unidade (e local, se especificado) serão listados para conferência.")) return false;
		window.location = "pat_inventario_workflow_cod.asp?acao=GerarItens&cod=" + cod;
		return true;
	}

	function finalizarInventario(pendentes){

		var cod = document.getElementById("txtCodigo").value;
		var msg = "Confirma a finalização deste inventário?";
		if (pendentes > 0) {
			msg = "Existem " + pendentes + " itens ainda não conferidos. Ao finalizar, eles serão marcados automaticamente como NÃO LOCALIZADOS.\n\n" + msg;
		}
		if (!confirm(msg)) return false;
		window.location = "pat_inventario_workflow_cod.asp?acao=Finalizar&cod=" + cod;
		return true;
	}

	function cancelarInventario(){

		var cod = document.getElementById("txtCodigo").value;
		var motivo = prompt("Informe o motivo do cancelamento:");
		if (motivo == null) return false;
		if (motivo == "") {
			alert("O motivo do cancelamento deve ser informado !");
			return false;
		}

		var frmCancelar = document.createElement("form");
		frmCancelar.method = "post";
		frmCancelar.action = "pat_inventario_workflow_cod.asp?acao=Cancelar";

		var campoCod = document.createElement("input");
		campoCod.type = "hidden";
		campoCod.name = "cod_inventario";
		campoCod.value = cod;
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
