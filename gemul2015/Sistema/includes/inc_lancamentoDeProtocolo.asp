<%
	numvias = 0
	'insere protocolo
	sql = "Insert Into SCF_PROTOCOLO(COD_EMPRESA, COD_DEPARTAMENTO, COD_ALUNO, COD_TAXA, COD_DEBITOALUNO, DATASOLICITACAO, DATAENTREGA, DATAVENCIMENTO, SITUACAO, COD_DISCIPLINA, USUARIO_INCL, NUMEROVIAS)"
	sql = sql & " Values ("
	sql = sql & "" & intCodEmp & ","
	sql = sql & "" & intCodDepartamento & ","
	sql = sql & "" & intCodAluno & ","
	sql = sql & "" & intCodTaxa & ","
	if trim(intCodDebitoAluno) = "" then
		sql = sql & "null,"
	else
		sql = sql & "" & intCodDebitoAluno & ","
	end if
	sql = sql & "'" & strDataSolicitacao & " " & time & "',"
	if strDataEntrega = "" then
		sql = sql & "null,"
	else
		sql = sql & "'" & strDataEntrega & "',"
	end if
	if strDataVencimento = "" then
		sql = sql & "null,"
	else
		sql = sql & "'" & strDataVencimento & "',"
	end if	
	sql = sql & "'" & strSituacaoProtocolo & "',"
	if strCodDisciplinaTaxa = "" or strCodDisciplinaTaxa = "0" then
		sql = sql & "null,"
	else
		sql = sql & "'" & strCodDisciplinaTaxa & "',"	
	end if
	sql = sql & "'" & strUsuarioIncl & "'," & numvias & ")"
	cnn.execute sql				
	GravarLog sql		
%>