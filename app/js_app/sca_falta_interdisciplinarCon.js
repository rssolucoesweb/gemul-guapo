
	function cadastrarFaltas(){
		var frm = document.getElementById("frm")
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbMes.value == "0"){
			alert("Mês deve ser informado!");
			frm.cmbMes.focus();
			return false;
		}		

		//*****verifica se um aluno foi selecionado
		intContMarcado=0;
		for (var i = 0; i < frm.elements.length; i++) {
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox"){
				if (frm.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (frm.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}	
		if (intContMarcado==0){
			alert("O(s) aluno(s) deve(m) ser informado(s)!");
			return false;
		}
		
		frm.action = "sca_falta_interdisciplinar.asp";
		frm.submit();
		
		return true;	
	}
	
	function lancarOcorrencias(codAluno, aluno){
		var frm = document.getElementById("frm")
		window.open("sca_falta_ocorrencia.asp?txtCodAluno="+codAluno+"&txtAluno="+aluno,"Lancar", "top=50,left=50,height=650,width=900,menubar=no,toolbar=no,scrollbars=no,status=no");
		return true;
	}

	function MarcaTodosAlunos(valor){
		var form = document.getElementById("frm");
		var i;
	
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (form.elements[i].disabled==false) {
						form.elements[i].checked=valor;
					}
				}
			}
		}
	}			
