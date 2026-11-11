function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value == "") {
			alert("A Matricula do Aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.txtNomealuno.value == "") {
			alert("Aluno deve ser informado!");
			frm.txtMatricula.focus();
			return false;
		}	

		frm.action="sca_documentacao_aluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}

	function validaDocumentoData(valor, cod){
		
		if (valor==true){
			document.all["txtDataProrrogacao"+cod].value="";
			document.all["txtDataProrrogacao"+cod].disabled=true;
		}else{
			document.all["txtDataProrrogacao"+cod].value="";
			document.all["txtDataProrrogacao"+cod].disabled=false;
		}
		
	}
	
