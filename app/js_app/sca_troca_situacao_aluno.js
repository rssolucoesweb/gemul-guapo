	function marcaTodos(valor){
		var frm = document.getElementById("frm");
		
		var i;
		for (var i = 0; i < frm.elements.length; i++) {
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (frm.elements[i].disabled == false){
				frm.elements[i].checked=valor;
				}
			}
		}
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbSituacaoAluno.value=="0"){
			alert("Selecione a situação do aluno")		
			frm.cmbSituacaoAluno.focus();
			return false
		}
		
		frm.action="sca_troca_situacao_aluno_cod.asp";
		frm.submit();
		return true;
 	}