	function MarcaTodasPerguntas(valor){
		
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
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="I") {
			
			if (frm.cmbFichaDescritiva.value == ""){
				alert("A Ficha descritiva deve ser informada.");
				frm.cmbFichaDescritiva.focus();
				return false;
			}
	
			if (frm.txtDescricao.value == "") {
				alert("A Pergunta deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
		
		}
		
		if (acao=="E"){
			
			var intContMarcado =0;
			var intCodPergunta = "0";
			
			for (var i = 0; i < frm.elements.length; i++) 
			{

				//verifica todos os checkbox
				if (frm.elements[i].name == "chkPergunta"){				
					if (frm.elements[i].checked) {
						intContMarcado = intContMarcado + 1;
						intCodPergunta = intCodPergunta + "," + frm.elements[i].value;
					}
				}
			}
			
			if (intContMarcado==0){
				alert("ATENCAO: Pelo menos uma pergunta deve ser selecionada, Verifique!");
				return false;
			}

		}
	
		frm.action="sca_ficha_descritiva_pergunta_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}