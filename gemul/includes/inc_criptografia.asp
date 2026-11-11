<!--
	::	PORTAL
	::	Data de Criação...: 16/01/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto.barbosa@see.go.gov.br
	::	Objetivo Pagina...: Inicio da Funcao de Criptografia
	::  Atualização.......: 
-->
<%
	Function FormatCripto(StrCripto, BolAcao)
	
	Dim X , i, n, TamChave, Valor
	Dim aChaves(9)
		
	aChaves(0) = 77
	aChaves(1) = 84
	aChaves(2) = 79
	aChaves(3) = 65
	aChaves(4) = 73
	aChaves(5) = 78
	aChaves(6) = 67
	aChaves(7) = 70
	aChaves(8) = 82
	
	X = Empty
	
	For i = 1 To Len(StrCripto)
		
	n = Asc(Mid(StrCripto, i, 1))
	If n > 31 Then
		n = n - 32
		If BolAcao Then
			Valor = 1
		Else
			Valor = -1
		End If
		n = n + (aChaves((i - 1) Mod 9)) * Valor
		n = n Mod 224
		If n < 0 Then
		n = 224 + n
	    End If
	n = n + 32
	End If
	
	X = X & Chr(n)
	Next
	FormatCripto = X
	End Function
	'********** Fim da Funcao de Criptografia ****************
%>