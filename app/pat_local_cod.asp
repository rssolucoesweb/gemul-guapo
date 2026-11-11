<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodEmpresa			= Trim(Request.Form("cmbEmpresa"))
	strDescricao			= Trim(Request.Form("txtDescricao"))
	intCodTipoLocal			= Trim(Request.Form("cmbTipoLocal"))
	strLocalOrigem			= Trim(Request.Form("txtLocalOrigem"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	if strSituacao = "" or strSituacao = "0" then strSituacao = "A"
	if strLocalOrigem = "" then
		strLocalOrigemSQL = "NULL"
	else
		strLocalOrigemSQL = "'" & strLocalOrigem & "'"
	end if
	strUsuario = session("UsuarioWeb")

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		sql = "Insert Into PAT_LOCAL(cod_empresa, descricao, cod_tipo_local, cod_local_origem, situacao, usuario_incl)"
		sql = sql & " Values ("
		sql = sql & intCodEmpresa & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & intCodTipoLocal & ","
		sql = sql & strLocalOrigemSQL & ","
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strUsuario & "')"
		cnn.execute sql
		GravarLog sql			
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update PAT_LOCAL Set"
		sql = sql & " cod_empresa = " & intCodEmpresa & ","
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " cod_tipo_local = " & intCodTipoLocal & ","
		sql = sql & " cod_local_origem = " & strLocalOrigemSQL & ","
		sql = sql & " situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from PAT_LOCAL "
		sql = sql & " where codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='pat_local.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.\n\nObs: se o local estiver vinculado a algum patrimônio, não pode ser excluído.");
			window.history.back();
		</script>
		<%
	end if
%>
