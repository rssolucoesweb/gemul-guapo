/*
	::	IMOB
	::	Data de Criação...: 12/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Inclusão de controle acesso menu imob (pagina de validação)
	::	Desenvolvedores...: 
	::	Data Atualizacao..: 
*/	

	var intContMarcado=0;		

	function salvar(acao){
		var frm = document.getElementById("frm");
		if (frm.txtCPF.value == "0"){
			alert("O CPF do servidor deve ser informado!");
			frm.txtCPF.focus();
			return false;
		}	
		if (frm.cmbSubsecretaria.value == "0"){
			alert("A Subsecretaria deve ser informada!");
			frm.cmbSubsecretaria.focus();
			return false;
		}			
		
		frm.action= "Seg_ControleAcessoSRE_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function selPerfil(codPerfil, codSre){
		var frm = document.getElementById("frm");
		frm.cmbCodPerfilMenu.value 	= codPerfil;
		frm.cmbSubsecretaria.value 	= codSre;
		frm.action="Seg_ControleAcessoSRE_cad.asp";
		frm.submit();
	}	
