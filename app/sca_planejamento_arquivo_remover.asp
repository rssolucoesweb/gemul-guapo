<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
codigo = Request.Form("codigo")

sql = "DELETE FROM sca_planejamento_arquivo WHERE codigo = " & codigo
cnn.Execute sql

Response.Write "OK"
%>