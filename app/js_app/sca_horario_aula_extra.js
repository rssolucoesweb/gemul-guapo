function marcaTodos(){
	  if(frm.chkTodos.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox" ){	
						if (frm.elements[i].name=="chkExcluir"){
							frm.elements[i].checked = true;		
						}						
					}
		  }
	  }else{
	  
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox" ){	
						if (frm.elements[i].name=="chkExcluir"){				
							frm.elements[i].checked = false;				
						}
					}
		  }
	  }
	  return true;
	}
	function Sequencia(tipo){
		if (document.all["mostraSequencia"+tipo].style.display =="none"){
			document.all["mostraSequencia"+tipo].style.display="block";
		}
		else{
			document.all["mostraSequencia"+tipo].style.display="none";
		}
	}	
	
	function salvar(acao){
		
		if (frm.cmbTurma.value == 0){
			alert("Turma deve ser informada.");
			frm.cmbTurma.focus();
			return false;
		}
		
		if (frm.txtDataLancamento.value == ""){
			alert("A Data do lançamento deve ser informada.");
			frm.txtDataLancamento.focus();
			return false;
		}
		
		if (frm.cmbDisciplinaGrade.value == 0){
			alert("A Disciplina deve ser informada.");
			frm.cmbDisciplinaGrade.focus();
			return false;
		}
				
		frm.action="sca_horario_aula_extra_cod.asp?acao="+acao;
		frm.submit();
		return true;
 	}
	function removeSelecionados(){
		var frm = document.getElementById("frm");
		
		var selecionado = "N";
		
		for (var i = 0; i < frm.elements.length; i++) {
			if (frm.elements[i].type == "checkbox"){	
				if (frm.elements[i].name=="chkExcluir"){			
				if (frm.elements[i].checked == true)
				{
					selecionado = "S";
				}
				}
			}
		}
		
		if (selecionado == "N"){
			alert("Selecione os registros a serem excluidos!");
			return false
		}
		
		if (confirm("Deseja excluir todos os itens selecionados?")){
			frm.action="sca_horario_aula_extra_cod.asp?acao=ET";
			frm.submit();
		}
 	}