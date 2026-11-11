<%
function formataCpfAP(cpf)
	'FORMATO DA cpf --> XXX.XXX.XXX-XX
	cpf = formataCpfBD(cpf)
	
	if len(cpf)<11 and cpf <>"" then
		'O banco de dados ignora o zero a esquerda.
		'Se o tamanho do cpf for menor que 11, acrescentar os zeros que estiverem faltando.
		cpf = string(11-len(cpf),"0") & cpf
	end if
	
	if cpf <> "" then strCpfFormatada = mid(cpf,1,3) & "." & mid(cpf,4,3) & "." & mid(cpf,7,3) & "-" & mid(cpf,10,2)
	formataCpfAP = strCpfFormatada
end function

function formataCpfBD(cpf)
	if trim(cpf)<>"" then
		intCpf = replace(trim(cpf),".","")
		intCpf = replace(trim(intCpf),"-","")
		formataCpfBD = intCpf
	else
		formataCpfBD = ""
	end if
end function

%>
