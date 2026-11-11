/*
	::	IMOB
	::	Data de Criação...: 12/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Inclusão de perfil (pagina de validação)
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
	
	frm.action="Seg_UsuarioAutorizacao_cod.asp?acao=" + acao;
	frm.submit();
	return true;	 
}

function validar_Email() {
	var email = frm.txtEmail.value;
	var frm = document.getElementById("frm");
	if (email != ""){
		if (email.indexOf('@') == -1 || email.indexOf('.') == -1) {
			alert ('Este e-mail é inválido');
			frm.txtEmail.value = '';
			frm.txtEmail.focus();
		}
	}  
}   
