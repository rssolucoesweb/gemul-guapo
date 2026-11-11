		
	function abreSetores(codRota){
		frm.action="ste_transporte_rota_setor.asp?txtCodRota=" + codRota;
		frm.submit();
		return true;
 	}
	
	function salvarSetores(){
		
		var frm = document.getElementById("frm");
		var codRota = frm.txtCodRota.value;		

		frm.action="ste_transporte_rota_vincula_cod.asp?acao=GRAVA_SETORES&txtCodRota" + codRota ;
		frm.submit();
		return true;
 	}

	
		function abreModalSetores(codRota) {
			$('#modalSetores').modal('show');
			$('#divListaSetores').html('carregando setores...');
				$.post("ste_transporte_rota_vincula_cod.asp", 
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

