function MarcaTodosAlunos(valor){
		
		var frm = document.getElementById("frm");
		var form = document.getElementById("frm");
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].disabled == false){
				form.elements[i].checked=valor;
				}

			}
		}
	}
	
	function salvar(acao){
		var intContMarcado=0;
		var form = document.getElementById("frm");
		var frm = document.getElementById("frm");
		if (acao=="I"){
			if (frm.cmbTipoCalculo.value=="0"){
				alert("Selecione o tipo do calcúlo")		
				frm.cmbTipoCalculo.focus();
				return false
			}

		
		
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

			if (confirm("Você realmente deseja incluir o Critério Individual para o(s) aluno(s) selecionado(s), esse procedimento remove todas as notas lançadas no critério anterior, deseja confirmar?")) { 
				frm.action="sca_criterio_individual_cod.asp?acao="+acao;
				frm.submit();
				return true;
			}
		}
		if (acao=="E"){
			
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

			if (confirm("Você realmente deseja excluir o Critério Individual para o(s) aluno(s) selecionado(s), esse procedimento remove todas as notas lançadas, deseja confirmar?")) { 
				frm.action="sca_criterio_individual_cod.asp?acao="+acao;
				frm.submit();
				return true;
			}
		}
		
		
		
 	}