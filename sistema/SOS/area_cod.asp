<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strUsuarioPortal 			= Trim(Request.Form("txtUsuarioPortal"))
	intCodGrupo				= Trim(session("codGrupo"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("usuarioWeb")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("usuarioWeb")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SOS_AREA(Cod_grupo,usua_codg, Descricao, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "'" & intCodGrupo  & "',"
		sql = sql & "'" & strUsuarioPortal & "',"
		sql = sql & "'" & strDescricao & "',"
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		cnn.execute sql
		GravarLog sql

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SOS_AREA Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " usua_codg = '" & strUsuarioPortal & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " and Cod_grupo = " & intCodGrupo 		
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SOS_AREA "
		sql = sql & " where Codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='area_cad.asp';
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