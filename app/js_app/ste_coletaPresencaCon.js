	
function gravaPresenca(marcacao, codSolicitacao, codRota, data) {
    const acao = marcacao ? "I" : "E";

    // Monta os parâmetros da URL
    const params = new URLSearchParams({
        acao: acao,
        txtCodSolicitacao: codSolicitacao,
        txtCodRota: codRota,
		txtData: data
    });

    // Faz a chamada assíncrona via GET (poderia ser POST também)
    fetch("ste_coletaPresenca_cod.asp?" + params.toString(), {
        method: "GET"
    })
    .then(response => {
        if (!response.ok) {
            throw new Error("Erro na requisição");
        }
        return response.text(); // ou .json() se o retorno for JSON
    })
    .then(data => {
        //console.log("Resposta recebida:", data);
        // aqui você pode mostrar feedback ao usuário
        //alert("Presença registrada com sucesso.");
    })
    .catch(error => {
        console.error("Erro:", error);
        alert("Ocorreu um erro ao registrar a presença.");
    });

    return false; // evita qualquer comportamento extra
}
	


function validaDataSelecionada(input) {
    const valor = input.value;

    if (!valor) {
        alert("Por favor, preencha a data.");
        input.focus();
        return false;
    }

    // Verifica se a data é válida usando o objeto Date
    const data = new Date(valor);
    if (isNaN(data.getTime())) {
        alert("Data inválida.");
        input.focus();
        return false;
    }

    // Exemplo: não permitir datas futuras
    const hoje = new Date();
    hoje.setHours(0, 0, 0, 0); // remove a hora para comparação limpa
    if (data > hoje) {
        alert("A data informada é maior que a data atual, verifique!");
        return false;
    }

    return true;
}
