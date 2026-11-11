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
		if (frm.cmbCodEmpresa.value == "0"){
			alert("A empresa deve ser informada!");
			frm.cmbCodEmpresa.focus();
			return false;
		}			
		if (frm.cmbCodPerfilMenu.value == "0"){
			alert("Perfil deve ser informado!");
			frm.cmbCodPerfilMenu.focus();
			return false;
		}			
		
		frm.action= "Seg_ControleAcesso_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function selPerfil(codPerfil, codEmp, codGrupo){
		var frm = document.getElementById("frm");
		frm.cmbCodPerfilMenu.value 	= codPerfil;
		frm.cmbCodEmpresa.value 	= codEmp;
		frm.cmbGrupo.value 	= codGrupo;
		
		frm.action="Seg_ControleAcesso_cad.asp";
		frm.submit();
	}	
