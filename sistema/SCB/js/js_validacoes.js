function validaCpf(cpf)
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