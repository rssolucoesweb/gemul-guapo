		
	function abreSetores(codRota){
		frm.action="ste_transporte_rota_setor.asp?txtCodRota=" + codRota;
		frm.submit();
		return true;
 	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtNome.value == ""){
			alert("A rota deve ser informada.");
			frm.txtNome.focus();
			return false;
		}	
		
		if (frm.txtDistanciaPercorrida.value == ""){
			alert("A distancia percorrida deve ser informada.");
			frm.txtDistanciaPercorrida.focus();
			return false;
		}			
		
		
		if (frm.txtCapacidade.value == ""){
			alert("A capacidade deve ser informada.");
			frm.txtCapacidade.focus();
			return false;
		}
		
		
		frm.action="sca_transporte_rota_escola_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	
		function abreModalSetores(codRota) {
			$('#modalSetores').modal('show');
			$('#divListaSetores').html('carregando setores...');
				$.post( "ste_rota_unidade_cod.asp", 
				{ 
					acao: 'LISTA_SETORES',
					cod_rota: codRota
				}
			)
			.done(function( data ) {
				
				$("#divListaSetores").html(data);
				
			})
			.fail(function() {
				toastr.error("Ocorreu um erro");
			}); 
			
		}	

		function abreModalUnidades(codRota) {
			$('#modalUnidades').modal('show');
			$('#divListaUnidades').html('carregando unidades...');
				$.post( "ste_rota_unidade_cod.asp", 
				{ 
					acao: 'LISTA_UNIDADES',
					cod_rota: codRota
				}
			)
			.done(function( data ) {
				
				$("#divListaUnidades").html(data);
				
			})
			.fail(function() {
				toastr.error("Ocorreu um erro");
			}); 
			
		}