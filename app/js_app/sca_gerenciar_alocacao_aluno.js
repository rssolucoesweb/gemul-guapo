	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		if (frm.txtAnoLetivoAlocacao.value == "") {
			alert("O Ano da Alocação deve ser informado !");
			frm.txtAnoLetivoAlocacao.focus();
			return false;
		}
		
		frm.action="sca_gerenciar_alocacao_aluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	
	function ExcluirDisciplina(Codigo, CodAluno){
		var men = 'ATENCAO: \nA Alocação do aluno sera exluída, deseja continuar?';
		if (confirm(men)) {
			var acao ="ED";
			window.open("sca_gerenciar_alocacao_aluno_cod.asp?acao=" + acao + "&Codigo=" + Codigo + "&CodAluno=" + CodAluno,"disciplina", "top=100,left=100,height=250,width=450,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
	}