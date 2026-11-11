<%
on error resume next

Function getCodigoBarras(ByVal Numeros)	
	Dim F, F1, F2, i, Texto  
	Dim arrCodigoBarra(99)  
	Dim htmlCodigoBarra  
	htmlCodigoBarra = ""  
	Const Fino      = 1  
	Const Largo     = 3  
	Const Altura    = 30  

	if isempty(arrCodigoBarra(0)) Then  
		arrCodigoBarra(0) = "00110"  
		arrCodigoBarra(1) = "10001"  
		arrCodigoBarra(2) = "01001"  
		arrCodigoBarra(3) = "11000"  
		arrCodigoBarra(4) = "00101"  
		arrCodigoBarra(5) = "10100"  
		arrCodigoBarra(6) = "01100"  
		arrCodigoBarra(7) = "00011"  
		arrCodigoBarra(8) = "10010"  
		arrCodigoBarra(9) = "01010"  
		For F1 = 9 To 0 Step -1  
			For F2 = 9 To 0 Step -1  
				F = F1 * 10 + F2  
				Texto = ""  
				For i = 1 To 5  
					Texto = Texto & Mid(arrCodigoBarra(F1), i, 1) + Mid(arrCodigoBarra(F2), i, 1)  
				Next  
				arrCodigoBarra(f) = Texto  
			Next  
		Next
	End if  

	'Construindo o código HTML do código de barras  
	'Guarda inicial  
	htmlCodigoBarra = htmlCodigoBarra & "<img src=""../../images/p.jpg"" width=" & Fino & " height=" & Altura & " border=0>"  
	htmlCodigoBarra = htmlCodigoBarra & "<img src=""../../images/b.jpg"" width=" & Fino & " height=" & Altura & " border=0>"  
	htmlCodigoBarra = htmlCodigoBarra & "<img src=""../../images/p.jpg"" width=" & Fino & " height=" & Altura & " border=0>"  
	htmlCodigoBarra = htmlCodigoBarra & "<img src=""../../images/b.jpg"" width=" & Fino & " height=" & Altura & " border=0>"  
	htmlCodigoBarra = htmlCodigoBarra & "<img"  
	'Response.Write htmlCodigoBarra  
	Texto = Numeros  

	if Len(Texto) Mod 2 <> 0 Then Texto = "0" & Texto End if  
	'HTML dos dados  
	Do While Len(Texto) > 0  
	i       = Cint(Left(Texto,2))  
	Texto   = Right(Texto, Len(Texto)- 2)  
	F       = arrCodigoBarra(i)  
	For i = 1 To 10 Step 2  
		If Mid(F, i, 1) = "0" Then  
			F1 = Fino  
		Else  
			F1 = Largo  
		End If  
		   
		htmlCodigoBarra = htmlCodigoBarra & " src=""../../images/p.jpg"" width=" & F1 & " height=" & Altura & " border=0><img"  
		   
		If mid(F, i + 1, 1) = "0" Then  
			F2 = Fino  
		Else  
			F2 = Largo  
		End If  

		htmlCodigoBarra = htmlCodigoBarra & " src=""../../images/b.jpg"" width=" & F2 & " height=" & Altura & " border=0><img"  

		Next  
	Loop  

	'Guarda final  
	htmlCodigoBarra = htmlCodigoBarra & " src=""../../images/p.jpg"" width=" & Largo & " height=" & Altura & " border=0>"  
	htmlCodigoBarra = htmlCodigoBarra & "<img src=""../../images/b.jpg"" width=" & Fino & " height=" & Altura & " border=0>"  
	htmlCodigoBarra = htmlCodigoBarra & "<img src=""../../images/p.jpg"" width=""1"" height=" & Altura & " border=0>"
	
	'Retornando a função  
	getCodigoBarras = htmlCodigoBarra	
End Function 

if err.number <> 0 then
	response.Write(Texto)
	response.End()
end if
%>