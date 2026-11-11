<!--
	::	IMOB
	::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir grupo
	::	Data Atualizacao..: 
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strData		 		= formatadataBD(Trim(Request.Form("txtData")))
	strSituacao	 		= Trim(Request.Form("cmbSituacao"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		
		'verifica se a requisição já foi data saida no estoque
		validaBalanco = "S"
		sql = "select codigo"									
		sql = sql & " from EST_BALANCO "
		sql = sql & " where situacao = 'A' and Cod_Empresa = " & intCodEmpresa
		rs.open sql, cnn
		if not rs.eof then
			validaBalanco = "N"
		end if
		rs.close
		
		if trim(validaBalanco) = "N" then
			%>
				<script>
					alert("Já existe um balanço em aberto, verifique!");
					window.location='AbrirBalanco_cad.asp';
				</script>
			<%
			response.End()
		end if
		
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Insert Into EST_BALANCO(Cod_Empresa, Data, Situacao, "
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strSituacao & "',"

		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "Update EST_BALANCO Set"
		sql = sql & " Data = '" & strData & "',"
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		sql = sql & " And Cod_Empresa = " & intCodEmpresa 
		
	else
		strMensagem = "Registro excluida com sucesso..."
		
		sql = "Delete from EST_BALANCO "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_Empresa = " & intCodEmpresa 
	
	end if
	
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AbrirBalanco_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>