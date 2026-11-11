function receber(CodAluno, codEmpresa){
		var frm = document.getElementById("frm");
		
		if (confirm("Você realmente deseja incluir esse aluno?")) { 
			frm.action = "sca_aluno.asp?receberTransferencia=S&txtCodAluno="+CodAluno+"&txtCodEmpresa="+codEmpresa;
			frm.submit();
			return true;
		}
	}
	function incluir_aluno_novo(CodAluno, codEmpresa){
		var frm = document.getElementById("frm");
		
		if (confirm("Você realmente deseja incluir aluno novo?")) { 
			frm.action = "sca_aluno.asp?AlunoNovo=S";
			frm.submit();
			return true;
		}
	}
	