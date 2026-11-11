	function resultadoConsulta(intCodigo, codCurso, codPeriodo, descCurso, descPeriodo, semestre, codDisciplina, disciplina){
		var frm = document.getElementById("frm");

		frm.txtCodigo.value	= intCodigo;
		frm.txtCodCurso.value	= codCurso;
		frm.txtCodPeriodo.value	= codPeriodo;
		frm.txtCurso.value	= descCurso;
		frm.txtPeriodo.value	= descPeriodo;
		frm.txtSemestre.value = semestre;
		frm.txtCodDisciplina.value = codDisciplina;
		frm.txtDisciplina.value = disciplina;
		
		frm.action="sca_curriculo_referencia.asp"
		frm.submit();
	}

	