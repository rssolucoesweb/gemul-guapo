<%
strUnidades = ""
sql = "select SEG_empresa.nomefantazia"
sql = sql & " from SEG_usuarios_acesso"
sql = sql & " inner join SEG_empresa on SEG_empresa.codigo = SEG_usuarios_acesso.codEmpresa"
sql = sql & " where SEG_usuarios_acesso.cpf_SEG_usuarios = " & strCpfBD
sql = sql & " order by SEG_empresa.nomefantazia "	
RSAUX.OPEN SQL, CNN
IF NOT RSAUX.EOF THEN

	WHILE NOT RSAUX.EOF
		
		if trim(strUnidades) = "" then 
			strUnidades = rsAux("nomefantazia")
		else
			strUnidades = strUnidades & " | " & rsAux("nomefantazia")
		end if
		RSAUX.MOVENEXT
	WEND
		
END IF
RSAUX.CLOSE
response.Write(strUnidades)
%>