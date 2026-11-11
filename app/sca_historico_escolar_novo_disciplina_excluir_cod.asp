<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="includes/inc_cnn.asp"-->

<%
dim id
id = Request.Form("id")

if isnumeric(id) then
    sql = "DELETE FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA WHERE codigo = " & id
    cnn.Execute sql
    Response.Write("OK")
else
    Response.Write("ERRO")
end if
%>