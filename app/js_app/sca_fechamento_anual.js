	
		function abreModal(codAluno, codTurma, codEmpresa, codCurso) {
			$('#modalResultado').modal('show');
			$('#divListaNotas').html('carregando resultado...');
				$.post( "sca_fechamento_resultado_notas.asp", 
				{ 
					cod_aluno: codAluno,
					cod_turma: codTurma,
					cod_empresa: codEmpresa,
					cod_curso: codCurso
				}
			)
			.done(function( data ) {
				
				$("#divListaNotas").html(data);
				
			})
			.fail(function() {
				toastr.error("Ocorreu um erro");
			}); 
			
		}	
		function abreModalSituacao(anoLetivo, codEmpresa) {
			$('#modalSituacao').modal('show');
			$('#divListaTurmas').html('carregando resultado...');
				$.post( "sca_fechamento_resultado_turmas.asp", 
				{ 
					cod_empresa: codEmpresa,
					ano_letivo: anoLetivo
				}
			)
			.done(function( data ) {
				
				$("#divListaTurmas").html(data);
				
			})
			.fail(function() {
				toastr.error("Ocorreu um erro");
			});
			
		}	


	function salvar(acao){
		
		if (document.getElementById("txtBloquearFechamento").value=="P"){
			alert("Fechamento não pode executado, verifique os alunos dessa turma na coluna ficha incompleta, estão com alguma pendência!");
		 	return false;
		}
		if (document.getElementById("txtBloquearFechamento").value=="M"){
			alert("Fechamento para essa turma não pode ser executado, existe aluno com situação de PRÉ-MATRÍCULA, corriga essa situação e tente novamente!");
		 	return false;
		}
		if (document.getElementById("txtBloquearFechamento").value=="E"){
			alert("Fechamento está em andamento para essa turma!");
		 	return false;
		}
		if (document.getElementById("txtBloquearFechamento").value=="F"){
			alert("Fechamento para essa turma já foi finalizado!");
		 	return false;
		}
		if (document.getElementById("cmbSituacaoAluno").value=="0"){
			alert("Situação Acadêmica de Destino deve ser informado!");
		 	return false;
		}
		alert("O fechamento da turma será processado em uma fila de execução, acompanhe a situação do aluno na tela de fechamento na coluna processamento!");
		
		if (!confirm("Confirma o fechamento anual da turma, esse procedimento não poderá ser cancelado?")) {
	        return;
		}

		var frm = document.getElementById("frm");
		
		frm.action="sca_fechamento_anual_cod.asp";
		frm.submit();
		return true;
 	}

	function MarcaTodosAlunos(valor){
		var form = document.getElementById("frm");
		var i;
	
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (form.elements[i].disabled==false) {
						form.elements[i].checked=valor;
					}
				}
			}
		}
	}