<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="JSON_2.0.4.asp"-->
<!--#include file="JSON_UTIL_0.1.1.asp"-->

<%

	'on error resume next
	
   strTipoAcao = trim(Request("tipoAcao"))

	select case ucase(strTipoAcao)
        case "VALIDA_LOGIN"
            login = trim(Request("login"))

			SQL = "SELECT distinct 0, 'Login cadastrado para outro usuario por favor tente outro.' as nome"
			SQL = SQL & " FROM SRH_COLABORADOR"
			SQL = SQL & " WHERE codigo_SEG_USUARIOS_SISTEMA = '" & trim(login) & "'"
			SQL = SQL & " UNION "
			SQL = SQL & " SELECT distinct 0, 'Login cadastrado para outro usuario por favor tente outro.' as nome"
			SQL = SQL & " FROM SEG_USUARIOS_SISTEMA"
			SQL = SQL & " where Usua_Codg = '"& trim(login) & "'"
			
	end select

	QueryToJSON(cnn, sql).Flush

%>