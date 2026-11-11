<%
	on error resume next
	Response.Clear()
	Response.CacheControl = "no-cache"
	Response.ContentType = "application/xml; charset=ISO-8859-1"

strCEP = replace(Trim(Request("txtCEP")), "-","")

Set CEP_obj = CreateObject("Correios.CEP") 
CEP_obj.EncontraCEP(strCEP) 

sub retornaErro
      response.write "<?xml version=""1.0"" encoding=""ISO-8859-1""?>"	
	  response.write "<webservicecep>"
	  response.write "<endereco></endereco>" 
	  response.write "<uf></uf>" 
	  response.write "<cidade></cidade>" 
	  response.write "<bairro></bairro>" 
	  response.write "</webservicecep>"
end sub

if err.number = 0 then
	If CEP_obj.Erro = 0 Then 
		  response.write "<?xml version=""1.0"" encoding=""ISO-8859-1""?>"	
		  response.write "<webservicecep>"
		  response.write "<endereco>" & CEP_obj.Endereco & "</endereco>" 
		  response.write "<uf>" & CEP_obj.Estado & "</uf>" 
		  response.write "<cidade>" & CEP_obj.Cidade & "</cidade>" 
		  response.write "<bairro>" & CEP_obj.Bairro & "</bairro>" 
		  response.write "</webservicecep>"		
	Else 
		'erro_descricao = CEP_obj.DescricaoErro 
		retornaErro		
	End If 
else
	retornaErro
end if

Set CEP_obj = Nothing 

%>

