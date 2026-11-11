<%
'formata a data para inserir no Banco de Dados
function formataDataBD(data)
	if data<>"" then
		formataDataBD = year(data) & "/" & month(data) & "/" & day(data)
	end if
end function

function formataDataBDAccess(data)
	if data<>"" then
		formataDataBDAccess = year(data) & "/" & month(data) & "/" & day(data)
	end if
end function

function ZeroLeft(valor,tam) 

	cZero = "" 
	if Len(Trim(cStr(valor))) < tam then 
		For n = 1 to tam - Len(Trim(cStr(valor))) 
			cZero = cZero & "0" 
		Next 
	end if 
	ZeroLeft = cZero & Trim(cStr(valor)) 

end function 
'Formata a data para apresentar na Tela
function formataTimeBD(valor)
	if isnull(valor) then valor=""
		
	if trim(valor) <> "" then
		
		segundo = Second(valor)
		minuto = Minute(valor)
		hora = Hour(valor)
		
		if len(segundo)<2 then segundo = "0" & segundo
		if len(minuto)<2 then minuto = "0" & minuto
		if len(hora)<2 then hora = "0" & hora
		
		valor = hora & minuto & segundo
	end if
	
	formataTimeBD = valor
end function
'Formata a data para apresentar na Tela
function formataDataCalc(data)
	if isnull(data) then data=""
		
	if trim(cstr(data)) <> "" then
		dia = day(data)
		mes = month(data)
		ano = year(data)
		
		if len(dia)<2 then dia = "0" & dia
		if len(mes)<2 then mes = "0" & mes
		
		data = ano & mes & dia
	end if
	
	formataDataCalc = data
end function

'Formata a data para apresentar na Tela
function formataDataAP(data)
	if isnull(data) then data=""
		
	if trim(cstr(data)) <> "" then
		dia = day(data)
		mes = month(data)
		ano = year(data)
		
		if len(dia)<2 then dia = "0" & dia
		if len(mes)<2 then mes = "0" & mes
		
		data = dia & "/" & mes & "/" & ano
	end if
	
	formataDataAP = data
end function

'função que calcula a idade a partir da data de nascimento
function calculaIdade(data)
	dd2 = day(date)
	mm2 = month(date) + 1
	yy2 = year(date)
	
	dd = day(data)
	mm = month(data)
	yy = year(data)
	
	
	if yy2 < 100 then	
		yy2 = yy2 + 1900
	end if
	suaIdade = yy2 - yy
	
	if mm2 < mm then
		suaIdade = suaIdade - 1
	end if
	
	if mm2 = mm then 
		if dd2 < dd then 
			suaIdade = suaIdade - 1
		end if
	end if
	
	strIdade = cstr(suaIdade) + " "
	calculaIdade = strIdade
end function

function PegaDiaSemana(data)  
	strDiaSemana = "domingo,segunda-feira,terça-feira,quarta-feira,quinta-feira,sexta-feira,sábado"  
	arrayDiaSemana = split(strDiaSemana, ",")  
	PegaDiaSemana = arrayDiaSemana(weekday(data)-1)
end function

%>