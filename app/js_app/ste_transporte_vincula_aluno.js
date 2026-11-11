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
	
	
	function salvarVinculo(){
		
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
		frm.action="ste_transporte_vincula_aluno_cod.asp?acao=GRAVA_ENCAMINHAMENTO&txtCodSolicitacao=" + codSolicitacao + "&txtCodSituacao=" + codSituacao + "&txtCodRota=" + codRota;
		frm.submit();
		return true;
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

