<%
	IF strUsuarioIncl = "" THEN strUsuarioIncl = Session("UsuarioWeb")
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = strSemestre
	if trim(intSemestre) = "" then intSemestre = session("strSemestre")

	if intCodAluno <> "" then 
		'insere ocorrência
		sql = "Insert Into MAT_OCORRENCIA_MATRICULA(COD_EMPRESA, COD_ALUNO, COD_INSCRICAO, ANO_LETIVO, SEMESTRE, NOME_ALUNO_MATRICULA, DATA_NASCIMENTO_MATRICULA, MAE_MATRICULA, NOME_ALUNO_EFETIVACAO, DATA_NASCIMENTO_EFETIVACAO, MAE_EFETIVACAO, OCORRENCIA, DATAOCORRENCIA, USUARIO_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & strCodEmpresa & ","
		sql = sql & "" & intCodAluno & ","
		sql = sql & "" & strCodInscricao & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & strSemestre & ","
		sql = sql & "'" & strNomealunoMatricula & "',"
		sql = sql & "'" & strDatanascimentoMatricula & "',"
		sql = sql & "'" & strMaeMatricula & "',"
		sql = sql & "'" & strNomealuno & "',"
		sql = sql & "'" & strDatanascimento & "',"
		sql = sql & "'" & strMae & "',"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "GETDATE(),"
		sql = sql & "'" & strUsuarioIncl & "')"
		cnn.execute sql				
	end if			
%>