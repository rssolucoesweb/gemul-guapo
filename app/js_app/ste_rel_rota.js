function gerar(){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbRota.value=="0") {
			alert("Rota deve ser selecionada!")	
			frm.cmbRota.focus();
			return false
		}

		frm.action = "Ste_rel_rota_rel.asp";
		frm.submit();
		return true;	
	}