<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<%
	IF strUsuarioIncl = "" THEN strUsuarioIncl = Session("UsuarioWeb")
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = strSemestre
	if intCodDepartamento = "" then intCodDepartamento = "0"
	if trim(intSemestre) = "" then intSemestre = session("strSemestre")

	if intCodFunc <> "" then 
		'insere ocorrência
		if strAcao = "E" then intCodFunc = "Null"
	
		sql = "Insert Into SRH_OCORRENCIA(COD_EMPRESA, COD_DEPARTAMENTO, COD_Colaborador, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL, COD_CARGO_ANTERIOR, COD_CARGO_ATUAL, COD_FUNCAO_ANTERIOR, COD_FUNCAO_ATUAL, COD_TURNO_ANTERIOR, COD_TURNO_ATUAL, SITUACAO_ANTERIOR, SITUACAO_ATUAL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodDepartamento & ","
		sql = sql & "" & intCodFunc & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "getdate(),"
		sql = sql & "null,"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & strUsuarioIncl & "',"
		if trim(strCargoAtual) <> trim(intCodCargo) then	
			sql = sql & "" & strCargoAtual & ","
			sql = sql & "" & intCodCargo & ","
		else
			sql = sql & "null,"	
			sql = sql & "null,"
		end if	
		if trim(strFuncaoAtual) <> trim(intCodFuncao) then	
			sql = sql & "" & strFuncaoAtual & ","
			sql = sql & "" & intCodFuncao & ","
		else
			sql = sql & "null,"	
			sql = sql & "null,"
		end if
		if trim(strTurnoAtual) <> trim(intCodTurno) then
			sql = sql & "" & strTurnoAtual & ","
			sql = sql & "" & intCodTurno & ","
		else
			sql = sql & "null,"	
			sql = sql & "null,"
		end if	
		if trim(strSituacaoAtual) <> trim(strSituacao) then	
			sql = sql & "'" & strSituacaoAtual & "',"
			sql = sql & "'" & strSituacao & "'"
		else
			sql = sql & "null,"	
			sql = sql & "null"
		end if	
		sql = sql & ")"
		cnn.execute sql	
		GravarLog sql
	end if			
%>