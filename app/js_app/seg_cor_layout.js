	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(layout){
		
		var frm = document.getElementById("frm");
		frm.txtLayout.value = layout;
		
		frm.action="seg_cor_layout_cod.asp";
		frm.submit();
		return true;
 	}