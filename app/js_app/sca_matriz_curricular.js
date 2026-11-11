function AlteraDisciplina(CodGrade, CodGradeCurricularDisciplina){
		window.open("sca_matriz_curricular_disciplina.asp?CodGrade="+CodGrade + "&GradeCurricularDisciplina=" + CodGradeCurricularDisciplina,"consulta", "top=0,left=0,height=570,width=778,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	
	function ExcluirDisciplina(CodGrade, CodGradeCurricularDisciplina){
		var acao ="ED";
		var frm = document.getElementById("frm");
		
		frm.action = "sca_matriz_curricular_cod.asp?acao=" + acao + "&CodGrade=" + CodGrade + "&CodCurricularDisciplina=" + CodGradeCurricularDisciplina;
		frm.submit()
	}
	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if ((acao == "I") || (acao == "A")) {	
			
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
				
			if (frm.cmbSemestre.value == "0") {
				alert("O Semestre deve ser informado !");
				frm.cmbSemestre.focus();
				return false;
			}
						
			if (frm.cmbSituacao.value == "0") {
				alert("A Situação deve ser informada !");
				frm.cmbSituacao.focus();
				return false;
			}
			
			if (frm.txtAno.value == "") {
				alert("O Ano deve ser informado !");
				frm.txtAno.focus();
				return false;
			}

			
			var intContMarcado=0;
			
			for (var i = 0; i < frm.elements.length; i++) {
				//verifica todos os checkbox
				if (frm.elements[i].type == "checkbox"){
					if (frm.elements[i].name == "txtCodDisciplina"){
						//verifica se o checkbox está marcado
						if (frm.elements[i].checked){
							intContMarcado = intContMarcado + 1;
						}
					}
				}
			}	
			if (intContMarcado==0){
				alert("A(s) disciplina(s) deve(m) ser informada!");
				return false;
			}			
			
			frm.action="sca_matriz_curricular_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		
		}
		
		if (acao == "E") {
			
			var men = 'ATENÇÃO: Deseja realmente Excluir essa Grade Curricular?\n'
			if (confirm(men)) {
				frm.action="sca_matriz_curricular_cod.asp?acao=" + acao;
				frm.submit();
			} 
			else {
				return false;
			}
		} 
		
 	}