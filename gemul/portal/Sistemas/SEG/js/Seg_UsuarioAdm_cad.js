/*
	::	IMOB
	::	Data de Criação...: 02/04/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Inclusão de usuario (pagina de validação)
	::	Desenvolvedores...: 
	::	Data Atualizacao..: 
*/	

function salvar(acao){
	var frm = document.getElementById("frm");
	if (frm.txtCPF.value == "") {
		alert("O CPF deve ser informado!");
		frm.txtCPF.focus();
		return false;
	} 
	
	if (frm.cmbCodPerfilMenu.value == "0") {
		alert("O perfil deve ser informado!");
		frm.cmbCodPerfilMenu.focus();
		return false;
	}
	
	if (frm.cmbSituacao.value == "0") {
		alert("A situação deve ser informada!");
		frm.cmbSituacao.focus();
		return false;
	} 
	frm.action="Seg_UsuarioAdm_cod.asp?acao=" + acao;
	frm.submit();
	return true;	 
}

function selPerfil(codPerfil){
	var frm = document.getElementById("frm");
	frm.cmbCodPerfilMenu.value 	= codPerfil;
	frm.action="Seg_UsuarioAdm_cad.asp";
	frm.submit();
}	

function validar_Email() {
	var email = frm.txtEmail.value;
	if (email != ""){
		if (email.indexOf('@') == -1 || email.indexOf('.') == -1) {
			alert ('Este e-mail é inválido');
			frm.txtEmail.value = '';
			frm.txtEmail.focus();
		}
	}  
}   
