<%
function ReplaceRequest(str)
	ReplaceRequest = UCASE(trim(replace(str,"'"," ")))
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

%>