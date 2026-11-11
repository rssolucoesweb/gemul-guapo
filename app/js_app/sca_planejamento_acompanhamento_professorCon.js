	function resultadoConsulta(codTurno, turno, codProfessor, professor){
		var frm = document.getElementById("frm");
		
		frm.txtCodTurno.value			= codTurno;
		frm.txtTurno.value				= turno;
		frm.txtCodProfessor.value		= codProfessor;
		frm.txtProfessor.value			= professor;

		frm.action="sca_planejamento_acompanhamento_professor.asp"
		frm.submit();
	}

	