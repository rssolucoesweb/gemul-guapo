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

	sql = "SELECT Distinct "
	sql = sql & " 	HA.COD_TURMA, HA.COD_DISCIPLINA, "
	sql = sql & " 	D.DESC_DISCIPLINA"
	sql = sql & " FROM SCA_HORARIO_AULA HA"
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HA.COD_DISCIPLINA"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA=HA.COD_TURMA"
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
	sql = sql & " WHERE 1=1 " 
	'HA.COD_EMPRESA = " & Session("CodEmpresa")	
	sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
	sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
	sql = sql & " AND HA.cod_colaborador = " & intCodColaboradorProfessor	
	sql = sql & " AND HA.cod_turma = " & intCodTurmaProfessor	
	sql = sql & " Order by DESC_Disciplina"
	RS.OPEN SQL, CNN

	%>
	<select name="cmbDisciplinaDoProfessor" id="cmbDisciplinaDoProfessor" style="width:250pt" class="combo" <%=strFuncao%>>
		<option value="0">** InterDisciplinar **</option>
	<%
	if strFichaDescritivaInterDisciplinar <> "S" then
		intCodHorarioAula = ""
		IF RS.EOF = FALSE THEN
			while not rs.eof
				if trim(intCodDisciplina) = trim(rs("COD_Disciplina")) then
					strSelecionado = "selected"
				else
					strSelecionado = ""
				end if
				response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & rs("DESC_Disciplina") & "</option> "  & vbcrlf
				rs.movenext
			wend
		END IF
	end if	
	rs.close
%>
</select>
