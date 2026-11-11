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
		
		if (acao=="E") {
			if (confirm("Você realmente deseja excluir o horário?")) { 
				frm.action="sca_horario_aula_cod.asp?acao="+acao;
				frm.submit();
				return true;
			}
		} else {

			frm.action="sca_horario_aula_cod.asp?acao="+acao;
			frm.submit();
			return true;
		}
 	}