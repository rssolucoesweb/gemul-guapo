//MASCARA DE DATA e CPF
function validaCpfDigitado(obj){
	
	if (obj.value!="" && obj.value!="___.___.___-__"){
		if(!ValidaCpf(obj.value)){
			alert("O CPF informado não é válido.");
			obj.focus();
			obj.select();
			return false;
		}else
			return true;
	}
}

function ValidaCpf(cpf)
{				
	//retira tudo que não for número
	cpf = cpf.replace(/\D/g,'');
	
	if (cpf.length != 11)
		return false;
		
	//verifica se todos os dígitos são iguais
	if (cpf.search(/^(\d)\1*$/) != -1)
		return false;
		
	var soma;
	var dv;
	var resto;				
	
	for (var i=0;i<=1;i++)
	{
		soma = 0;
		for (var j=0;j<=8+i;j++)
		{
			soma += cpf.charAt(j) * (10+i-j);
		}
		resto = soma % 11;
		dv = resto < 2 ? 0 : 11 - resto;
		if (dv != cpf.charAt(9+i))
			return false;
	}
	return true;
}

function ValidaCnpj(cnpj)
{
	//retira tudo que não for número
	var cnpj = cnpj.replace(/\D/g,'');				
	if (cnpj.length != 14)
		return false;
	
	var soma;
	var dv;				
	var resto;
	
	for(i=0;i<=1;i++)
	{					
		soma = 0;
		for(j=0;j<=3+i;j++) 
		{
			soma += cnpj.charAt(j) * (5+i-j);
		}					
		for(j=4+i;j<=11+i;j++)
		{
			soma += cnpj.charAt(j) * (13+i-j);
		}					
		resto = soma % 11;					
		dv = resto < 2 ? 0 : 11 - resto;					
		if (dv != cnpj.charAt(12+i))
			return false;
	}
	return true;
}

/*
Função usada para validar uma data, a qual pode estra nos seguintes formatos:
-> dd/mm/aaaa;
-> dd/mm/aa
-> d/m/aaaa;
-> d/m/aa";
*/
function validaDataDigitada(obj){
	if (obj.value!="" && obj.value!="__/__/____"){
		if(!ValidaData(obj.value)){
			alert("A Data informada não é válida");
			obj.focus();
			obj.select();
		}
	}	
}

function ValidaData(data)
{
	//A data deve possuir 10 caracteres
	if (data.length != 10)
		return false;		

	var er = new RegExp(/^((0[1-9]|[12]\d)\/(0[1-9]|1[0-2])|30\/(0[13-9]|1[0-2])|31\/(0[13578]|1[02]))\/\d{4}$/);
	if (!er.test(data))
		return false;
		
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//A expressão regular acima não leva em consideração anos bissextos, então é necessário fazer tal validação//
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	var arrData = data.split('/');
	var dia = parseInt(arrData[0]);
	var mes = parseInt(arrData[1]);
	var ehAnoBissexto = parseInt(arrData[2]) % 4 == 0 ? true : false;
	
	if (mes == 2)
	{
		if (ehAnoBissexto && dia > 29)
			return false;
		if (!ehAnoBissexto && dia > 28)
			return false;
	}	
	
	return true;	
}

/*
A data deve estar previamente validada nos seguintes formatos:
-> dd/mm/aaaa;
-> dd/mm/aa
-> d/m/aaaa;
-> d/m/aa";

A função abaixo verifica se a data final é maior que a data inicial
retorna true se a final for maior e false, caso contrário
*/
function ComparaDatas(dataInicial,dataFinal)
{				
	var arrDataInicial = dataInicial.split('/');
	var arrDataFinal = dataFinal.split('/');
	
	var arrDataFinal = dataFinal.split('/'); 							
	
	var diaI = parseInt(arrDataInicial[0]);
	var diaF = parseInt(arrDataFinal[0]);
	
	var mesI = parseInt(arrDataInicial[1]);
	var	mesF = parseInt(arrDataFinal[1]);
				
	var anoI = parseInt(arrDataInicial[2]);
	var anoF = parseInt(arrDataFinal[2]);				
	
	if (anoI > anoF)
		return false;
	if (anoI < anoF)
		return true;
						
	if (mesI > mesF)
		return false;
	if (mesI < mesF)
		return true;
		
	if (diaI > diaF)
		return false;
	
	return true;	
}

function ValidaEmail(email)
{	
	//definindo a expressão regular que valida o email
	var er = new RegExp(/^[A-Za-z0-9_\-\.]+@[A-Za-z0-9_\-\.]{2,}\.[A-Za-z0-9]{2,}(\.[A-Za-z0-9])?/);
	if (er.test(email))
		return true;
	else
		return false;
}

