// Transporte > Vincula aluno a rota - REDE ESTADUAL (grava por AJAX em ste_vincula_aluno_estadual_cod.asp)

function veMascaraCpf(c) {
	var v = c.value.replace(/\D/g, "").substring(0, 11);
	if (v.length > 9) v = v.replace(/^(\d{3})(\d{3})(\d{3})(\d+)$/, "$1.$2.$3-$4");
	else if (v.length > 6) v = v.replace(/^(\d{3})(\d{3})(\d+)$/, "$1.$2.$3");
	else if (v.length > 3) v = v.replace(/^(\d{3})(\d+)$/, "$1.$2");
	c.value = v;
}
function veMascaraData(c) {
	var v = c.value.replace(/\D/g, "").substring(0, 8);
	if (v.length > 4) v = v.replace(/^(\d{2})(\d{2})(\d+)$/, "$1/$2/$3");
	else if (v.length > 2) v = v.replace(/^(\d{2})(\d+)$/, "$1/$2");
	c.value = v;
}
function veMascaraFone(c) {
	var v = c.value.replace(/\D/g, "").substring(0, 11);
	if (v.length > 10) v = v.replace(/^(\d{2})(\d{5})(\d+)$/, "($1) $2-$3");
	else if (v.length > 6) v = v.replace(/^(\d{2})(\d{4})(\d+)$/, "($1) $2-$3");
	else if (v.length > 2) v = v.replace(/^(\d{2})(\d+)$/, "($1) $2");
	c.value = v;
}
function veMascaraCep(c) {
	var v = c.value.replace(/\D/g, "").substring(0, 8);
	if (v.length > 5) v = v.substring(0, 5) + "-" + v.substring(5);
	c.value = v;
	if (v.length == 9 && c.getAttribute("data-buscado") != v) {
		c.setAttribute("data-buscado", v);
		veBuscaCep(v.replace("-", ""));
	}
}

// Endere\u00e7o pelo CEP (ViaCEP). Se n\u00e3o responder, preenche \u00e0 m\u00e3o.
function veBuscaCep(cep) {
	$.ajax({
		url: "https://viacep.com.br/ws/" + cep + "/json/",
		dataType: "json",
		timeout: 5000,
		success: function (r) {
			if (!r || r.erro) return;
			if (r.logradouro) $("#txtLogradouroEst").val(r.logradouro.toUpperCase());
			if (r.bairro) $("#txtBairroEst").val(r.bairro.toUpperCase());
			if (r.localidade) $("#txtCidadeEst").val(r.localidade.toUpperCase());
			if (r.uf) $("#txtUfEst").val(r.uf.toUpperCase());
			$("#txtNumeroEst").focus();
		}
	});
}

function vePost(acao, dadosExtras, onOk, botao) {
	var textoBotao = botao ? botao.innerHTML : "";
	if (botao) { botao.disabled = true; botao.innerHTML = "Aguarde..."; }
	// os campos do formul\u00e1rio s\u00f3 v\u00e3o se estiverem habilitados
	var fs = document.getElementById("veCampos");
	var estava = fs ? fs.disabled : false;
	if (fs) fs.disabled = false;
	var dados = $("#frm").serialize() + (dadosExtras || "");
	if (fs) fs.disabled = estava;
	$.ajax({
		url: "ste_vincula_aluno_estadual_cod.asp?acao=" + acao,
		type: "POST",
		data: dados,
		dataType: "json",
		cache: false,
		success: function (r) {
			if (botao) { botao.disabled = false; botao.innerHTML = textoBotao; }
			if (r && r.ok) onOk(r);
			else alert((r && r.mensagem) ? r.mensagem : "N\u00e3o foi poss\u00edvel gravar.");
		},
		error: function () {
			if (botao) { botao.disabled = false; botao.innerHTML = textoBotao; }
			alert("Erro de comunica\u00e7\u00e3o. Atualize a tela (F5) e tente de novo.");
		}
	});
}

function veAviso(html, tipo) {
	document.getElementById("veAvisoCpf").innerHTML = html ? '<div class="alert alert-' + (tipo || "info") + ' py-2 mb-0">' + html + "</div>" : "";
}

