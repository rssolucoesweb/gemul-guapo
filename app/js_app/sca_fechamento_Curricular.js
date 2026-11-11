	function salvar(acao){
		
		var frm = document.getElementById("frm");
		var form = document.getElementById("frm");
		var intContMarcado=0;
		var strAlunos='';
		
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

		if (frm.cmbTipoAtualizacao.value=='F'){
			if (frm.cmbSituacaoAluno.value=='0'){
			alert("A situação de destino deve ser informada.")
			frm.cmbSituacaoAluno.focus();
			return false
			}
		}
		
		frm.action="sca_fechamento_curricular_cod.asp";
		frm.submit();
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