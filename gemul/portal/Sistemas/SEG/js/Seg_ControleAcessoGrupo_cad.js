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
		
		if (frm.txtCPF.value == ""){
			alert("O CPF deve ser informado!");
			frm.txtCPF.focus();
			return false;
		}
		if (frm.cmbGrupo.value == "0"){
			alert("O Grupo deve ser informado!");
			frm.cmbGrupo.focus();
			return false;
		}
		if (frm.cmbCodPerfilMenu.value == "0"){
			alert("O Perfil deve ser informado!");
			frm.cmbCodPerfilMenu.focus();
			return false;
		}
		frm.action= "Seg_ControleAcessoGrupo_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function selPerfil(codPerfil, codGrupo){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=codPerfil;
		frm.action="Seg_ControleAcessoGrupo_cad.asp";
		frm.submit();
	}	
	