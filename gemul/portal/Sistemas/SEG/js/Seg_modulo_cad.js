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
		if (frm.cmbCodSistema.value == "0"){
			alert("O Sistema deve ser informado!");
			frm.cmbCodSistema.focus();
			return false;
		}
		frm.action= "Seg_modulo_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function selPerfil(codPerfil){
		alert(codPerfil)
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=codPerfil;
		frm.action="Seg_modulo_cad.asp";
		frm.submit();
	}	
	