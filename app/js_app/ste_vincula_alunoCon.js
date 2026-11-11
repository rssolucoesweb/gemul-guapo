	function gerarImpressao(cod_aluno, ano_letivo, cod_turma, cod_empresa, semestre){
		var caminho = "/app/sca_rel_ficha_individual_rel.asp?notas=N&txtCodAluno="+ cod_aluno + "&txtAnoLetivo="+ ano_letivo + "&cmbSemestre="+ semestre + "&cmbTurma=" + cod_turma + "&txtCodEmpresa=" + cod_empresa;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	function gerarImpressaoComprovante(cod_aluno, ano_letivo, cod_turma, cod_empresa, semestre, cod_rota){
		var caminho = "/app/ste_rel_comprovante_rel.asp?txtCodAluno="+ cod_aluno + "&txtAnoLetivo="+ ano_letivo + "&cmbSemestre="+ semestre + "&cmbTurma=" + cod_turma + "&txtCodEmpresa=" + cod_empresa + "&txtCodRota=" + cod_rota;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	
	function marcaTodos(valor){
		var frm = document.getElementById("frm");
		var i;
		for (var i = 0; i < frm.elements.length; i++) {
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				frm.elements[i].checked=valor;
			}
		}
	}
	
	function Excluir(acao, CodAluno, CodRota){
		
		var frm = document.getElementById("frm");
		var men = 'ATENÇÃO: Deseja realmente excluir este vinculo da rota do aluno?\n '
		if (confirm(men)) {
				
			frm.action="ste_vincula_aluno_cod.asp?acao=" + acao + "&CodAluno=" + CodAluno + "&CodRota=" + CodRota ;
			frm.submit();
			return true;

		} else {
			return false;
		}
	}

	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		var intContMarcado=0;
		var strAlunos='';
		
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
	
		if (frm.cmbRota.value == 0){
			alert("A rota deve ser selecionada!");
			frm.cmbRota.focus();
			return false;
		}
		
		//*****verifica se um aluno foi selecionado
		intContMarcado=0;
		for (var i = 0; i < frm.elements.length; i++) {
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox"){
				if (frm.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (frm.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}	
		
		if (intContMarcado==0){
			alert("O(s) aluno(s) deve(m) ser selecionado(s)!");
			return false;
		}
		
		frm.action= "ste_vincula_aluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
			
	}