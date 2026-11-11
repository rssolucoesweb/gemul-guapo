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
	strDescricao			= Trim(Request.Form("txtDescricao"))
	strIndicadorBaixado		= Trim(Request.Form("chkIndicadorBaixado"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	if strSituacao = "" or strSituacao = "0" then strSituacao = "A"
	if strIndicadorBaixado = "on" then intIndicadorBaixado = 1 else intIndicadorBaixado = 0
	strUsuario = session("UsuarioWeb")

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		sql = "Insert Into PAT_SITUACAO(descricao, indicador_baixado, situacao, usuario_incl)"
		sql = sql & " Values ("
		sql = sql & "'" & strDescricao & "',"
		sql = sql & intIndicadorBaixado & ","
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strUsuario & "')"
		cnn.execute sql
		GravarLog sql			
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update PAT_SITUACAO Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " indicador_baixado = " & intIndicadorBaixado & ","
		sql = sql & " situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario & "',"
		sql = sql & " data_hora_altr = GETDATE()"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from PAT_SITUACAO "
		sql = sql & " where codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='pat_situacao.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.\n\nObs: se a situação estiver vinculada a algum patrimônio, não pode ser excluída.");
			window.history.back();
		</script>
		<%
	end if
%>
