function carregaFicha(intCodAluno, cod_grupo){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAnoLetivo.value == ""){
			alert("O Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0"){
			alert("O Semestre deve ser informado.");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbBimestre.value == "0"){
			alert("O Bimestre/Trimestre deve ser informado.");
			frm.cmbBimestre.focus();
			return false;
		}
		
		if (frm.cmbProfessor.value == "0"){
			alert("O Professor deve ser informado.");
			frm.cmbProfessor.focus();
			return false;
		}
		
		if (frm.cmbTurmaProfessor.value == "0"){
			alert("A Turma do Professor deve ser informada.");
			frm.cmbTurmaProfessor.focus();
			return false;
		}
		
		if (cod_grupo=="7"){	
			if (frm.cmbTurnoRH.value == "0"){
				alert("O turno deve ser informado.");
				frm.cmbTurnoRH.focus();
				return false;
			}
		}
	
		if (frm.cmbFichaDescritiva.value == "0"){
			alert("A Ficha Descritiva deve ser informada.");
			frm.cmbFichaDescritiva.focus();
			return false;
		}

		window.open("sca_ficha_descritiva_aluno.asp?CodAluno="+intCodAluno + "&CodFichaDescritiva="+ frm.cmbFichaDescritiva.value  + "&AnoLetivo="+ frm.txtAnoLetivo.value + "&Semestre="+ frm.cmbSemestre.value + "&cmbTurma="+ frm.cmbTurmaProfessor.value + "&cmbDisciplinaDoProfessor="+ frm.cmbDisciplinaDoProfessor.value + "&cmbBimestre=" + frm.cmbBimestre.value + "&cmbProfessor=" + frm.cmbProfessor.value + "&cmbTurnoRH=" + frm.cmbTurnoRH.value,"consulta", "top=0,left=0,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}