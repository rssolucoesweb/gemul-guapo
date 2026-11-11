<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="JSON_2.0.4.asp"-->
<!--#include file="JSON_UTIL_0.1.1.asp"-->
<%

	'on error resume next
	
    strTipoAcao	= trim(Request("tipoAcao"))
    strFiltro   = request("term")
    strTipoOpcao = trim(Request("strOpcaoEnvio"))
	select case ucase(strTipoAcao)
        case "CARREGA_PERIODO"
            intCodCurso = trim(Request("intCodCurso"))
			sql = "SELECT Cod_Periodo as codigo, Descricao as nome"
			sql = sql & " FROM SCA_PERIODO"
			sql = sql & " where cod_curso = " & intCodCurso
			sql = sql & " Order by Sequencia"

	end select

	QueryToJSON(cnn, sql).Flush

%>