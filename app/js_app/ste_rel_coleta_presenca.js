	function gerar(){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbRota.value == "0") {
			alert("Rota deve ser informada!")
			frm.cmbRota.focus();
			return false
		}
		
		if (frm.cmbOpcao.value == "PERIODO") {
			if (frm.txtDataLancamentoI.value == "") {
				alert("Data incial deve ser informada!")
				frm.txtDataLancamentoI.focus();
				return false
			}
			if (frm.txtDataLancamentoF.value == "") {
				alert("Data final deve ser informada!")
				frm.txtDataLancamentoF.focus();
				return false
			}
			
			frm.action = "ste_rel_coleta_presenca_periodo_rel.asp";
			frm.submit();
			return true;
		}
		
		if (frm.cmbOpcao.value == "DATA") {
			if (frm.txtDataLancamento.value == "") {
				alert("Data deve ser informada!")
				frm.txtDataLancamento.focus();
				return false
			}
			
			frm.action = "ste_rel_coleta_presenca_rel.asp";
			frm.submit();
			return true;
		}
			
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
	
	function mostraOpcaoRel(){
		if (frm.cmbOpcao.value == "PERIODO") {
			$("#linha_periodoI").show();
			$("#linha_periodoF").show();
			$("#linha_data").hide();
		}
		else if (frm.cmbOpcao.value == "DATA") {
			$("#linha_periodoI").hide();
			$("#linha_periodoF").hide();
			$("#linha_data").show();			
		} 
		else {
			$("#linha_periodoI").show();
			$("#linha_periodoF").show();
			$("#linha_data").hide();
		}
	}
	
	