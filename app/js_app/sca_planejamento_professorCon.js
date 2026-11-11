	function resultadoConsulta(codTurno, turno, codPeriodo, periodo, codDisciplina, Disciplina, codTurma, Turma, anoLetivo){
		var frm = document.getElementById("frm");
		frm.txtCodCurso.value			= $("#cmbCurso").val();
		frm.txtCurso.value				= $("#cmbCurso").find('option').filter(':selected').text();
		frm.txtCodPeriodo.value			= codPeriodo;
		frm.txtPeriodo.value			= periodo;
		frm.txtCodTurno.value			= codTurno;
		frm.txtTurno.value				= turno;
		frm.txtCodDisciplina.value		= codDisciplina;
		frm.txtDisciplina.value			= Disciplina;
		frm.txtCodTurma.value			= codTurma;
		frm.txtTurma.value				= Turma;
		frm.txtTurma.value				= Turma;
		frm.txtAnoLetivo.value          = anoLetivo

		frm.action="sca_planejamento_professor.asp?pagina=" + $("#pagina").val();
		frm.submit();
	}

	