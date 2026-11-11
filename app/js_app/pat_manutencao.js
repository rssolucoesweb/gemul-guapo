	function abrirConsultaPatrimonio(){

		window.open("pat_patrimonio_con.asp", "consultaPatrimonio", "width=1000,height=650,resizable=yes,scrollbars=yes");
		return false;
	}

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");

		if (acao == "I") {
			if (frm.txtNumeroPatrimonio.value == "") {
				alert("Informe o Número do Patrimônio !");
				frm.txtNumeroPatrimonio.focus();
				return false;
			}
		}
		if (frm.txtProblema.value == "") {
			alert("Descreva o problema / defeito !");
			frm.txtProblema.focus();
			return false;
		}
		frm.action="pat_manutencao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function avancarSituacao(novaSituacao, mensagemConfirmacao){

		if (!confirm(mensagemConfirmacao)) return false;
		var cod = document.getElementById("txtCodigo").value;
		window.location = "pat_manutencao_workflow_cod.asp?acao=Avancar&cod=" + cod + "&nova_situacao=" + novaSituacao;
		return true;
	}

	function cancelarManutencao(){

		var cod = document.getElementById("txtCodigo").value;
		var motivo = prompt("Informe o motivo do cancelamento:");
		if (motivo == null) return false;
		if (motivo == "") {
			alert("O motivo do cancelamento deve ser informado !");
			return false;
		}

		var frmCancelar = document.createElement("form");
		frmCancelar.method = "post";
		frmCancelar.action = "pat_manutencao_workflow_cod.asp?acao=Cancelar";

		var campoCod = document.createElement("input");
		campoCod.type = "hidden";
		campoCod.name = "cod_manutencao";
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
