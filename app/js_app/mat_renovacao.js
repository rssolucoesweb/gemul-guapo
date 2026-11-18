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
		if (frm.cmbTurma.value=="0"){
			alert("Selecione a Turma atual.")		
			frm.cmbTurma.focus();
			return false
		}

		if (frm.cmbTurmaRenovacao.value=="0"){
			alert("Selecione a turma para renovação.")		
			frm.cmbTurmaRenovacao.focus();
			return false
		}
		if (frm.cmbTurma.value==frm.cmbTurmaRenovacao.value){
			alert("Turma para renovação não poderá ser igual a turma atual. Verifique!")		
			frm.cmbTurmaRenovacao.focus();
			return false
		}

		if (!confirm("Todos alunos selecionados serão renovados para turma de renovação, deseja continuar?"))
			return false;
		else {
			document.getElementById('btnIncluir').disabled = true;

			frm.action="mat_renovacao_cod.asp";
			frm.submit();
			return true;
		}
 	}

	//Exclui (desfaz) a renovação do aluno: volta para a turma de origem com notas e disciplinas de antes
	function excluirRenovacao(codigo, nome){
		var frm = document.getElementById("frm");
		if (!confirm("ATENÇÃO: a renovação de " + nome + " será EXCLUÍDA.\n\nO aluno volta para a turma de origem.\nSó é possível se ainda não houver notas, faltas ou avaliações lançadas no ano novo.\n\nDeseja continuar?"))
			return false;
		frm.txtCodRenovacao.value = codigo;
		frm.action = "mat_renovacao_cod.asp?acao=E";
		frm.submit();
		return true;
	}

	//Termo de renovação de matrícula (ficha individual do aluno) em janela de impressão
	function imprimirTermo(codAluno, anoLetivo, semestre, codTurma, codEmpresa){
		var caminho = "sca_rel_ficha_individual_rel.asp?notas=N"
			+ "&txtCodAluno=" + codAluno
			+ "&txtAnoLetivo=" + anoLetivo
			+ "&cmbSemestre=" + semestre
			+ "&cmbTurma=" + codTurma
			+ "&txtCodEmpresa=" + codEmpresa;
		var janela = window.open(caminho, "termoRenovacao", "width=900,height=700,scrollbars=yes,resizable=yes");
		if (janela) janela.focus();
		return false;
	}
