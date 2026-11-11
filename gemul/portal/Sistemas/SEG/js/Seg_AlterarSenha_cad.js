/*
	::	IMOB
	::	Data de Criação...: 18/03/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Alterar Senha (pagina de validação)
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
	/*if (frm.txtSenhaAntiga.value == "") {
		alert("Senha antiga deve ser informada!");
		frm.txtSenhaAntiga.focus();
		return false;
	} */
	if (frm.txtSenha.value == "") {
		alert("A Nova senha deve ser informada!");
		frm.txtSenha.focus();
		return false;
	} 	
	if (frm.txtSenha.value == frm.txtSenhaAntiga.value) {
		alert("A senha nova deve ser diferente da senha antiga!");
		frm.txtSenha.value = "";
		frm.txtCSenha.value = "";
		frm.txtSenha.focus();
		return false;
	}
		
	if (frm.txtSenha.value != "") {
		if (frm.txtSenha.value.length < 6 ) {
			alert("A senha deve ter pelo menos 6 dígitos!");
			frm.txtSenha.value = "";
			frm.txtCSenha.value = "";
			frm.txtSenha.focus();
			return false;
		}
		
		if (frm.txtSenha.value != frm.txtCSenha.value) {
			alert("As senhas não conferem, tente novamente!");
			frm.txtSenha.value = "";
			frm.txtCSenha.value = "";
			frm.txtSenha.focus();
			return false;
		}
	} 
	frm.action="Seg_AlterarSenha_cod.asp?acao=" + acao;
	frm.submit();
	return true;	 
}