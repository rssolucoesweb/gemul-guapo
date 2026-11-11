	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E") {
			var r = confirm("Deseja excluir esse registro?");
			if (r == true) {
			 frm.action="sca_turma_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			} else {
			 return false;
			}	
			
		}else{	
			if (frm.txtAnoLetivo.value == "") {
				alert("O Ano Letivo deve ser informado !");
				frm.txtAnoLetivo.focus();
				return false;
			}
			if (frm.cmbSemestre.value == "0") {
				alert("O Semestre deve ser informada !");
				frm.cmbSemestre.focus();
				return false;
			}
			if (frm.cmbCurso.value == "0") {
				alert("O Curso deve ser informado !");
				frm.cmbCurso.focus();
				return false;
			}
			if (frm.cmbPeriodo.value == "0") {
				alert("O Período deve ser informado !");
				frm.cmbPeriodo.focus();
				return false;
			}
			
			if (frm.txtSala.value == "") {
				alert("A Sala deve ser informada !");
				frm.txtSala.focus();
				return false;
			}
			if (frm.cmbTurno.value == "0") {
				alert("O Turno deve ser informado !");
				frm.cmbTurno.focus();
				return false;
			}
			
			
			if (frm.cmbGrade.value == "0") {
				alert("A matriz/grade deve ser informada !");
				frm.cmbGrade.focus();
				return false;
			}

			
			
			if (frm.txtAno.value == "") {
				alert("O Ano criação deve ser informado !");
				frm.txtAno.focus();
				return false;
			}
			
			
			if (frm.cmbSemestreCriacao.value == "0") {
				alert("O semestre criação deve ser informado !");
				frm.cmbSemestreCriacao.focus();
				return false;
			}
			if (frm.txtNomeTurma.value == "") {
				alert("O Nome da Turma deve ser informada !");
				frm.txtNomeTurma.focus();
				return false;
			}
			
			if (frm.txtCapacidade.value == "") {
				alert("O Capacidade deve ser informada !");
				frm.txtCapacidade.focus();
				return false;
			}
					
			
			if (frm.txtCapacidade.value < frm.txtVagasMatriculas.value) {
				alert("O número de vagas não poderá ser superior que a Capacidade da turma !");
				frm.txtCapacidade.focus();
				return false;
			}

			frm.action="sca_turma_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}