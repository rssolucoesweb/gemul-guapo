function resultadoConsulta(intCodigo) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = intCodigo;
    frm.action = "aee_acompanhamento.asp";
    frm.submit();
    return false;
}

function buscarPaciente() {
    var frm = document.getElementById("frm");
    var busca = (frm.txtBuscaPaciente.value || "").trim();
    if (busca === "") {
        alert("Informe a matrícula do aluno da rede ou o CPF do paciente externo.");
        frm.txtBuscaPaciente.focus();
        return false;
    }
    frm.txtCodigo.value = "0";
    frm.txtCodFichaPaciente.value = "";
    frm.action = "aee_acompanhamento.asp";
    frm.submit();
    return false;
}

function abrirConsultaPaciente() {
    var url = "aee_ficha_paciente_con.asp?modo=selecao&consultar=S";
    var tipo = document.getElementById("cmbTipoPacienteBusca");
    if (tipo && tipo.value) url += "&cmbTipoPaciente=" + encodeURIComponent(tipo.value);
    window.open(url, "consultaPacienteAEE", "width=1100,height=720,scrollbars=yes,resizable=yes");
    return false;
}

function selecionarPacienteAEE(codFicha, tipo, matricula, cpf, nome) {
    var frm = document.getElementById("frm");
    frm.txtCodigo.value = "0";
    frm.txtCodFichaPaciente.value = codFicha;
    frm.txtBuscaPaciente.value = (tipo === "R" ? matricula : cpf) || "";
    frm.action = "aee_acompanhamento.asp";
    frm.submit();
}

function adicionarLinhaLink() {
    var lista = document.getElementById("listaLinks");
    var linha = document.createElement("div");
    linha.className = "input-group mb-2 linha-link";
    linha.innerHTML = '<input type="text" class="form-control campo-link" placeholder="https://...">' +
        '<div class="input-group-append">' +
        '<button type="button" class="btn btn-outline-danger" onclick="removerLinhaLink(this);" title="Remover link">' +
        '<i class="fal fa-times"></i></button></div>';
    lista.appendChild(linha);
}

function removerLinhaLink(botao) {
    var linha = botao.closest(".linha-link");
    var lista = document.getElementById("listaLinks");
    if (!linha || !lista) return;
    var linhas = lista.querySelectorAll(".linha-link");
    if (linhas.length === 1) {
        var campo = linha.querySelector(".campo-link");
        if (campo) campo.value = "";
        return;
    }
    linha.remove();
}

function validarUrl(url) {
    if (url === "") return true;
    return /^(https?:\/\/)/i.test(url);
}

function limparCamposGeradosArquivos() {
    var container = document.getElementById("camposArquivosBase64");
    if (container) container.innerHTML = "";
    var qtdeArquivos = document.getElementById("txtQtdeArquivos");
    if (qtdeArquivos) qtdeArquivos.value = "0";
}

function prepararLinks() {
    var frm = document.getElementById("frm");
    var campos = document.querySelectorAll(".campo-link");
    var contador = 0;
    var antigos = frm.querySelectorAll(".link-gerado");
    antigos.forEach(function (item) { item.remove(); });

    for (var i = 0; i < campos.length; i++) {
        var url = (campos[i].value || "").trim();
        if (url === "") continue;
        if (!validarUrl(url)) {
            alert("Informe um link válido iniciado por http:// ou https://");
            campos[i].focus();
            return false;
        }
        contador++;
        var hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = "txtLink_" + contador;
        hidden.value = url;
        hidden.className = "link-gerado";
        frm.appendChild(hidden);
    }
    frm.txtQtdeLinks.value = contador;
    return true;
}

function arquivoParaBase64(arquivo) {
    return new Promise(function (resolve, reject) {
        var reader = new FileReader();
        reader.onload = function (evento) {
            try {
                var resultado = evento.target.result || "";
                var posicaoVirgula = resultado.indexOf(",");
                var base64 = posicaoVirgula >= 0 ? resultado.substring(posicaoVirgula + 1) : resultado;
                resolve({ nome: arquivo.name, tipo: arquivo.type || "application/octet-stream", base64: base64 });
            } catch (erro) { reject(erro); }
        };
        reader.onerror = function () { reject(new Error("Não foi possível ler o arquivo " + arquivo.name)); };
        reader.readAsDataURL(arquivo);
    });
}

async function prepararArquivos() {
    limparCamposGeradosArquivos();
    var input = document.getElementById("arquivoUpload");
    var container = document.getElementById("camposArquivosBase64");
    var frm = document.getElementById("frm");
    if (!input || !input.files || input.files.length === 0) {
        frm.txtQtdeArquivos.value = "0";
        return true;
    }
    try {
        for (var i = 0; i < input.files.length; i++) {
            var dados = await arquivoParaBase64(input.files[i]);
            var indice = i + 1;
            var nome = document.createElement("input");
            nome.type = "hidden"; nome.name = "txtArquivoNome_" + indice; nome.value = dados.nome;
            var tipo = document.createElement("input");
            tipo.type = "hidden"; tipo.name = "txtArquivoTipo_" + indice; tipo.value = dados.tipo;
            var conteudo = document.createElement("input");
            conteudo.type = "hidden"; conteudo.name = "txtArquivoBase64_" + indice; conteudo.value = dados.base64;
            container.appendChild(nome); container.appendChild(tipo); container.appendChild(conteudo);
        }
        frm.txtQtdeArquivos.value = input.files.length;
        return true;
    } catch (erro) {
        alert(erro.message || "Não foi possível preparar os arquivos para envio.");
        return false;
    }
}

async function salvar(acao) {
    var frm = document.getElementById("frm");
    if (acao === "E") {
        if (!confirm("Confirma a exclusão deste atendimento?")) return false;
        frm.action = "aee_acompanhamento_cod.asp?acao=E";
        frm.submit();
        return true;
    }
    if (!frm.txtCodFichaPaciente.value || frm.txtCodFichaPaciente.value === "0") {
        alert("Selecione um paciente antes de cadastrar o atendimento.");
        return false;
    }
    if (frm.txtDataAtendimento.value === "") {
        alert("A Data do Atendimento deve ser informada!");
        frm.txtDataAtendimento.focus();
        return false;
    }
    if (!frm.cmbConsultorio.value || frm.cmbConsultorio.value === "0") {
        alert("O Consultório deve ser informado!");
        frm.cmbConsultorio.focus();
        return false;
    }
    if (!frm.cmbProfissional.value || frm.cmbProfissional.value === "0") {
        alert("O Profissional deve ser informado!");
        frm.cmbProfissional.focus();
        return false;
    }
    if ((frm.txtAtendimento.value || "").trim() === "") {
        alert("O Atendimento deve ser informado!");
        frm.txtAtendimento.focus();
        return false;
    }
    if (!prepararLinks()) return false;
    var arquivosOk = await prepararArquivos();
    if (!arquivosOk) return false;
    frm.action = "aee_acompanhamento_cod.asp?acao=" + acao;
    frm.submit();
    return true;
}
