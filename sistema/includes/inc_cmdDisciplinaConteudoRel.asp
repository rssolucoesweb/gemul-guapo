<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina do horario de aula
-->
<%	
		
	if strExecutarSubmitDisciplinaDoProfessor = "" then
		strFuncao = ""
		if strSubmitDisciplinaMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaDisciplina(this.value)'"
		end if
		
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodSequenciaAula = "" then intCodSequenciaAula = 0
	if intCodTempoAula = "" then intCodTempoAula = 0
	if intCodCurso = "" then intCodCurso = 0
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodTurma = "" then intCodTurma = "0"

	sql = " select DISTINCT CON.COD_TURMA, CON.COD_DISCIPLINA, D.DESC_DISCIPLINA from SCA_CONTEUDO CON "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = CON.COD_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = con.Cod_Disciplina "
	sql = sql & " WHERE CON.Cod_Empresa = " & Session("CodEmpresa")
	if strAnoLetivo <> "" then
		sql = sql & " AND CON.AnoLetivo = " & strAnoLetivo
	end if
	sql = sql & " AND CON.Semestre = " & intSemestre
	sql = sql & " AND CON.Cod_Colaborador = " & intCodProfessor
	sql = sql & " AND C.Cod_Curso = " & trim(intCodCurso)
	sql = sql & " AND p.Cod_Periodo = " & trim(intCodPeriodo)
	sql = sql & " AND con.cod_turma = " & intCodTurma	
	sql = sql & " and CON.Fechamento = 'S' "
	sql = sql & " Order by DESC_Disciplina"
	RS.OPEN SQL, CNN

	%>
	<select name="cmbDisciplinaDoProfessor" id="cmbDisciplinaDoProfessor" style="width:230pt" class="form-control" <%=strFuncao%>>
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
			response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & rs("COD_Disciplina") & " - " & rs("DESC_Disciplina") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
