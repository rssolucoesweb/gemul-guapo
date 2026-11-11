<%
function formataCnpjAP(cnpj)
	
	cnpj = formataCnpjBD(cnpj)
	
	if len(cnpj)<14 and cnpj <>"" then
		'O banco de dados ignora o zero a esquerda.
		'Se o tamanho do cnpj for menor que 14, acrescentar os zeros que estiverem faltando.
		cnpj = string(14-len(cnpj),"0") & cnpj
	end if
	
	if cnpj <> "" then strCnpjFormatada = mid(cnpj,1,2) & "." & mid(cnpj,3,3) & "." & mid(cnpj,6,3 ) & "/" & mid(cnpj,9,4) & "-" & mid(cnpj,13,2)
	formataCnpjAP = strCnpjFormatada
end function

function formataCnpjBD(cnpj)
	if trim(cnpj)<>"" then
		
		intCnpj = replace(trim(cnpj),".","")
		intCnpj = replace(trim(intCnpj),"/","")
		intCnpj = replace(trim(intCnpj),"-","")
		
		formataCnpjBD = intCnpj
	else
		formataCnpjBD = ""
	end if
end function
%>
