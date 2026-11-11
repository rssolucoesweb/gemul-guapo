<%	
    strCompartilharDados = ""
	sql = "SELECT COMPARTILHAR_DADOS "
	sql = sql & " FROM SEG_EMPRESA "
	sql = sql & " where CODIGO = " & Session("CodEmpresa")		
	rs.open sql, cnn
 	if rs.eof = false then
	   strCompartilharDados = trim(rs("COMPARTILHAR_DADOS"))
	end if
	rs.close
%>
