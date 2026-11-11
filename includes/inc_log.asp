<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de log
-->
<%
	function GravarLog(strSqlLog)
		
		intCodEmp  		= Session("CodEmpresa")
		if intCodEmp = "" then intCodEmp = 0
		strLog_Usuario	= Session("UsuarioWeb")

		dia 			= day(date)
		mes 			= month(date)
		ano 			= year(date)
		strSqlLog 		= trim(replace(strSqlLog,"'",""))
		
		strDataLog = ano & "/" & mes & "/" & dia  & " " & time 
		
		intCodMensagem = 1
		
		if ucase(left(trim(strSqlLog),6)) = "INSERT" then intCodMensagem = 1 'Inclusao de Registro
		if ucase(left(trim(strSqlLog),6)) = "UPDATE" then intCodMensagem = 2 'Alteracao de Registro
		if ucase(left(trim(strSqlLog),6)) = "DELETE" then intCodMensagem = 3 'Exclusao de Registro
	
		ssql = "Insert Into SEG_LOG(Cod_Empresa, CodMensagem, Login_Usuario, DataLog, Sql)"
		ssql = ssql & " Values ("
		ssql = ssql & "" & intCodEmp & ","
		ssql = ssql & "" & intCodMensagem & ","
		ssql = ssql & "'" & strLog_Usuario & "',"
		ssql = ssql & "'" & strDataLog & "',"
		ssql = ssql & "'" & strSqlLog & "')"
		cnn.execute ssql
	
	end function
%>