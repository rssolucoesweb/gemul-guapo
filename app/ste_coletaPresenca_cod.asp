<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodRota				= Trim(Request.QueryString("txtCodRota"))
	intCodSolicitacao		= Trim(Request.QueryString("txtCodSolicitacao"))
	strData					= Trim(Request.QueryString("txtData"))
	
	if acao="I" then

		sql = "SET NoCount ON Insert Into ste_presenca(cod_rota, Cod_solicitacao_transporte, data, usuario_incl, data_hora_incl)"
		sql = sql & " Values ("
		sql = sql & "" & intCodRota & ","
		sql = sql & "" & intCodSolicitacao & ","
		sql = sql & "'" & formatadataBD(strData) & "',"
		sql = sql & "'" & session("usuarioWeb") & "',getDate())"
		cnn.Execute(sql)
		GravarLog sql

	elseif acao="E" then
		codSolicitacao = request("cod_solicitacao_transporte")
		
		strMensagem = "Alunos excluído do transporte escolar com sucesso..."
		
		sql = "Delete from ste_presenca"
		sql = sql & " Where cod_solicitacao_transporte = " & intCodSolicitacao
		sql = sql & " and cod_rota = " & intCodRota
		sql = sql & " and data = '" & formatadataBD(strData) & "'"
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		response.write "ok"
		response.end
	else
		cnn.rollbacktrans
		response.write "erro"
	end if
%>
