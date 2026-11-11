	var intContMarcado=0;		

	function salvar(acao){
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == ""){
			alert("O descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		frm.action= "Seg_grupo_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function selGrupo(cod){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=cod;
		frm.action="Seg_grupo_cad.asp";
		frm.submit();
	}	