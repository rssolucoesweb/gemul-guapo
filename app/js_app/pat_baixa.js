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
		if (frm.cmbTipoBaixa.value == "") {
			alert("O Tipo de Baixa deve ser informado !");
			frm.cmbTipoBaixa.focus();
			return false;
		}
		frm.action="pat_baixa_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function efetivarBaixa(){

		if (!confirm("Confirma a EFETIVAÇÃO desta baixa?\n\nEsta ação é irreversível: o bem será marcado como baixado e não poderá mais ser movimentado, transferido ou entrar em manutenção.")) return false;
		var cod = document.getElementById("txtCodigo").value;
		window.location = "pat_baixa_workflow_cod.asp?acao=Efetivar&cod=" + cod;
		return true;
	}

	function cancelarBaixa(){

		var cod = document.getElementById("txtCodigo").value;
		var motivo = prompt("Informe o motivo do cancelamento:");
		if (motivo == null) return false;
		if (motivo == "") {
			alert("O motivo do cancelamento deve ser informado !");
			return false;
		}

		var frmCancelar = document.createElement("form");
		frmCancelar.method = "post";
		frmCancelar.action = "pat_baixa_workflow_cod.asp?acao=Cancelar";

		var campoCod = document.createElement("input");
		campoCod.type = "hidden";
		campoCod.name = "cod_baixa";
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
