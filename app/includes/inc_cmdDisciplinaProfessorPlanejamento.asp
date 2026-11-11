<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina do horario de aula
-->
<%	
	' Consulta a Categoria	
	if intCodProfessor = "" then
		sql = "select codigo "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		'sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaCategoria 		= "Professor"
			intCodColaboradorProfessor 	= rs("codigo")
			intCodProfessor 	      	= rs("codigo")
		else
			strVerificaCategoria = ""
		end if
		rs.close
		
		if Session("CodColaboradorContrato") <> "" and Session("CodColaboradorContrato") <> "0" then
			intCodColaboradorProfessor 	= Session("CodColaboradorContrato")
			intCodProfessor 	      	= Session("CodColaboradorContrato")
		end if	

	end if

	if intCodSequenciaAula = "" then intCodSequenciaAula = 0
	if intCodTempoAula = "" then intCodTempoAula = 0
	if intCodCurso = "" then intCodCurso = 0
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodTurma = "" then intCodTurma = "0"

	strCpfTurmaProfessor = ""
	if intCodColaboradorProfessor<>"" then
		sql = " Select ISNULL(CPF,'') AS CPF"
		sql = sql & " from SRH_COLABORADOR "
		sql = sql & " where codigo = " & intCodColaboradorProfessor
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs1.open sql, cnn
		if rs1.eof = false then
			strCpfTurmaProfessor = TRIM(rs1("CPF"))
			strVerificaTurmaProfessor = "Professor"
		end if
		rs1.close
    end if
	
	sql = "SELECT Distinct "
	sql = sql & " 	HA.COD_DISCIPLINA, "
	sql = sql & " 	D.DESC_DISCIPLINA"
	sql = sql & " FROM SCA_HORARIO_AULA HA"
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HA.COD_DISCIPLINA"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA=HA.COD_TURMA"
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
	sql = sql & " WHERE 1=1 " 
	sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
	sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
    if 	strVerificaTurmaProfessor	= "Professor" then
		sql = sql & " AND HA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
	end if	
	if intCodTurma<>"0" then
		sql = sql & " AND HA.cod_turma = " & intCodTurma	
	end if
	sql = sql & " Order by D.DESC_Disciplina"
	RS.OPEN SQL, CNN

	%>
	<select name="cmbDisciplinaDoProfessorPlanejamento" id="cmbDisciplinaDoProfessorPlanejamento" class="form-control" <%=strFuncao%>>
		<option value="0">Selecione...</option>
	<%
	intCodHorarioAula = ""
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplina) = trim(rs("COD_Disciplina")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & ucase(rs("DESC_Disciplina")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
