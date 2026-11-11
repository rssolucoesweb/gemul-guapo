	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		frm.action= "ste_configurar_aluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
			
	}