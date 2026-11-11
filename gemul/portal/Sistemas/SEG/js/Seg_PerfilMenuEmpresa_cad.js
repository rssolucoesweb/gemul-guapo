/*
	::	IMOB
	::	Data de Criação...: 12/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Inclusão de perfil (pagina de validação)
	::	Desenvolvedores...: 
	::	Data Atualizacao..: 
*/	

	var intContMarcado=0;		

	function salvar(acao){
	var frm = document.getElementById("frm");
		if (frm.cmbCodPerfilMenu.value == "0"){
			alert("O perfil deve ser informado!");
			frm.txtDescricao.focus();
			return false;
		}		
/*		for (var i = 0; i < frm.elements.length; i++) {
			
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (frm.elements[i].checked){
					intContMarcado = intContMarcado + 1;
				}
			}
		}

		if (intContMarcado == 0){
			alert("O Menu e Subitem deve ser selecionado!");
			return false;
		}*/
		frm.action= "Seg_perfilMenuEmpresa_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function Marcar(valor){
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].name == "chkMenu"){
					if (valor=='S') 	form.elements[i].checked=true;
					if (valor=='N') 	form.elements[i].checked=false;
				}
			}
		}
	}	
	
