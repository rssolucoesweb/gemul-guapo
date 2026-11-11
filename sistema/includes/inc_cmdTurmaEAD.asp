<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2009
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Turma Professor
-->

<%	
	if cod_colaborador="" then
		' Consulta a Categoria	
		sql = "select codigo, cpf "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaTurmaProfessor	= "Professor"
			strCpfTurmaProfessor = rs("cpf")
		else
			strVerificaTurmaProfessor = ""
		end if
		rs.close
	else
		' Consulta a Categoria
		sql = "select codigo, cpf "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo = " & cod_colaborador
		sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaTurmaProfessor	= "Professor"
			strCpfTurmaProfessor = rs("cpf")
		else
			strVerificaTurmaProfessor = ""
		end if
		rs.close
	end if
	
	sql = "SELECT distinct SCA_TURMA.cod_turma, SCA_TURNO.DESC_TURNO AS TURNO, SCA_PERIODO.cod_curso, SCA_TURMA.cod_periodo, SCA_TURMA.cod_turno, SCA_TURMA.NomeTurma, SCA_TURMA.TurmaAluno AS TURMA "
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_curso "
	sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO "

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
	
	if strDataHorarioAulaExtra <> "" then
		sql = sql & " UNION "
		'
		sql = sql & " SELECT distinct SCA_TURMA.cod_turma, SCA_TURNO.DESC_TURNO AS TURNO, SCA_PERIODO.cod_curso, SCA_TURMA.cod_periodo, SCA_TURMA.cod_turno, SCA_TURMA.NomeTurma, SCA_TURMA.TurmaAluno AS TURMA"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_curso "
		sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO "
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
		sql = sql & " order by SCA_TURMA.NomeTurma"
	else
		sql = sql & " order by SCA_TURMA.NomeTurma"
	end if
	RS.OPEN SQL, CNN
%>
<select name="cmbTurmaProfessor" id="cmbTurmaProfessor" class="form-control" onChange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurmaProfessor) = trim(rs("cod_turma")) then
				strSelecionado = " selected"
				intCodComp 	= rs("cod_curso")
				intCodSerie = rs("cod_periodo")
				intCodTurno = rs("cod_turno")
				intCodSemestre = intSemestre
				'strTipoPeriodo = rs("tipo")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">"  & Trim(rs("turma")& " " & rs("NomeTurma")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>