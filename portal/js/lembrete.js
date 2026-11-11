function salvar(acao){
	if ($("#assunto").val()==""){
		alert("Assunto deve ser informado!");
		$("#assunto").focus();
		return false
	}
	if ($("#descricao").val()==""){
		alert("Descrição deve ser informada!");
		$("#descricao").focus();
		return false
	}
	$("#acao").val(acao);
	$("form").submit();
}