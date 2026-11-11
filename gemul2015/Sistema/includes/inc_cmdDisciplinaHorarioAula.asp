<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina do horario de aula
-->
<%	
	if strExecutarSubmitDisciplinaHorarioAula = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodSequenciaAula = "" then intCodSequenciaAula = 0
	if intCodTempoAula = "" then intCodTempoAula = 0
	if intCodCurso = "" then intCodCurso = 0
	sql = "SELECT "
	sql = sql & " 	HA.COD_DISCIPLINA,"
	sql = sql & " 	D.DESC_DISCIPLINA, HA.CODIGO AS CODHORARIOAULA"
	sql = sql & " FROM SCA_HORARIO_AULA HA"
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA = HA.COD_EMPRESA AND D.COD_DISCIPLINA = HA.COD_DISCIPLINA"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
	sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")	
	sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
	sql = sql & " AND HA.SEMESTRE in (" & strSemestre & ")"
	sql = sql & " AND P.COD_PERIODO = " & intCodPeriodo
	sql = sql & " AND P.COD_CURSO = " & intCodCurso
	sql = sql & " AND HA.SEQUENCIA = " & intCodSequenciaAula
	sql = sql & " AND HA.TEMPO = " & intCodTempoAula
	sql = sql & " Order by DESC_Disciplina"
	RS.OPEN SQL, CNN
	%>
	<select name="cmbDisciplinaHorarioAula" id="cmbDisciplinaHorarioAula" style="width:150pt" class="combo" <%=strFuncao%>>
		<option value="0">Selecione...</option>
	<%
	intCodHorarioAula = ""
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplina) = trim(rs("COD_Disciplina")) then
				strSelecionado = " selected"
				intCodHorarioAula = rs("CODHORARIOAULA")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & rs("DESC_Disciplina") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
<input type="hidden" name="txtCodHorarioAula" value="<%=intCodHorarioAula%>" />