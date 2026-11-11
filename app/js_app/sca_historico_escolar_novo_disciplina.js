	function salvaMostrarRel(valor,codHist){
		frm.action="sca_historico_escolar.asp?codhistoricoEscolar=" + codHist + "&atualizamostrarel=S&mostraRel=" + valor;
		frm.submit()
	}

	function resultadoConsulta(intCodigo){
		frm.action="sca_historico_escolar.asp?codhistoricoEscolar=" + intCodigo;
		frm.submit();
	}

	function resultadoConsultaDisciplina(intCodHistorico, intCodHistoricoDisciplina){
		frm.action="sca_historico_escolar.asp?codhistoricoEscolar=" + intCodHistorico + "&codhistoricoEscolarDisciplina=" + intCodHistoricoDisciplina;
		frm.submit();
	}


	function salvar(acao){
		var frm = document.getElementById("frm");
		
		if (frm.txtAnoHistorico.value == "") {
			alert("O Ano Historico deve ser informado !");
			frm.txtAnoHistorico.focus();
			return false;
		}
		
		if (frm.cmbSemestreHistorico.value == "0") {
			alert("O Semestre Historico deve ser informado !");
			frm.cmbSemestreHistorico.focus();
			return false;
		}
		
		if (frm.txtCurso.value == "") {
			alert("O Curso Historico deve ser informado !");
			frm.txtCurso.focus();
			return false;
		}
		
		if (frm.txtSerie.value == "") {
			alert("a Serie deve ser informada !");
			frm.txtSerie.focus();
			return false;
		}
		
		if (frm.txtEscola.value == "") {
			alert("A Escola deve ser informada!");
			frm.txtEscola.focus();
			return false;
		}
		
		if (frm.txtCidade.value == "") {
			alert("A Cidade deve ser informada!");
			frm.txtCidade.focus();
			return false;
		}
		
		if (frm.cmbPeriodo.value == "0") {
			alert("O Periodo deve ser informado!");
			frm.cmbPeriodo.focus();
			return false;
		}
		
		if (frm.cmbDisciplina.value == "0") {
			alert("A Disciplina deve ser informada!");
			frm.cmbDisciplina.focus();
			return false;
		}
		
		if (frm.txtCH.value == "") {
			alert("A CH deve ser informada!");
			frm.txtCH.focus();
			return false;
		}
		
		if (frm.cmbSituacaoPromocao.value == "0") {
			alert("A Situacao Promocao deve ser informada!");
			frm.cmbSituacaoPromocao.focus();
			return false;
		}
		
		if (frm.txtMedia.value == "" && frm.txtMostraNota.checked == false) {
			alert("A Media deve ser informada!");
			frm.txtMedia.focus();
			return false;
		}
		
		frm.action="sca_historico_escolar_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function excluirHistorico(codigo){
			var men = 'ATENÇÃO: Deseja realmente excluír os dados do histório neste ANO e SEMESTRE?\n'
			if (confirm(men)) {
				frm.action="sca_historico_escolar_cod.asp?acao=EH&codHistoricoEscolar="+codigo;
				frm.submit();
			} 
			else {
				return false;
			}
 	}

	function excluirDisciplina(codigo){
			var men = 'ATENÇÃO: Deseja realmente Excluir essa disciplina do Histórico Escolar?\n'
			if (confirm(men)) {
				frm.action="sca_historico_escolar_cod.asp?acao=ED&codHistoricoEscolarDisciplina="+codigo;
				frm.submit();
			} 
			else {
				return false;
			}
 	}