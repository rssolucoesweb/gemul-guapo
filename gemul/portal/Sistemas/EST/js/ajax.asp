<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../includes/inc_cnn.asp"-->
<%
	response.Clear()

	'Preenche o tipo de arquivo
	Response.ContentType = "text/xml; charset=ISO-8859-1"
	Response.expires = 0
	Response.expiresabsolute = Now() - 1
	Response.addHeader "pragma", "no-cache"         'não armazena no cache os dados gerados
	Response.addHeader "cache-control", "private"   'não armazena no cache os dados gerados
	Response.CacheControl = "no-cache"              'não armazena no cache os dados gerados	

	dim reqTipoAcao
	dim reqCodComp
	dim sql
	
	strTipoAcao = request("tipoAcao")
	tipo_usuario = Trim(Request("tipo_usuario"))
	intSecaoProduto = Trim(Request("CodSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = "0"
	xml = ""

	select case strTipoAcao
		case "carregaMaterial"									
			strDescricao = replace(Trim(Request("descricao")),"'","")
			sql = "EXECUTE EST_ListaProdutosParaSolicitacao '" & tipo_usuario & "'," & intSecaoProduto & "," & Session("CodEmpresa") & ",'" & strDescricao & "'"
			rs.open sql, cnn
	end select 
	
	if not rs.eof then
		vetDados = rs.getRows
	end if			
	rs.close
	
	xml = "<?xml version=""1.0"" encoding=""ISO-8859-1""?>"
	xml = xml & "<elementos>"		
	
	if isArray(vetDados) then
	
		for i=0 to ubound(vetDados,2)
		
			intCodigo  	 = trim(vetDados(0,i))
			strDescricao = trim(vetDados(1,i)) & " | " & UCASE(trim(vetDados(2,i))) & " |"
			 
			 
			xml = xml & "<elemento_superior>"				
			xml = xml & "<codigo>" & intCodigo & "</codigo>"
			xml = xml & "<descricao><![CDATA[" & strDescricao & "]]></descricao>" 
			xml = xml & "</elemento_superior>"						
														
		next
		
	else
			xml = xml & "<elemento_superior>"				
			xml = xml & "<codigo></codigo>"
			xml = xml & "<descricao></descricao>" 
			xml = xml & "</elemento_superior>"			

	end if	
	
	xml = xml & "</elementos>"	
	
	vetDados = null			
	
	response.Write(xml)
%>

