	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao != "D"){
			
			if (frm.cmbSemestre.value == "0") {
				alert("O Semestre deve ser informado !");
				frm.cmbSemestre.focus();
				return false;
			}
	
			if (frm.txtDescricao.value == "") {
				alert("O horario deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
			/*
			if (frm.txtHoraInicio.value == "") {
				alert("A Hora Inicial deve ser informada !");
				frm.txtHoraInicio.focus();
				return false;
			}
			if (frm.txtMinutoInicio.value == "") {
				alert("O Minuto Inicial deve ser informado !");
				frm.txtMinutoInicio.focus();
				return false;
			}

			if (frm.txtHoraTermino.value == "") {
				alert("A Hora de Termino deve ser informada !");
				frm.txtHoraTermino.focus();
				return false;
			}
			if (frm.txtMinutoTermino.value == "") {
				alert("O Minuto de Termino deve ser informado !");
				frm.txtMinutoTermino.focus();
				return false;
			}
			*/
			if (frm.cmbTurno.value == "0") {
				alert("O Turno deve ser informado !");
				frm.cmbTurno.focus();
				return false;
			}
			
			if (frm.cmbSequenciaAula.value == "0") {
				alert("A Sequência de ordem do Horário deve ser informada !");
				frm.cmbSequenciaAula.focus();
				return false;
			}
			
			if (frm.cmbTempoAula.value == 0){
				alert("Tempo de Aulo deve ser informado.");
				frm.cmbTempoAula.focus();
			return false;
			}
		
		}

		
		frm.action="sca_faixa_horario_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}