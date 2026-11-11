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
		if (frm.cmbCodEmpresa.value == "0"){
			alert("A Empresa deve ser informada!");
			frm.cmbCodEmpresa.focus();
			return false;
		}
		
		if (frm.cmbCodTipoAcesso.value == "0"){
			alert("O tipo de acesso deve ser informado!");
			frm.cmbCodTipoAcesso.focus();
			return false;
		}
		frm.action= "Seg_perfil_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function selPerfil(codPerfil){
		document.getElementById("txtCodigo").value=codPerfil;
		frm.action="Seg_perfil_cad.asp";
		frm.submit();
	}	
	