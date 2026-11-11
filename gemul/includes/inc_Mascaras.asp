<%

'Formato: dd/mm/aaaa
Public Function InsereMascaraData(valor)

	if valor = "" or valor= "Null"  or isnull(valor) then
		InsereMascaraData = ""
		exit Function
	end if

	arrData = split(valor,"/")
	dia = arrData(0)
	mes = arrData(1)
	ano = arrData(2)
	
	if dia < 10 then
		dia = 0 & dia
	end if
	if mes < 10 then
		mes = "0" & mes
	end if
	
	if len(ano) = 2 and ano >= 40 then
		if ano >= 40 then
			ano = "19" & ano
		else
			ano = "20" & ano
		end if
	end if
	
	InsereMascaraData = dia & "/" & mes & "/" & ano
End Function

Public Function InsereMascaraFone(valor)

	if trim(valor) <> "" then
	
		Set er = New RegExp
		
		valor = Replace(valor," ","")
	
		With er
		.Pattern = "\D" 'retira tudo que não for número da string
		.IgnoreCase = False
		.Global = True
		End With
		
		valor = er.Replace(valor,"")
		
		if valor = "" then
			InsereMascaraFone = ""
			exit function
		end if
		
		er.Pattern = "^0*"
		er.Global = False
		
		valor = er.Replace(valor,"") 'retira todos os zeros antes do número do telefone	
		
		if len(valor) > 10 then
			valor = Left(valor,10)
		end if
	
		if len(valor) < 10 then
			valor = String(10 - len(valor),"0") & valor
		end if
		
		er.Pattern = "^(\d{2})(\d{4})(\d{4})$"
		
		InsereMascaraFone = er.Replace(valor,"($1) $2-$3")
		
		Set er = Nothing
	
	else
		InsereMascaraFone = ""
	end if
	
End Function

Public Function InsereMascaraCep(valor)
	
	Set er = New RegExp
	
	With er
	.Pattern = "\D" 'retira tudo que não for número da string
	.IgnoreCase = False
	.Global = True
	End With
	
	valor = er.Replace(valor,"")
	
	if valor = "" then
		InsereMascaraCep = ""
		exit function
	end if
	
	if len(valor) > 8 then
		valor = Left(valor,8)
	end if
		
	if len(valor) < 8 then 
		valor = valor & String(8 - len(valor), "0")
	end if
	
	er.Global = False
	er.Pattern = "^(\d{5})(\d{3})$"
	
	InsereMascaraCep = er.Replace(valor,"$1-$2")
End Function

'Função retira da string tudo que não for número
Public Function RetiraMascaraGeral(valor)
	Set er = New RegExp
	
	With er
	.Pattern = "\D"
	.IgnoreCase = False
	.Global = True
	End With

	RetiraMascaraGeral = er.Replace(valor,"")
	
	Set er = Nothing
End Function

Public Function RetiraMascaraFone(valor)
	Set er = New RegExp
	
	With er
	.Pattern = "\D"
	.IgnoreCase = False
	.Global = True
	End With

	valor = er.Replace(valor,"")
	
	er.Pattern = "^0*"
	
	RetiraMascaraFone = er.Replace(valor,"")
	
	Set er = Nothing
End Function
%>