<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	codigo 			= Trim(Request("codigo"))
	qtde			= Trim(Request("qtde"))
	acao			= Trim(Request("acao"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
	
	if acao = "QUANTIDADE" then
		sql = " update est_requisicaoproduto "
		sql = sql & " set quantidade_autorizada = " & qtde & ","
		sql = sql & " 	usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " 	data_hora_altr = '" & strData_hora_altr& "'"
		sql = sql & " 	where codigo = " & codigo
		cnn.execute sql
	elseif acao = "TOMBAMENTO" then
		sql = " update est_requisicaoproduto "
		sql = sql & " set numero_tombamento = '" & qtde & "',"
		sql = sql & " 	usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " 	data_hora_altr = '" & strData_hora_altr& "'"
		sql = sql & " 	where codigo = " & codigo
		cnn.execute sql
	end if
%>