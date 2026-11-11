
var passoAtual;
var usuarios;
var optOrgaos = new Array();
var maskCpf = new Mask("###.###.###-##");
var maskTelefone = new Mask("(##)####-####");

function Init()
{	
	document.getElementById('txtNome').focus();	
	criarOptOrgao();
}


function ObtemUsuarioDoArray(nomeUsuario)
{	
	for (var i=0;i<usuarios.length;i++)
	{
		if (usuarios[i].getNome() == nomeUsuario)
			return usuarios[i];
	}
	return -1; 
}

/************************************************************************************
 * Esta função é responsável por preenhcer o conteúdo da variável global			*
 * 'optOrgaos'. Esta variável contém um array onde cada posição possui um objeto	*
 * do tipo option cujo atributo value é igual ao código do órgão e o atrituto		*
 * 'text' contém o nome do órgão.													*
 * A variável optOrgaos deve ser utilizada pelas combos que contém os órgãos		*
 * da SEE.																			*
 * A idéia é que essa variável seja preenchida via Ajax no início do carregamento	*
 * da página 'Default.asp'. Assim, quando o usuário chegar no Passo 4, o 			*
 * conteúdo da variável já estará preenchida, dando ao usuário a ilusão de que a	*
 * página foi carregada rapidamente.												*
 ***********************************************************************************/
 
function criarOptOrgao(){
	var destino = "Departamentos.xml.asp"
	ExecAjax(fimCriarOptOrgao, destino, undefined, true);
}

function fimCriarOptOrgao(xmlHttp){
	//Pega somente o conteúdo xml do xmlHTTP
	var xml = xmlHttp.responseXML;
	
	//Armazena todos os órgãos em um Array local
	var elementos = xml.getElementsByTagName(xml.documentElement.childNodes(0).tagName);
	
	//Percorre o array de órgãos e cria um novo array contendo, em cada posição, um option
	//cujo value = código do órgão e o text é o nome do órgão
	for(i = 0; i < elementos.length; i++) {
		optOrgaos[i] = document.createElement('option');
		optOrgaos[i].value = elementos[i].childNodes[0].text;
		optOrgaos[i].text = elementos[i].childNodes[1].text;
	}
	imprimirCmbOrgaoResponsavel(optOrgaos);
}