function veEsc(t) {
	return String(t == null ? "" : t).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function vePreenche(d) {
	$("#txtCodSolicitacaoEst").val(d ? d.codigo : "");
	$("#txtNomeEst").val(d ? d.nome : "");
	$("#txtNascimentoEst").val(d ? d.nascimento : "");
	$("#txtMaeEst").val(d ? d.mae : "");
	$("#cmbSexoEst").val(d ? d.sexo : "");
	$("#txtContatoEst").val(d ? d.contato : "");
	$("#txtCelularEst").val(d ? d.celular : "");
	$("#txtFoneMaeEst").val(d ? d.fonemae : "");
	$("#txtFonePaiEst").val(d ? d.fonepai : "");
	$("#txtEmailEst").val(d ? d.email : "");
	$("#txtCepEst").val(d ? d.cep : "").attr("data-buscado", d ? d.cep : "");
	$("#txtLogradouroEst").val(d ? d.logradouro : "");
	$("#txtNumeroEst").val(d ? d.numero : "");
	$("#txtComplementoEst").val(d ? d.complemento : "");
	$("#txtBairroEst").val(d ? d.bairro : "");
	$("#txtCidadeEst").val(d ? d.cidade : "");
	$("#txtUfEst").val(d ? (d.uf || "GO") : "GO");
	$("#txtUnidadeConsumidoraEst").val(d ? d.unidade_consumidora : "");
}

function veBuscarCpf() {
	var cpf = $("#txtCpfEst").val().replace(/\D/g, "");
	if (cpf.length != 11) { alert("Informe o CPF do aluno com 11 n\u00fameros."); $("#txtCpfEst").focus(); return; }
	vePost("CPF", "", function (r) {
		var fs = document.getElementById("veCampos");
		if (!r.existe) {
			vePreenche(null);
			fs.disabled = false;
			veAviso("CPF sem solicita\u00e7\u00e3o neste ano. Preencha os dados do aluno.", "success");
			$("#txtNomeEst").focus();
			return;
		}
		var d = r.dados;
		if (d.cod_aluno) {
			vePreenche(null);
			fs.disabled = true;
			veAviso("Este CPF \u00e9 de aluno da <strong>rede municipal</strong> com transporte neste ano (" + veEsc(d.nome) + "). Use a rede Municipal.", "warning");
			return;
		}
		vePreenche(d);
		fs.disabled = false;
		var txt = "CPF j\u00e1 tem solicita\u00e7\u00e3o: <strong>" + veEsc(d.nome) + "</strong>";
		txt += d.situacao == "D" ? " - vinculado \u00e0 rota <strong>" + veEsc(d.rota_desc) + "</strong>" : " - pedido do site, ainda sem rota";
		if (d.escola_desc) txt += " (" + veEsc(d.escola_desc) + ", " + veEsc(d.turno) + ")";
		txt += ". Confira os dados e clique em <strong>Gravar e vincular \u00e0 rota</strong> para colocar nesta escola, turno e rota.";
		veAviso(txt, "info");
	}, null);
}

function veEditar(codigo) {
	vePost("BUSCAR", "&codigo=" + encodeURIComponent(codigo), function (r) {
		var d = r.dados;
		vePreenche(d);
		$("#txtCpfEst").val(d.cpf); veMascaraCpf(document.getElementById("txtCpfEst"));
		document.getElementById("veCampos").disabled = false;
		veAviso("Editando <strong>" + veEsc(d.nome) + "</strong>. Ao gravar, o aluno fica nesta escola, turno e rota.", "info");
		document.getElementById("panel-est-2").scrollIntoView();
	}, null);
}

function veLimparForm() {
	vePreenche(null);
	$("#txtCpfEst").val("");
	document.getElementById("veCampos").disabled = true;
	veAviso("");
	$("#txtCpfEst").focus();
}

function veContador(delta) {
	var c = document.getElementById("veContVinculado");
	if (c) c.innerHTML = Math.max(0, (parseInt(c.innerHTML, 10) || 0) + delta);
}

function veLinhaVinculada(codigo) {
	var rota = $("#txtNomeRotaEstadual").val();
	var linha = $("#veLinha_" + codigo);
	linha.find(".ve-situacao").text("Vinculado");
	linha.find(".ve-rota").text(rota);
	linha.find(".ve-comprovante").html('<img style="cursor:pointer" onclick="return gerarImpressaoComprovante(\'' + codigo + '\')" src="../../images/impressora_on.gif" width="26" height="26">');
	linha.find(".ve-acao").html('<button type="button" class="btn btn-outline-info btn-sm" onclick="veEditar(\'' + codigo + '\')">Editar</button> <button type="button" class="btn btn-outline-danger btn-sm" onclick="veExcluir(this, \'' + codigo + '\')">Excluir</button>');
	linha.addClass("table-success");
}

function veValida() {
	var obrig = [
		["txtNomeEst", "o nome do aluno"], ["txtNascimentoEst", "a data de nascimento"], ["txtMaeEst", "o nome da m\u00e3e"],
		["cmbSexoEst", "o sexo"], ["txtContatoEst", "o telefone de contato"], ["txtCepEst", "o CEP"],
		["txtLogradouroEst", "o endere\u00e7o"], ["txtBairroEst", "o bairro"], ["txtUfEst", "a UF"],
		["txtCidadeEst", "o munic\u00edpio"], ["txtUnidadeConsumidoraEst", "a unidade consumidora (energia)"]
	];
	for (var i = 0; i < obrig.length; i++) {
		var c = document.getElementById(obrig[i][0]);
		if (c.value.replace(/^\s+|\s+$/g, "") == "") { alert("Informe " + obrig[i][1] + "."); c.focus(); return false; }
	}
	if (!/^\d{2}\/\d{2}\/\d{4}$/.test($("#txtNascimentoEst").val())) { alert("Data de nascimento no formato dd/mm/aaaa."); $("#txtNascimentoEst").focus(); return false; }
	if ($("#txtCepEst").val().replace(/\D/g, "").length != 8) { alert("Informe o CEP com 8 n\u00fameros."); $("#txtCepEst").focus(); return false; }
	return true;
}

function veGravar(botao) {
	if ($("#txtCpfEst").val().replace(/\D/g, "").length != 11) { alert("Informe o CPF e clique na lupa."); $("#txtCpfEst").focus(); return; }
	if (!veValida()) return;
	vePost("GRAVAR", "", function (r) {
		var cod = r.codigo;
		if ($("#veLinha_" + cod).length == 0) {
			// linha nova no topo da lista
			$("#veLinhaVazia").remove();
			var cpf = $("#txtCpfEst").val();
			var html = '<tr id="veLinha_' + cod + '"><td>' + veEsc($("#txtNomeEst").val().toUpperCase()) + "</td><td>" + veEsc(cpf) + "</td><td>" + veEsc($("#txtNascimentoEst").val()) +
				'</td><td class="ve-situacao"></td><td class="ve-rota"></td><td class="ve-comprovante"></td><td class="ve-acao"></td></tr>';
			$("#veTabela tbody").prepend(html);
			veContador(1);
		} else if ($("#veLinha_" + cod).find(".ve-situacao").text() != "Vinculado") {
			veContador(1);
		}
		veLinhaVinculada(cod);
		alert(r.mensagem);
		veLimparForm();
	}, botao);
}

function veVincular(botao, codigo) {
	vePost("VINCULAR", "&codigo=" + encodeURIComponent(codigo), function (r) {
		veLinhaVinculada(codigo);
		veContador(1);
	}, botao);
}

function veExcluir(botao, codigo) {
	if (!confirm("Retirar este aluno estadual da rota?\n\nPedido feito pelo site volta para Solicitado; cadastro feito no GEMUL \u00e9 exclu\u00eddo.")) return;
	vePost("EXCLUIR", "&codigo=" + encodeURIComponent(codigo), function (r) {
		var linha = $("#veLinha_" + codigo);
		veContador(-1);
		if (r.voltou_solicitado) {
			linha.find(".ve-situacao").text("Solicitado (site)");
			linha.find(".ve-rota").text("");
			linha.find(".ve-comprovante").html("");
			linha.find(".ve-acao").html('<button type="button" class="btn btn-outline-info btn-sm" onclick="veEditar(\'' + codigo + '\')">Editar</button> <button type="button" class="btn btn-outline-success btn-sm" onclick="veVincular(this, \'' + codigo + '\')">Vincular</button>');
			linha.removeClass("table-success");
		} else {
			linha.remove();
		}
	}, botao);
}
