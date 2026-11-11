	function gerarImpressao(cod_aluno, ano_letivo, cod_turma, cod_empresa, semestre){
		var caminho = "/app/sca_rel_ficha_individual_rel.asp?notas=N&txtCodAluno="+ cod_aluno + "&txtAnoLetivo="+ ano_letivo + "&cmbSemestre="+ semestre + "&cmbTurma=" + cod_turma + "&txtCodEmpresa=" + cod_empresa;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	function gerarImpressaoComprovante(codigo){
		var caminho = "/app/ste_rel_comprovante_rel.asp?txtcodigo="+ codigo;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}

	
	function salvarEncaminhamento(){
		
		var frm = document.getElementById("frm");
		var codSolicitacao = frm.txtCodSolicitacao.value;
		var codSituacao = frm.cmbSituacaoEncaminhamento.value;
		var codRota = frm.cmbRota.value;
		
		if (codSituacao == "D"){
			if (codRota=="" || codRota == "0"){
				alert("Rota deve ser selecionada!");
				frm.cmbRota.focus();
				return false;
			}
		}
		if (codSituacao=="" || codSituacao == "0"){
			alert("Situação deve ser selecionada!");
			frm.cmbSituacaoEncaminhamento.focus();
			return false;
		}
		
		if (codSituacao=="D" || codSituacao == "I"){
			if (codSituacao=="D") var men = 'ATENCAO: \nAo DEFERIR essa solicitação, o aluno será efetivado nessa rota e não poderá ser mais alterado, deseja continuar?';
			if (codSituacao=="I") var men = 'ATENCAO: \nAo INDEFERIR essa solicitação, o aluno não será efetiavado e não poderá ser mais alterado, deseja continuar?';
			if (confirm(men)) {
				frm.action="ste_transporte_acompanhamento_cod.asp?acao=GRAVA_ENCAMINHAMENTO&txtCodSolicitacao=" + codSolicitacao + "&txtCodSituacao=" + codSituacao + "&txtCodRota=" + codRota;
				frm.submit();
				return true;	
			}
		} else {
			frm.action="ste_transporte_acompanhamento_cod.asp?acao=GRAVA_ENCAMINHAMENTO&txtCodSolicitacao=" + codSolicitacao + "&txtCodSituacao=" + codSituacao + "&txtCodRota=" + codRota;
			frm.submit();
			return true;
		}
 	}
	function salvarAlteracao(){
		
		var frm = document.getElementById("frm");
		var codSolicitacao = frm.txtCodSolicitacao.value;
		var turno_estadual = frm.turno_estadual.value;
		var rede = frm.cmbRede.value;
		var situacao = frm.cmbSituacao.value;
		var setor = frm.cmbSetor.value;
		var turno = frm.cmbTurno.value;
		
		if (turno_estadual == "0"){
			alert("Turno deve ser selecionado!");
			frm.turno_estadual.focus();
			return false;
		}
		
		frm.action="ste_transporte_acompanhamento_cod.asp?acao=GRAVA_ALTERACAO&txtCodSolicitacao=" + codSolicitacao + "&turno_estadual=" + turno_estadual + "&cmbSituacao=" + situacao + "&cmbSetor=" + setor + "&cmbRede=" + rede + "&cmbTurno=" + turno;
		frm.submit();
		return true;
 	}
	
	function cancelaSituacao(codigo){
		var frm = document.getElementById("frm");
		var men = 'ATENCAO: \Deseja cancelar a solicitação, com essa ação a solicitação passará para cadastro de reserva, deseja continuar?';
		if (confirm(men)) {
			frm.action="ste_transporte_acompanhamento_cod.asp?acao=CANCELA_SITUACAO&txtCodSolicitacao=" + codigo;
			frm.submit();
			return true;	
		}
 	}
	function excluirCadastro(codigo){
		
		var frm = document.getElementById("frm");
		var men = 'ATENCAO: \Deseja EXCLUIR a solicitação, com essa ação a solicitação será exluída definitivamente, deseja continuar?';
		if (confirm(men)) {
			frm.action="ste_transporte_acompanhamento_cod.asp?acao=EXCLUIR_CADASTRO&txtCodSolicitacao=" + codigo;
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

	
	function abreModalEncaminhamento(codSolicitacao) {
		$('#modalEncaminhamento').modal('show');
		
		$('#divListaSolicitacao').html('carregando solicitação...');
			$.post("ste_transporte_acompanhamento_cod.asp", 
			{ 
				acao: 'MOSTRA_SOLICITACAO',
				cod_solicitacao: codSolicitacao
			}
		)
		.done(function( data ) {
			
			$("#divListaSolicitacao").html(data);
			
		})
		.fail(function() {
			toastr.error("Ocorreu um erro");
		}); 
		
	}	

	function abreModalAlteracao(codSolicitacao) {
			$('#modalAlteracao').modal('show');
			
			$('#divListaAlteracao').html('carregando solicitação...');
				$.post("ste_transporte_acompanhamento_cod.asp", 
				{ 
					acao: 'MOSTRA_ALTERACAO',
					cod_solicitacao: codSolicitacao
				}
			)
			.done(function( data ) {
				
				$("#divListaAlteracao").html(data);
				
			})
			.fail(function() {
				toastr.error("Ocorreu um erro");
			}); 
			
		}	

