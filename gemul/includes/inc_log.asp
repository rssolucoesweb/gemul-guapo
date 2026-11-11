<%
	function GravarLog(strSqlLog, strPaginaAsp)
		
		strLog_Usuario	= trim(session("strNomeUsuario"))
		if strLog_Usuario = "" then strLog_Usuario = strLog_UsuarioAcessoInicial
		strPaginaAsp	= left(trim(strPaginaAsp),50)

		diaLog 			= day(date)
		mesLog 			= month(date)
		anoLog 			= year(date)
		strSqlLog 		= trim(replace(strSqlLog,"'",""))
		
		strDataLog = anoLog & "/" & mesLog & "/" & diaLog  & " " & time 
		intCodMensagem = 0
		
		if ucase(left(trim(strSqlLog),6)) = "INSERT" then intCodMensagem = 1 'Inclusao de Registro
		if ucase(left(trim(strSqlLog),6)) = "UPDATE" then intCodMensagem = 2 'Alteracao de Registro
		if ucase(left(trim(strSqlLog),6)) = "DELETE" then intCodMensagem = 3 'Exclusao de Registro

		sSql = "INSERT INTO SEG_Log_sistema (codMensagem, Login_Usuario, DataLog, paginaasp, DescricaoSql) values ("
		sSql = sSql & "" & intCodMensagem & ","
		sSql = sSql & "'" & strLog_Usuario & "',"
		sSql = sSql & "'" & strDataLog & "',"
		sSql = sSql & "'" & strPaginaAsp & "',"
		sSql = sSql & "'" & strSqlLog & "')"
		cnn.execute sSql
	
	end function
	
	function nomePagina(strPagina)
		caminho = strPagina
		For p = 1 to len(caminho)
		   if inStr(1,right(caminho,p),"/") = 0 then
			  nomePagina = (right(caminho,p))
		   else
			  exit for
		   end if
		next
	end function
%>