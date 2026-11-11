<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 

'Não armazena a página em buffer antes de mostra-la na tela'
'response.Buffer = false
response.Expires=0
Server.ScriptTimeOut = 8000

%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<%
    cod_atividade_aluno                          = request.Form("cod_atividade_aluno")
	cod_atividade_pai                          	 = request.Form("cod_atividade_pai")
	
	sql = "delete EAD_Atividade_aluno "
	sql = sql & " WHERE cod_atividade_aluno = " & cod_atividade_aluno
	cnn.execute sql
	GravarLogEaD "Imagem da atividade foi removida",cod_atividade_pai,0,0,0

	response.redirect "enviar_foto.asp?id_atv=" & cod_atividade_pai
%>
