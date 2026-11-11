<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 05/07/2011
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Contratos
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

	intCodigoPL	 		= Trim(Request.Form("codPL"))
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	intCodFonteRecurso	= trim(Trim(Request.Form("cmbFonteRecurso")))
	intValor	= replace(replace(trim(Request.Form("txtValor")),".",""),",",".")
	
	' Dados do Usuario
	strUsuario_incl   	= session("strNomeUsuario")
	strData_hora_incl 	= formatadataBD(date) & " " & time 
	strUsuario_altr   	= session("strNomeUsuario")
	strData_hora_altr 	= formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Insert Into SCC_previsao_liquidacao_fonte_recurso ( "
		sql = sql & " codPrevisaoLiquidacao,"
		sql = sql & " codFonteRecurso,"
		sql = sql & " valorFonte,"
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodigoPL & ","
		sql = sql & "" & intCodFonteRecurso & ","
		
		if intValor  = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intValor & ","
		end if
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	elseif acao="A" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Update SCC_previsao_liquidacao_fonte_recurso Set "
		sql = sql & "CodPrevisaoLiquidacao=" & intCodigoPL & ","
		sql = sql & "CodFonteRecurso=" & intCodFonteRecurso & ","
		
		if intValor  = "" then
			sql = sql & "valorFonte = null,"
		else
			sql = sql & "valorFonte = " & intValor & ","
		end if
		

		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		sql = sql & " And CodEmpresa = " & intCodEmpresa 
		
	else
		strMensagem = "Registro excluido com sucesso..."
		
		sql = "Delete from SCC_previsao_liquidacao_fonte_recurso "
		sql = sql & " Where Codigo = " & intCodigo
	
	end if
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='LiquidacaoDespesasFonteRecurso_cad.asp?codPL=<%=intCodigoPL%>';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>