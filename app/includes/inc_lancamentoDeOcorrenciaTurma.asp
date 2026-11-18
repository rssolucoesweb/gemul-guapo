<%
	IF strUsuarioIncl = "" THEN strUsuarioIncl = Session("UsuarioWeb")
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")

	if intCodTurma <> "" then 
		'insere ocorrência
		sql = "Insert Into SCA_OCORRENCIA_TURMA(COD_EMPRESA, COD_TURMA, ANO_LETIVO, DATAOCORRENCIA, OCORRENCIA, USUARIO_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodTurma & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "getdate(),"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & strUsuarioIncl & "')"
		cnn.execute sql	
		GravarLog sql
	end if			
%>