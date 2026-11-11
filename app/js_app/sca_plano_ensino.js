	
	function reload(){
		
		var frm = document.getElementById("frm");
		frm.submit();
	}
	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function blocTexto(valor, id)
	{
		quant = 500;
		total = valor.length;
		if(total <= quant)
		{
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}
		else
		{
			document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
		}
	}
	
	
	function salvar(acao){
	
		var frm = document.getElementById("frm");

		if (acao =="E") {
			var men = 'ATENÇÃO: Deseja realmente excluír o plano de ensino?\n'
			if (confirm(men)) {
				frm.action="Sca_plano_Ensino_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			}else{
				return false;
			}
		}
		else 
		{
			if (frm.cmbCurso.value == "0") {
				alert("O Curso deve ser informado !");
				frm.cmbCurso.focus();
				return false;
			}
		
			if (frm.cmbPeriodo.value == "0") {
				alert("O Periodo deve ser informado !");
				frm.cmbPeriodo.focus();
				return false;
			}
		
			if (frm.cmbGrade.value == "0") {
				alert("A Grade deve ser informada !");
				frm.cmbGrade.focus();
				return false;
			}
		
			if (frm.cmbDisciplinaGrade.value == "0") {
				alert("A Disciplina deve ser informada !");
				frm.cmbDisciplinaGrade.focus();
				return false;
			}
			if (frm.cmbPlanoEnsino.value == "0") {
				alert("A ementa deve ser informada !");
				frm.cmbPlanoEnsino.focus();
				return false;
			}
			frm.action="sca_plano_ensino_cod.asp?acao=" + acao;
			frm.submit();
			return true;		
		}

		

 	}