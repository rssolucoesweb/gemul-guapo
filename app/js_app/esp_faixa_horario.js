	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao != "D"){
			
	
			if (frm.txtDescricao.value == "") {
				alert("O horario deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
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

		
		frm.action="esp_faixa_horario_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}