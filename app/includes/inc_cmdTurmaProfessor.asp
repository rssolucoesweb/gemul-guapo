<%	
	strDataHorarioAulaExtra = strDataInicial
	intCodAnterior = intCodColaboradorProfessor
	if Session("CodColaboradorContrato") <> "" and Session("CodColaboradorContrato") <> "0" then  intCodColaboradorProfessor =  Session("CodColaboradorContrato")

	if intSemestre = "" then intSemestre 			= session("strSemestre")
	if strAnoLetivo = "" then strAnoLetivo 			= session("strAnoLetivo")

	if strExecutarSubmitTurma = "" then
		strFuncao = ""
		if strSubmitTurmaMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaTurma(this.value)'"
		end if

	else
		strFuncao = "onchange='submit()'"
	end if
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodGrade = "" then intCodGrade = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intSemestre = "" then intSemestre = "0"
	if intCodTurno = "" then intCodTurno = "0"
	
	if Session("Seg_CodColaborador")="" then
		' Consulta a Categoria	
		sql = "select codigo "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaTurmaProfessor	= "Professor"
		else
			strVerificaTurmaProfessor = ""
		end if
		rs.close
	else
		' Consulta a Categoria
		if Session("Seg_CodCategoria")	<>"" then
			if Session("Seg_CodCategoria")="1" or Session("Seg_CodCategoria")="8" then	
				strVerificaTurmaProfessor	= "Professor"
			else
				strVerificaTurmaProfessor = ""
			end if
		else
			sql = "select codigo "
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where codigo = " & Session("Seg_CodColaborador")
			sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
			sql = sql & " and Situacao = 'A'" 'Ativo
			rs.open sql, cnn
			if rs.EOF = false then	
				strVerificaTurmaProfessor	= "Professor"
			else
				strVerificaTurmaProfessor = ""
			end if
			rs.close
		end if
	end if
	if intCodTurnoFicha="" then intCodTurnoFicha="0"

	strCpfTurmaProfessor = ""
    sql = " Select ISNULL(CPF,'') AS CPF "
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where codigo = " & intCodColaboradorProfessor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs1.open sql, cnn
	if rs1.eof = false then
		strCpfTurmaProfessor = TRIM(rs1("CPF"))
	end if
	rs1.close
	intCodColaboradorProfessor = intCodAnterior
	sql = "SELECT distinct SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_curso.descricao as curso, SCA_PERIODO.descricao as periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma , SCA_TURMA.Cod_empresa, SCA_PERIODO.tipo, SCA_TURMA.TurmaAluno, SCA_CURSO.sigla "
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_curso = SCA_CURSO.Cod_Curso"
    if 	strVerificaTurmaProfessor	= "Professor" then
		sql = sql & " left JOIN SCA_HORARIO_AULA ON SCA_HORARIO_AULA.cod_turma = SCA_TURMA.cod_turma "
		sql = sql & " and SCA_HORARIO_AULA.semestre = SCA_TURMA.cod_Semestre and SCA_HORARIO_AULA.anoLetivo = SCA_TURMA.AnoLetivo"
		sql = sql & " inner JOIN SRH_COLABORADOR on SRH_COLABORADOR.codigo = SCA_HORARIO_AULA.cod_colaborador"
	end if	
	sql = sql & " where 1=1 "
    if 	strVerificaTurmaProfessor = "Professor" then
		sql = sql & " and SCA_HORARIO_AULA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
	end if	
	sql = sql & " AND SCA_TURMA.Situacao = 'A' " 
	sql = sql & " and SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
	sql = sql & " and SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
	if intCodTurnoFicha<>"0" then
		sql = sql & " and SCA_TURMA.cod_turno = " & intCodTurnoFicha
	end if
	
	if strDataHorarioAulaExtra <> "" then
		sql = sql & " UNION "
		'
		sql = sql & " SELECT distinct SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_curso.descricao as curso, SCA_PERIODO.descricao as periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma , SCA_TURMA.Cod_empresa, SCA_PERIODO.tipo, SCA_TURMA.TurmaAluno, SCA_CURSO.sigla "
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_curso = SCA_CURSO.Cod_Curso"
		if 	strVerificaTurmaProfessor	= "Professor" then
			sql = sql & " left JOIN SCA_HORARIO_AULA_EXTRA ON SCA_HORARIO_AULA_EXTRA.cod_turma = SCA_TURMA.cod_turma "
			sql = sql & " and SCA_HORARIO_AULA_EXTRA.semestre = SCA_TURMA.cod_Semestre and SCA_HORARIO_AULA_EXTRA.anoLetivo = SCA_TURMA.AnoLetivo"
			sql = sql & " inner JOIN SRH_COLABORADOR on SRH_COLABORADOR.codigo = SCA_HORARIO_AULA_EXTRA.cod_colaborador"
		end if	
		sql = sql & " where 1=1 "
		if 	strVerificaTurmaProfessor = "Professor" then
			sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
		end if	
		if 	strVerificaTurmaProfessor	= "Professor" then
			sql = sql & " AND SCA_HORARIO_AULA_EXTRA.DataLancamento = '" & formatadataBD(strDataHorarioAulaExtra) & "' " 
		end if
		sql = sql & " AND SCA_TURMA.Situacao = 'A' " 
		sql = sql & " and SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and SCA_TURMA.anoletivo = " & strAnoLetivo
		sql = sql & " and SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
		if intCodTurnoFicha<>"0" then
			sql = sql & " and SCA_TURMA.cod_turno = " & intCodTurnoFicha
		end if
		sql = sql & " order by SCA_TURMA.NomeTurma"
	else
		sql = sql & " order by SCA_TURMA.NomeTurma"
	end if
	
	
	
	RS.OPEN SQL, CNN
%><%=intCodTurmaProfessor%>
<select name="cmbTurmaProfessor" id="cmbTurmaProfessor" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurmaProfessor) = trim(rs("cod_turma")) then
				strSelecionado = " selected"
				intCodComp 	= rs("cod_curso")
				intCodCurso 	= rs("cod_curso")
				intCodSerie = rs("cod_periodo")
				intCodPeriodo 	= rs("Cod_Periodo")
				intCodTurno 	= rs("cod_turno")
				if carregaturnodireto = "" then intCodTurno = rs("cod_turno")
				intCodSemestre = rs("cod_Semestre")
				strTipoPeriodo = rs("tipo")
				strCurso 		= rs("curso")
				strSerie 		= rs("periodo")
				strCursoSigla 	= rs("sigla")

			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">" & Trim(rs("TurmaAluno")& " " & rs("NomeTurma")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>