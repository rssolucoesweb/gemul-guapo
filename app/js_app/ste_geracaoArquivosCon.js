	function gerar(){
		
		var frm = document.getElementById("frm");
		
		if (frm.modelo.value == "0") {
			alert("modelo deve ser informado!")
			frm.modelo.focus();
			return false
		}
		if (frm.rede.value == "0") {
			alert("Rede deve ser informada!")
			frm.rede.focus();
			return false
		}
		frm.action = "ste_geracaoArquivos_cod.asp";
		frm.submit();
		return true;	
	}
	
	function mostraUnidade(){
		if (frm.rede.value == "M") {
			$("#linha_municipal").show();
			$("#linha_estadual").hide();
		}
		else if (frm.rede.value == "E") {
			$("#linha_municipal").hide();
			$("#linha_estadual").show();			
		} 
		else {
			$("#linha_estadual").hide();
			$("#linha_municipal").hide();
		}
	}
	
	