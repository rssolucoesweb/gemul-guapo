<%
	IF strUsuarioIncl = "" THEN strUsuarioIncl = Session("UsuarioWeb")
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = strSemestre
	if trim(intSemestre) = "" then intSemestre = session("strSemestre")

	if intCodAluno <> "" then 
		'insere ocorrência
		sql = "Insert Into SCA_OCORRENCIA(COD_EMPRESA, COD_DEPARTAMENTO, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		if intCodDepartamento = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodDepartamento & ","
		end if
		sql = sql & "" & intCodAluno & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strDataOcorrencia & " " & time & "',"
		if strDataValidade = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strDataValidade & "',"
		end if
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & strUsuarioIncl & "')"
		'response.write sql
		cnn.execute sql	
'		GravarLog sql
	end if			
%>