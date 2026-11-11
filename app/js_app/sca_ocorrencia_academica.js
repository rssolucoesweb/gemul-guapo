	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}	

	function abreConsultaOcorrencia(caminho){
		
		var frm = document.getElementById("frm");
		
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value == "") {
			alert("A Matricula do Aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.txtNomealuno.value == "") {
			alert("O Aluno deve ser selecionado !");
			frm.txtNomealuno.focus();
			return false;
		}
		if (frm.txtDataOcorrencia.value == "") {
			alert("A Data da Ocorrência deve ser informada !");
			frm.txtDataOcorrencia.focus();
			return false;
		}
		
		if (frm.txtOcorrencia.value == "") {
			alert("A Ocorrência deve ser informada !");
			frm.txtOcorrencia.focus();
			return false;
		}
		
		frm.action="sca_ocorrencia_academica_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}