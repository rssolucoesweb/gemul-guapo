<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodAluno 			= Trim(Request.Form("txtCodAluno"))
	strObservacao 			= Trim(Request.Form("txtObservacao"))
    acao 					= Trim(Request.QueryString("acao"))
	strAnoLetivo = session("strAnoLetivo")
	intSemestre  = session("strSemestre")

	if acao="I" then
		
		strMensagem = "Registro incluido com sucesso!"
		
		sql = "Insert Into SCA_OBSERVACAO_NOTAS_FALTAS (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATA, OBSERVACAO, USUARIO_INCL, DATA_HORA_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodAluno & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "getdate(),"
		sql = sql & "'" & strObservacao & "',"
		sql = sql & "'" & Session("UsuarioWeb") & "',"
		sql = sql & "GETDATE())"
		cnn.execute sql
		GravarLog sql
		
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso!"
		
		sql = "Update SCA_OBSERVACAO_NOTAS_FALTAS Set"
		sql = sql & " OBSERVACAO = '" & strObservacao & "'"
		sql = sql & " where CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then

		strMensagem = "Registro excluido com sucesso!"

		sql = "Delete from SCA_OBSERVACAO_NOTAS_FALTAS "
		sql = sql & " where CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.close();
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