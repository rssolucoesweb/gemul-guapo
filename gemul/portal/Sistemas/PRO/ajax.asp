<%
response.Clear()
response.Charset = "iso-8859-1"
%>
<!--#include file="../../../includes/inc_cnn.asp"-->
<%
	strTipoAcao = request("strTipoAcao")
	select case strTipoAcao						
		case "CarregaBairro"
			intCodCidade = TRIM(request("codCidade"))
			if intCodCidade = "" then intCodCidade = "0"
			sql = " Select Codigo, CodCidade, Bairro "
			sql = sql & " from MAL_Bairro"
			sql = sql & " Where CodCidade = " & intCodCidade
			sql = sql & " order by Codigo"	
			rs.open sql, cnn, 3, 3
			if rs.eof = false then
				while not rs.eof
				  	response.Write rs("codigo") & ";" & TRIM(rs("Bairro")) & ";N|"
					rs.movenext
				wend
			else
				response.Write "0;Não Encontrado;N|" 
			end if
			rs.close						
	end select
%>