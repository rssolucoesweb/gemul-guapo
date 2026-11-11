<%
	IF strUsuarioIncl = "" THEN strUsuarioIncl = Session("UsuarioWeb")
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = strSemestre
	if trim(intSemestre) = "" then intSemestre = session("strSemestre")

	if intCodAluno <> "" then 
		intCdTipoParcela = intCodTaxa
		'insere ocorrência
		sql = "Insert Into SCA_OCORRENCIA(COD_EMPRESA, COD_DEPARTAMENTO, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_TIPOPARCELA, COD_DEBITOALUNO, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodDepartamento & ","
		sql = sql & "" & intCodAluno & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		if intCdTipoParcela = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCdTipoParcela & ","
		end if
		if intCodBebitoAluno = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodBebitoAluno & ","
		end if
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