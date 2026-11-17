<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'on error resume next
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodTurma 			= Trim(Request.Form("txtCodTurma"))
	strObservacao 			= Trim(Request.Form("txtObservacao"))
	strMes = Trim(Request.Form("txtMes"))
    acao 					= Trim(Request.QueryString("acao"))
	strAnoLetivo = session("strAnoLetivo")
	intSemestre  = session("strSemestre")

	' Valida o mês e o ano também no servidor, antes de iniciar a transação.
	if acao = "I" or acao = "A" then
		if not (strMes = "1" or strMes = "2" or strMes = "3" or strMes = "4" or strMes = "5" or strMes = "6" or strMes = "7" or strMes = "8" or strMes = "9" or strMes = "10" or strMes = "11" or strMes = "12") then
			Response.Write "<script>alert('Selecione um mês válido.'); history.back();</script>"
			Response.End
		end if
		strAnoLetivo = Trim(CStr(strAnoLetivo))
		if Len(strAnoLetivo) <> 4 or not IsNumeric(strAnoLetivo) then
			Response.Write "<script>alert('Ano letivo inválido na sessão.'); history.back();</script>"
			Response.End
		end if
		strDataMes = strAnoLetivo & Right("0" & strMes, 2) & "01"
	end if

	'----------Inicia uma transação--------------
	cnn.begintrans

	if acao="I" then
		
		strMensagem = "Registro incluido com sucesso!"
		
		sql = "Insert Into SCA_OBSERVACAO_DIARIO_TURMA (COD_EMPRESA, COD_TURMA, ANO_LETIVO, SEMESTRE, DATA, OBSERVACAO, USUARIO_INCL, DATA_HORA_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodTurma & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "CONVERT(date, '" & strDataMes & "', 112),"
		sql = sql & "'" & strObservacao & "',"
		sql = sql & "'" & Session("UsuarioWeb") & "',"
		sql = sql & "GETDATE())"
		response.write sql
		cnn.execute sql
		GravarLog sql
		
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso!"
		
		sql = "Update SCA_OBSERVACAO_DIARIO_TURMA Set"
		sql = sql & " OBSERVACAO = '" & strObservacao & "',"
		sql = sql & " DATA = CONVERT(date, '" & strDataMes & "', 112)"
		sql = sql & " where CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then

		strMensagem = "Registro excluido com sucesso!"

		sql = "Delete from SCA_OBSERVACAO_DIARIO_TURMA "
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