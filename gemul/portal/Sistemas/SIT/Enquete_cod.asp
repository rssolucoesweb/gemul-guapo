<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Enquete
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 			= Trim(Request.QueryString("acao"))
	intCodEmpresa	= session("codEmpresa")
	intCodEnquete 	= Trim(Request.Form("txtCodEnquete"))
	strPergunta  	= Trim(Request.Form("txtPergunta"))
	strData			= formatadataBD(Trim(request.Form("txtData")))
	strAtivo		= Trim(request.Form("chkAtivo"))
	
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 


	if strAtivo = "" then	
		strAtivo = "I"
	end if 
			
	if acao="I" then
		
		strMensagem = "Enquete Salva com sucesso..."
		
		if strAtivo = "A" then 
			sql = "UPDATE Enquete SET Status = 'I'"
			cnn.execute sql
		end if
	
		sql = "Insert Into SIT_Enquete( CodEmpresa, Pergunta, Date, Status, "
		sql = sql & " Usuario, DataIncl, UsuarioAlt, DataAlt)"   
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strPergunta & "',"
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strAtivo & "',"
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
		
	elseif acao="A" then
		
		strMensagem = "Enquete Alterada com sucesso..."
		
		sql = "Update SIT_Enquete Set"
		sql = sql & " Pergunta = '" & strPergunta & "',"
		sql = sql & " Status = '" & strAtivo & "'"
		sql = sql & " Where Codigo = " & intCodEnquete
		sql = sql & " And CodEmpresa = " & intCodEmpresa

	else
		strMensagem = "Enquete Excluido com sucesso..."
		
		sql = "Delete from SIT_EnqueteOpcao "
		sql = sql & " Where CodEnquete = " & intCodEnquete
		cnn.execute sql
		
		sql = "Delete from SIT_Enquete "
		sql = sql & " Where Codigo = " & intCodEnquete
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
			window.location='Enquete_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>