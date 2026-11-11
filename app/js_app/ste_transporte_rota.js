	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtNome.value == ""){
			alert("A rota deve ser informada.");
			frm.txtNome.focus();
			return false;
		}	
		
		if (frm.txtDistanciaPercorrida.value == ""){
			alert("A distancia percorrida deve ser informada.");
			frm.txtDistanciaPercorrida.focus();
			return false;
		}			
		
		frm.action="ste_transporte_rota_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}