<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->

<%

codigo_reserva = Request("codigo_reserva")
tipo           = Replace(Request("tipo"),"'","''")
obs            = Replace(Request("obs"),"'","''")

usuario = Trim(Session("usuarioWeb"))

sql = "INSERT INTO mat_reserva_historico ("
sql = sql & "codigo_reserva,"
sql = sql & "tipo_contato,"
sql = sql & "observacao,"
sql = sql & "usuario,"
sql = sql & "data_contato"
sql = sql & ") VALUES ("

sql = sql & codigo_reserva & ","
sql = sql & "'" & tipo & "',"
sql = sql & "'" & obs & "',"
sql = sql & "'" & usuario & "',"
sql = sql & "GETDATE()"
sql = sql & ")"

cnn.Execute sql

Response.Redirect Request.ServerVariables("HTTP_REFERER")

%>