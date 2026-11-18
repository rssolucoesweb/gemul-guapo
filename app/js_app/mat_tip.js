	//TIP - Transferência por Interesse Próprio
	function salvar(acao){

		var frm = document.getElementById("frm");

		if (frm.txtMatricula.value == "") {
			alert("A Matrícula do aluno deve ser informada!");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.txtNomealuno.value == "" || frm.txtCodAluno.value == "" || frm.txtCodAluno.value == "0") {
			alert("Aluno deve ser informado!");
			frm.txtMatricula.focus();
			return false;
		}
		if (!frm.cmbEmpresa || frm.cmbEmpresa.value == "0") {
			alert("Selecione a unidade escolar de destino!");
			if (frm.cmbEmpresa) frm.cmbEmpresa.focus();
			return false;
		}
		if (!frm.cmbTurma || frm.cmbTurma.value == "0") {
			alert("Selecione a turma de destino!");
			if (frm.cmbTurma) frm.cmbTurma.focus();
			return false;
		}

		var unidade = frm.cmbEmpresa.options[frm.cmbEmpresa.selectedIndex].text;
		var turma = frm.cmbTurma.options[frm.cmbTurma.selectedIndex].text;
		if (!confirm("Confirma a TIP do aluno " + frm.txtNomealuno.value + "?\n\nDestino: " + unidade + "\nTurma: " + turma + "\n\nA vaga na turma de destino fica reservada e o aluno continua ativo nesta unidade.\nA transferência para " + frm.txtAnoLetivoDestino.value + " só acontece quando a unidade de destino efetivar a TIP (tela de Efetivação)."))
			return false;

		var btn = document.getElementById("btnIncluir");
		if (btn) {
			btn.disabled = true;
			btn.innerHTML = "Processando, aguarde...";
		}

		frm.action = "mat_tip_cod.asp?acao=I";
		frm.submit();
		return true;
	}

	//Exclui (desfaz) a TIP: o aluno volta para a turma e unidade de origem
	function excluirTip(codigo, nome){
		var frm = document.getElementById("frm");
		if (!confirm("ATENÇÃO: a TIP de " + nome + " será EXCLUÍDA.\n\nA TIP ainda não foi efetivada: o aluno continua nesta unidade, com a renovação de matrícula para " + frm.txtAnoLetivoDestino.value + " nesta unidade, e a vaga reservada na turma de destino é liberada.\n\nDeseja continuar?"))
			return false;
		frm.txtCodTip.value = codigo;
		frm.action = "mat_tip_cod.asp?acao=E";
		frm.submit();
		return true;
	}

	//Comprovante da TIP em janela de impressão
	function imprimirTip(codigo){
		var janela = window.open("mat_tip_rel.asp?txtCodTip=" + codigo, "comprovanteTip", "width=950,height=750,scrollbars=yes,resizable=yes");
		if (janela) janela.focus();
		return false;
	}
