<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	if strSituacao = "" or strSituacao = "0" then strSituacao = "A"

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		existeAmesmaDescricao = "N"
		'REGRA PARA INCLUSAO
		sql = "SELECT descricao" 
		sql = sql & " FROM MAT_setores"
		sql = sql & " WHERE descricao = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then

			sql = "Insert Into MAT_setores(descricao, cod_grupo, situacao)"
			sql = sql & " Values ("
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'" & session("codGrupo") & "',"
			sql = sql & "'" & strSituacao & "')"
			cnn.execute sql
			GravarLog sql			

		else
			existeAmesmaDescricao = "S"
		end if
		rs.close
		
		if existeAmesmaDescricao = "S" then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Existe o mesmo registro cadastrado, verifique!");
				window.history.back();
			</script>
			<%
		end if
		
		

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update MAT_setores Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " situacao = '" & strSituacao & "'"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
		
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from MAT_setores "
		sql = sql & " where codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ste_setor.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>