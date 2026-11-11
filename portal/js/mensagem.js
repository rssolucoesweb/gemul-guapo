function salvar(acao){
	if ($("#cmbProfessor").val()=="0"){
		alert("Professor(a) deve ser informado!");
		$("#assunto").focus();
		return false
	}
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

function editar(id){
	$("#id").val(id);
	$("form").submit();
}