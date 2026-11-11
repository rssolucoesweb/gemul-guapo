	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		if (frm.cmbCurso.value == "0"){
				alert("Curso deve ser selecionado.");
				frm.cmbCurso.focus();
				return false;
			}	
		frm.action="sca_turma_descricao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}