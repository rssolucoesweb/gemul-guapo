		
	
	function salvarUnidades(){
		
		var frm = document.getElementById("frm");
		var codSetor = frm.txtCodSetor.value;		

		frm.action="ste_transporte_escola_vincula_cod.asp?acao=GRAVA_UNIDADES&txtCodSetor=" + codSetor;
		frm.submit();
		return true;
 	}

	
		function abreModalUnidades(codSetor, rede) {
			$('#modalUnidades').modal('show');
			$('#divListaUnidades').html('carregando unidades...');
				$.post("ste_transporte_escola_vincula_cod.asp", 
				{ 
					acao: 'LISTA_UNIDADES',
					cod_setor: codSetor,
					rede: rede

				}
			)
			.done(function( data ) {
				
				$("#divListaUnidades").html(data);
				
			})
			.fail(function() {
				toastr.error("Ocorreu um erro");
			}); 
			
		}	

