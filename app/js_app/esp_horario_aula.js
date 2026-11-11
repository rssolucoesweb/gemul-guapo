	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTurma.value == "0") {
			alert("A turma deve ser informada!");
			frm.cmbTurma.focus();
			return false;
		}
		
		frm.action="esp_horario_aula_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}