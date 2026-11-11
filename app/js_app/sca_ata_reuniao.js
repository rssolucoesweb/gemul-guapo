function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		if (frm.txtAssunto.value == "") {
			alert("O  Assunto deve ser informado !");
			frm.txtAssunto.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descricao deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDataAta.value == "") {
			alert("A Data da Ata deve ser informada !");
			frm.txtDataAta.focus();
			return false;
		}
		
		if (frm.txtAnoLetivo.value == "") {
			alert("O Ano Letivo deve ser informado !");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
		
		frm.action="sca_ata_reuniao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}