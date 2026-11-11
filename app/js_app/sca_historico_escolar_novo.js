	function salvaMostrarRel(valor,codHist){
		var frm = document.getElementById("frm");
		frm.action="sca_historico_escolar.asp?codhistoricoEscolar=" + codHist + "&atualizamostrarel=S&mostraRel=" + valor;
		frm.submit()
	}

	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
		frm.action="sca_historico_escolar.asp?codhistoricoEscolar=" + intCodigo;
		frm.submit();
	}

	function resultadoConsultaDisciplina(intCodHistorico, intCodHistoricoDisciplina){
		var frm = document.getElementById("frm");
		frm.action="sca_historico_escolar.asp?codhistoricoEscolar=" + intCodHistorico + "&codhistoricoEscolarDisciplina=" + intCodHistoricoDisciplina;
		frm.submit();
	}
	
	function disciplinaHistorico(intCodHistorico){
		var frm = document.getElementById("frm");
		frm.action="sca_historico_escolar_novo_disciplina.asp?codhistoricoEscolar=" + intCodHistorico;
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
			alert("O Período/Série deve ser informada !");
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
		
		frm.action="sca_historico_escolar_novo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	