	function marcaTodos(valor){
		var frm = document.getElementById("frm");
		
		var i;
		for (var i = 0; i < frm.elements.length; i++) {
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				frm.elements[i].checked=valor;
			}
		}
	}
	
	function salvar(acao){
		
		if (frm.txtAnoLetivo.value==""){
			alert("Selecione o Ano de Origem.")		
			frm.txtAnoLetivo.focus();
			return false
		}
		if (frm.cmbSemestre.value=="0"){
			alert("Selecione o semestre de Origem.")		
			frm.cmbSemestre.focus();
			return false
		}
		/*if (frm.cmbTurma.value=="0"){
			alert("Selecione a Turma de Origem.")		
			frm.cmbTurma.focus();
			return false
		}*/

		if (frm.txtAnoLetivoLocacao.value==""){
			alert("Selecione o Ano para Alocação.")		
			frm.txtAnoLetivoLocacao.focus();
			return false
		}
		if (frm.cmbSemestreAlocacao.value=="0"){
			alert("Selecione o semestre para Alocação.")		
			frm.cmbSemestreAlocacao.focus();
			return false
		}
		if (frm.cmbTurmaAlocacao.value=="0"){
			alert("Selecione a Nova Turma para Alocação.")		
			frm.cmbTurmaAlocacao.focus();
			return false
		}
		if (frm.cmbTipoAlocacao.value=="0"){
			alert("Selecione o Tipo de Alocação.")		
			frm.cmbSemestreAlocacao.focus();
			return false
		}
		if (frm.cmbTurma.value==frm.cmbTurmaAlocacao.value){
			alert("Turma para Alocação não poderá ser igual a Turma de Origem. Verifique!")		
			frm.cmbTurmaAlocacao.focus();
			return false
		}

		if (frm.serieOrigem.value!=frm.serieDestino.value){
			

			if (!confirm("Atenção: Os alunos serão alocados para uma nova turma, sua grade de disciplinas será recriada, deseja continuar?"))
				return false;
			else{
				frm.action="sca_alocacao_turma_cod.asp";
				frm.submit();
				return true;
			}

		} 
		else 
		{
			if (!confirm("Todos alunos selecionados serão alocadados na turma de destino, deseja continuar?"))
				return false;
			else{
				frm.action="sca_alocacao_turma_cod.asp";
				frm.submit();
				return true;
			}
		}
 	}