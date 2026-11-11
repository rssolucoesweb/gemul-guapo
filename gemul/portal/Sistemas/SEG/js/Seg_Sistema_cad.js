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
		
		if (frm.txtDescricao.value == ""){
			alert("O descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		frm.action= "Seg_sistema_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function selSistema(cod){
		frm.txtCodigo.value=cod;
		frm.action="Seg_sistema_cad.asp";
		frm.submit();
	}	
	