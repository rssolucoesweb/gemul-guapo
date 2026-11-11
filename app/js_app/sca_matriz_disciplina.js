function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	function ExcluirDisciplina(){
		var form = document.getElementById("frm");
		var intContMarcado=0;
		
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				if (form.elements[i].name == "cod_excluirDisc"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("As grades disciplinas devem ser selecionadas!");
			return false;
		}		
		
		var men = 'ATENCAO: \nA(s) disciplina(s) selecionada(s) sera(ao) excluida(s), deseja continuar?';
		if (confirm(men)) {
			frm.action = "sca_matriz_disciplina_cod.asp?acao=ED";
			frm.submit();
			return true;	
		}
	}
	
	function salvar(acao){
		if (acao=="E"){
			var form = document.getElementById("frm");
			//var form = window.document.forms[0];
			var intContMarcado=0;
			
			var i;
			for (var i = 0; i < form.elements.length; i++) {
				
				//verifica todos os checkbox
				if (form.elements[i].type == "checkbox"){
					alert(form.elements[i].name);
					if (form.elements[i].name == "cod_excluirDisc"){
						//verifica se o checkbox está marcado
						if (form.elements[i].checked){
							intContMarcado = intContMarcado + 1;
						}
					}
				}
			}
			
			if (intContMarcado==0){
				alert("As disciplinas devem ser selecionadas!");
				return false;
			}		
			
			var men = 'ATENCAO: \nA(s) disciplina(s) selecionada(s) sera(ao) excluida(s), deseja continuar?';
			if (confirm(men)) {
				frm.action = "sca_matriz_disciplina_cod.asp?acao=ED";
				frm.submit();
				return true;	
			}
		}else{
			if (frm.txtMatricula.value == "") {
				alert("A matrícula do aluno deve ser informada !");
				frm.txtMatricula.focus();
				return false;
			}
		
			if (frm.cmbDisciplinaGrade.value == "0") {
				alert("A Disciplina deve ser informada !");
				frm.cmbDisciplinaGrade.focus();
				return false;
			}
			
			if (frm.cmbSituacaoDisciplina.value == "0") {
				alert("A Situação deve ser informada !");
				frm.cmbSituacaoDisciplina.focus();
				return false;
			}
			
			
			if (frm.cmbTurmaRem.value == "0") {
				alert("A Turma Remanejamento deve ser informada !");
				frm.cmbTurmaRem.focus();
				return false;
			}
			
			if (frm.cmbDisciplinaRemanejamento.value == "0") {
				alert("A Disciplina Remanejamento deve ser informada !");
				frm.cmbDisciplinaRemanejamento.focus();
				return false;
			}
			
			frm.action="sca_matriz_disciplina_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}
		
	function NotasFaltas(intCodigo) {
		window.open("sca_ArquivoNotasFaltas_con.asp?cod_aluno="+intCodigo,"cadAltr", "top=0,left=0,height=450,width=750,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}