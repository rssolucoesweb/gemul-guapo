	function salvar(acao){
		
		
		var frm = document.getElementById("frm");

		if (frm.txtNomealuno.value==""){
			alert("Atenção: Aluno não foi encontrado, verifique a matrícula digitada.")
			return false
		}
		frm.action="sca_historico_escolar_novo.asp";
		frm.submit();
		return true;
 	}
	
	function resultadoConsulta(intCodigo, strMatricula){
		
		
		var frm = document.getElementById("frm");

		frm.action="sca_historico_escolar_novo.asp?codhistoricoEscolar=" + intCodigo + "&txtMatricula=" + strMatricula;
		frm.submit();
	}
	
	function editarDisciplinas(intCodigo){
		
		
		var frm = document.getElementById("frm");

		frm.action="sca_historico_escolar_novo_disciplina.asp?codhistoricoEscolar=" + intCodigo
		frm.submit();
	}
	
	function limpaHistorico(intCodHit, intCodAluno, strMatricula){
		
		
		var frm = document.getElementById("frm");
		var men = 'ATENÇÃO: \nDeseja realmente excluír os dados do histório neste ano e semestre, todos lançamentos serão removidos, deseja continuar?';
		
		if (confirm(men)) {
			frm.action="sca_historico_escolar_novo_exc.asp?codAluno=" + intCodAluno + "&intCodHit=" + intCodHit + "&matricula=" + strMatricula;
			frm.submit();
		} else {
			return false;
		}

	}	
	function importar(){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value==""){
			alert("Atenção: A matrícula do aluno deve ser informada.")
			frm.txtMatricula.focus();
			return false
		}
		
		frm.action="sca_historico_escolar_importar.asp";
		frm.submit();
		return true;
 	}