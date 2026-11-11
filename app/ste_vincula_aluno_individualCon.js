
function abreConsultaAluno(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
function mostraUnidade(){
		if (frm.rede.value == "M") {
			$("#linha_municipal").show();
			$("#linha_municipal2").show();
			$("#linha_estadual").hide();
		}
		else if (frm.rede.value == "E") {
			$("#linha_municipal").hide();
			$("#linha_municipal2").hide();
			$("#linha_estadual").show();			
		} 
		else {
			$("#linha_estadual").hide();
			$("#linha_municipal2").hide();
			$("#linha_municipal").hide();
		}
	}


	function gerarImpressao(cod_aluno, ano_letivo, cod_turma, cod_empresa, semestre){
		var caminho = "/app/sca_rel_ficha_individual_rel.asp?notas=N&txtCodAluno="+ cod_aluno + "&txtAnoLetivo="+ ano_letivo + "&cmbSemestre="+ semestre + "&cmbTurma=" + cod_turma + "&txtCodEmpresa=" + cod_empresa;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	function gerarImpressaoComprovante(codigo){
		var caminho = "/app/ste_rel_comprovante_rel.asp?txtCodigo="+ codigo;
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
	
	function Excluir(acao, cod_solicitacao_transporte){
		
		var frm = document.getElementById("frm");
		var men = 'ATENÇÃO: Deseja realmente excluir o aluno do transporte escolar?\n '
		if (confirm(men)) {
				
			frm.action="ste_vincula_aluno_individual_cod.asp?acao=" + acao + "&cod_solicitacao_transporte=" + cod_solicitacao_transporte;
			frm.submit();
			return true;

		} else {
			return false;
		}
	}

	function Incluir(acao, CodAluno, CodRota){
		
		var frm = document.getElementById("frm");
		frm.action="ste_vincula_aluno_individual_cod.asp?acao=" + acao + "&CodAluno=" + CodAluno + "&CodRota=" + CodRota;
		frm.submit();
		return true;
	}

	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		var intContMarcado=0;
		var CodAluno=frm.txtCodAluno.value;
		var CodRota=frm.cmbRota.value;
		
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
		if (frm.rede.value=="0") {
			alert("Qual a rede?");
			frm.rede.focus();
			return false
		}
		
		if (frm.rede.value=="M") {
			if (frm.txtCodAluno.value == ""){
				alert("Aluno não foi informado!");
				frm.txtMatricula.focus();
				return false;
			}
		}
		
		if (frm.cmbRota.value == 0){
			alert("A rota deve ser selecionada!");
			frm.cmbRota.focus();
			return false;
		}
		
		frm.action= "ste_vincula_aluno_individual_cod.asp?acao=" + acao + "&CodAluno=" + CodAluno + "&CodRota=" + CodRota;
		frm.submit();
		return true;
			
	}