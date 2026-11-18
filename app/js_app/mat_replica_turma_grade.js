	//Ao trocar o ano atual: sugere o ano seguinte para a replicação e recarrega a lista
	function atualizaAno(){
		var frm = document.getElementById("frm");
		var ano = parseInt(frm.txtAnoLetivo.value, 10);
		if (!isNaN(ano)) {
			frm.txtAnoLetivoReplicacao.value = ano + 1;
		}
		frm.action = "mat_replica_turma_grade.asp";
		frm.submit();
	}

	function anoValido(campo, mensagem){
		var ano = parseInt(campo.value, 10);
		if (isNaN(ano) || ano < 2000 || ano > 2100) {
			alert(mensagem);
			campo.focus();
			return false;
		}
		return true;
	}

	function salvar(){

		var frm = document.getElementById("frm");

		if (!anoValido(frm.txtAnoLetivo, "Informe o ano letivo atual!")) return false;
		if (!anoValido(frm.txtAnoLetivoReplicacao, "Informe o ano letivo da replicação!")) return false;

		var anoAtual = parseInt(frm.txtAnoLetivo.value, 10);
		var anoReplicacao = parseInt(frm.txtAnoLetivoReplicacao.value, 10);
		if (anoReplicacao <= anoAtual) {
			alert("O ano letivo da replicação deve ser maior que o ano letivo atual!");
			frm.txtAnoLetivoReplicacao.focus();
			return false;
		}

		var cmbUnidade = frm.cmbEmpresaGrupo;
		var cmbTipo = frm.cmbTipoEmpresa;
		var todas = true;
		var unidade = "TODAS AS UNIDADES";
		if (cmbUnidade && cmbUnidade.value != "0" && cmbUnidade.value != "") {
			unidade = cmbUnidade.options[cmbUnidade.selectedIndex].text;
			todas = false;
		} else if (cmbTipo && cmbTipo.value != "0" && cmbTipo.value != "") {
			unidade = "TODAS AS UNIDADES do tipo " + cmbTipo.options[cmbTipo.selectedIndex].text;
		}

		var mensagem = "Confirma a replicação de todas as grades e turmas do ano de " + anoAtual + " para o ano de " + anoReplicacao + "?\n\nUnidade: " + unidade;
		if (todas) {
			mensagem = "ATENÇÃO: nenhuma unidade foi selecionada, a replicação será feita para " + unidade + ".\n\n" + mensagem;
		}
		if (!confirm(mensagem)) return false;

		//Evita clique duplo enquanto o processamento roda
		var btn = document.getElementById("btnReplicar");
		if (btn) {
			btn.disabled = true;
			btn.innerHTML = "Processando, aguarde...";
		}

		frm.action = "mat_replica_turma_grade_cod.asp?acao=I";
		frm.submit();
		return true;
	}

	function cancelarReplicacao(id, ano, anoReplicacao){

		var frm = document.getElementById("frm");

		if (!confirm("ATENÇÃO: esse procedimento só pode ser executado se não houver nenhuma movimentação nas grades e turmas criadas.\n\nConfirma o CANCELAMENTO da replicação das grades e turmas do ano de " + ano + " para o ano de " + anoReplicacao + "?"))
			return false;

		frm.txtIdReplicacao.value = id;
		frm.action = "mat_replica_turma_grade_cod.asp?acao=E";
		frm.submit();
		return true;
	}
