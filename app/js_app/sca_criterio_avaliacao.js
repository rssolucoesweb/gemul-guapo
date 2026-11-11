function mostralinha(tipo){
		if (tipo == 'EF'){
			linhaREC.style.display="none";
			linhaEF.style.display="block";
		}
		if (tipo == 'REC'){
			linhaEF.style.display="none";
			linhaREC.style.display="block";
		}
	}
	function salvar(acao){
		
		if (acao=="E") {
			if (!confirm("ATENÇÃO! Com a exclusão do critério, TODAS as notas serão REMOVIDAS, Deseja continuar?"))
				return false;
			else{
				frm.action="sca_criterio_avaliacao_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			}
		}
		else{
		if (frm.txtAnoLetivo.value==""){
			alert("O ano letivo deve ser informado!");
			frm.txtAnoLetivo.focus();
			return false;
		}
		if (frm.cmbCurso.value=="0"){
			alert("O curso deve ser informado!");
			frm.cmbCurso.focus();
			return false;
		}
		if (frm.cmbTipoCalculoCriterio.value=="0"){
			alert("O tipo de calculo deve ser informado!");
			frm.cmbTipoCalculoCriterio.focus();
			return false;
		}
		
						
		if (frm.txtMedia.value==""){
			alert("A média de aprovação deve ser informada!");
			frm.txtMedia.focus();
			return false;
		}else{
			if(parseFloat(frm.txtMedia.value) > 10){
				alert("O valor da média de aprovação deve ser menor ou igual a 10!");
				frm.txtMedia.focus();
				return false;
			}		
		}
	
		
		
		if (frm.txtFrequencia.value==""){
			alert("A freqüência deve ser informada!");
			frm.txtFrequencia.focus();
			return false;
		}else{
			if(parseFloat(frm.txtFrequencia.value) > 100){
				alert("O valor da freqüência mínima deve ser menor ou igual a 100%!");
				frm.txtFrequencia.focus();
				return false;
			}		
		}		
		
		if (frm.txtDuracao.value==""){
			alert("A duração do ano letivo deve ser informada!");
			frm.txtDuracao.focus();
			return false;
		}else{
			if(parseInt(frm.txtDuracao.value) > 365){
				alert("O valor da duração do ano letivo deve ser menor ou igual a 365!");
				frm.txtDuracao.focus();
				return false;
			}		
		}
		

		frm.action="sca_criterio_avaliacao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
		}	 
		
}

