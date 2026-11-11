<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Colonia de Ferias - Valores
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strDescricao		= Replace(Trim(Request.Form("txtDescricao")),"'","")  
	strVlrDiaria 		= replace(replace(Trim(Request.Form("txtVlrDiaria")),".",""),",",".")  
	
	' Dados do Usuario
	strUsuario_incl   = session("strNomeUsuario")
	strData_hora_incl = formatadataBD(date) & " " & time 
	strUsuario_altr   =	session("strNomeUsuario")
	strData_hora_altr = formatadataBD(date) & " " & time 
		
	if acao="I" then
		
		strMensagem = "Valor da Colônia salvo com sucesso..."
		
		sql = "Insert Into CLU_ColoniaValores (CodEmpresa, Descricao, VlrDiaria, "
		sql = sql & " Usuario, DataIncl, UsuarioAlt, DataAlt)" 
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strVlrDiaria & ","
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
			
	elseif acao="A" then
		
		strMensagem = "Valor da Colônia Alterado com sucesso..."
		
		sql = "Update CLU_ColoniaValores Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " VlrDiaria = " & strVlrDiaria & ","
		sql = sql & " UsuarioAlt = '" & strUsuario_incl  & "',"
		sql = sql & " DataAlt = '" & strData_hora_incl  & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
	
	else
		strMensagem = "Valor da Colônia Excluido com sucesso..."
		
		sql = "Delete From CLU_ColoniaValores "
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
			window.location='ColoniaValores_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>