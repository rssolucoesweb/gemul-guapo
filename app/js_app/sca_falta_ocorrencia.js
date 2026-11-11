	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtOcorrencia.value == "") {
			alert("A Ocorrência deve ser informada !");
			frm.txtOcorrencia.focus();
			return false;
		}
		
		frm.action="sca_falta_ocorrencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}