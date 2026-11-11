	function CursoResolucao(){
		window.open("CursoResolucao_cad.asp?CodCurso="+frm.txtCodigo.value,"consulta", "top=0,left=0,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}

	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDescAbreviada.value == "") {
			alert("A Descrição Abreviada deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		
		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		
		if (frm.cmbGrau.value == "0") {
			alert("O Grau deve ser informado !");
			frm.cmbGrau.focus();
			return false;
		}
				
		frm.action="sca_curso_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}