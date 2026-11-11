<%
	IF strUsuarioIncl = "" THEN strUsuarioIncl = Session("UsuarioWeb")
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = strSemestre
	if intCodDepartamento = "" then intCodDepartamento = "0"
	if trim(intSemestre) = "" then intSemestre = session("strSemestre")

	if intCodFunc <> "" then 
		'insere ocorrência
		if strAcao = "E" then intCodFunc = "Null"
	
		sql = "Insert Into SRH_OCORRENCIA(COD_EMPRESA, COD_DEPARTAMENTO, COD_Colaborador, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodDepartamento & ","
		sql = sql & "" & intCodFunc & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "getdate(),"
		sql = sql & "null,"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & strUsuarioIncl & "')"
		cnn.execute sql	
		GravarLog sql
	end if			
%>