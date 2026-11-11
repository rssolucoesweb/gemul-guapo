<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<%

id 					= Trim(Request("i"))
acao				= Trim(Request("a"))

'*****************
'EXCLUIR
'*****************
if trim(id) <> "" and acao="L" then
	sql = "update EAD_MENSAGEM set situacao='L'"
	sql = sql & " Where COD_MENSAGEM = " & id
	cnn.execute sql
end if 
response.redirect("painel.asp")
%>
