<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Videos
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo	 		= Trim(Request("txtCodigo"))
	strDescricao 		= Trim(Request("txtDescricao"))
	strLink				= Trim(Request("txtLink"))
	strData 			= formatadataBD(Trim(Request.Form("txtData")))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Vídeo salvo com sucesso..."
	
		sql = "Insert Into SIT_Video(CodEmpresa, Descricao, Link, Data, "
		sql = sql & " UsuarioIncl, DataIncl, UsuarioAlt, DataAlt)"          
		sql = sql & " Values ("
	
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strLink & "',"
		sql = sql & "'" & strData & "',"
	
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
			
	elseif acao="A" then
		
		strMensagem = "Vídeo Alterado com sucesso..."
		
		sql = "Update SIT_Video Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Link = '" & strLink & "',"
		sql = sql & " Data = '" & strData & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
	
	else
		
		strMensagem = "Vídeo Excluido com sucesso..."
		
		sql = "Delete from SIT_Video "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		
	end if
	
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Videos_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>