<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	strCodGrupo	        = Session("CodGrupo")
	acao 				= Trim(Request.QueryString("acao"))
	intCodigo	 		= Trim(Request.form("txtCodigo"))
	strNome	 			= Trim(Request.form("txtNome"))
	strLetivo 			= Trim(Request.form("cmbLetivo"))
	strSituacao	 		= Trim(Request.form("cmbSituacao"))
	strCor		 		= Trim(Request.form("txtCor"))

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_CALENDARIO_EVENTO(Cod_empresa, nome, letivo, cor, situacao)"          
		sql = sql & " Values ("
		sql = sql & "" & strCodGrupo & ","
		sql = sql & "'" & strNome & "',"
		sql = sql & "'" & strLetivo & "',"
		sql = sql & "'" & strCor & "',"
		sql = sql & "'" & strSituacao & "')"
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_CALENDARIO_EVENTO Set"
		sql = sql & " nome = '" & strNome & "',"
		sql = sql & " letivo = '" & strLetivo & "',"
		sql = sql & " cor = '" & strCor & "',"
		sql = sql & " situacao = '" & strSituacao & "'"
		sql = sql & " Where cod_calendario_evento = " & intCodigo 
		
	else

		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_CALENDARIO_EVENTO "
		sql = sql & " Where cod_calendario_evento = " & intCodigo
	
	end if
	
	cnn.execute sql
    GravarLog sql
		
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='CalendarioEvento_cad.asp';
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