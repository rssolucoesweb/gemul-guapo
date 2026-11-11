<%
	' Conta o numero de visitantes
	'on error resume next
	cnn.begintrans
	
	sql = "SELECT Max(Qtde) as Qtde" 
	sql = sql & " FROM SCA_ContadorVisita"
	sql = sql & " Where Cod_Grupo = " & Session("CodGrupo")
	rsAux.open sql, cnn
	
	if not rsAux.EOF then
	
		if rsAux("Qtde") <> "" then
			intQtde = cstr(rsAux("Qtde")) + 1
		else
			intQtde = 1	
		end if
	
	end if
	rsAux.close
	
	session("NumVisitantes") = intQtde
	strNumPortalAluno = intQtde
	
	sql = "Update SCA_ContadorVisita Set"
	sql = sql & " Qtde = " & intQtde
	sql = sql & " Where Cod_Grupo = " & Session("CodGrupo")
	cnn.execute sql
	
	if err.number = 0 then
		cnn.commitTrans
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>