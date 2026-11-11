<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<%

ID_EMPRESA 			= Session("CodEmpresaAluno_GemulEad")
DESCRICAO 			= REQUEST.FORM("DESCRICAO")

id 					= Trim(Request("i"))
acao				= Trim(Request("a"))

'*****************
'EXCLUIR
'*****************
if trim(id) <> "" and acao="E" then
	sql = "delete from EAD_LEMBRETE"
	sql = sql & " Where COD_LEMBRETE = " & id
	sql = sql & " And COD_EMPRESA = " & ID_EMPRESA
	cnn.execute sql
end if 
response.redirect("painel.asp")
%>
