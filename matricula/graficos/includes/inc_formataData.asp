<%
'formata a data para inserir no Banco de Dados
function formataDataBD(data)
	if data<>"" then
		
		dia = day(data)
		mes = month(data)
		ano = year(data)
		
		horario = ""
		if len(data)>10 then
			horario = " "
			
			hora    = hour(data)
			minuto  = minute(data)
			segundo = second(data)
			
			horario = horario & hora & ":" & minuto  & ":" & segundo
				
		end if
		
		if len(dia)<2 then dia = "0" & dia
		if len(mes)<2 then mes = "0" & mes
		
		data =  ano & "/" & mes & "/" & dia	& horario
		formataDataBD = data
	end if
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
		
		data =  dia & "/" & mes & "/" & ano
		formataDataAP = data
	end if

end function

'Formata a data para consultar
function formataDataCon(data)
	if isnull(data) then data=""
		
	if trim(cstr(data)) <> "" then
		dia = day(data)
		mes = month(data)
		ano = year(data)
		
		if len(dia)<2 then dia = "0" & dia
		if len(mes)<2 then mes = "0" & mes
		
		data = mes & "/" & dia & "/" & ano
	end if
	
	formataDataCon = "#" & data & "#"
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
'Função para calcular a idade para a renumeração.
function calculaIdadeRenumera(data)
	dd2 = day(date)
	mm2 = month(date) + 1
	yy2 = year(date)
	
	dd = 30
	mm = 04
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
	calculaIdadeRenumera = strIdade
end function

'Função para calcular a idade para a renumeração.
function calculaIdadeLimite(data, anoLetivo)
	dd2 = 30
	mm2 = 04
	yy2 = anoLetivo
	
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
	
	strIdade = cstr(suaIdade)
	calculaIdadeLimite = strIdade
end function

function formatacpf(cpf)
	if cpf<>"" then
		cpf = mid(cpf,1,3) & "." & mid(cpf,4,3) & "." & mid(cpf,7,3) & "-" & mid(cpf,10,2)
		formataCPF = cpf
	end if
end function
%>