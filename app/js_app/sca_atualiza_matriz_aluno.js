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
	function gerar(){
		var form = document.getElementById("frm");
		var intContMarcado=0;
		var strAlunos='';
		var intAnoSession = frm.txtAnoLetivo.value;
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
		
		if (frm.txtAnoLetivo.value>intAnoSession) {
			alert("Ano/Semestre letivo não permitido.");
			frm.txtAnoLetivo.focus();
			return false
		}
	
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbTurma.value == 0){
			alert("A turma deve ser informada!");
			frm.cmbTurma.focus();
			return false;
		}		

		if (frm.cmbAtualizaGrade.value == 0){
			alert("O Tipo de Atualização deverá ser ser informado!");
			frm.cmbAtualizaGrade.focus();
			return false;
		}
		

		//*****verifica se um aluno foi selecionado
		intContMarcado=0;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				if (form.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}	
		if (intContMarcado==0){
			alert("O(s) aluno(s) deve(m) ser informado(s)!");
			return false;
		}
		
		frm.action = "sca_atualiza_matriz_aluno_cod.asp";
		frm.submit();
		
		return true;	
	}