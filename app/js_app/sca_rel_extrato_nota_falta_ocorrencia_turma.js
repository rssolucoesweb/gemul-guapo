	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtObservacao.value == "") {
			alert("A observação deve ser informada !");
			frm.txtObservacao.focus();
			return false;
		}
		
		frm.action="sca_rel_extrato_nota_falta_ocorrencia_turma_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}