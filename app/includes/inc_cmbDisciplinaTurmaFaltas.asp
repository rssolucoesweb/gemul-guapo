<%


if strReloadDisciplinaQuadro = "N" then 'Verifica se é para dar o reload na página
	strOnChangeDisciplinaQuadro = ""
	
	if strSubmitDisciplinaMaterial = "" then
		strOnChangeDisciplinaQuadro = ""
	else
		strOnChangeDisciplinaQuadro="onChange='ConsultaDisciplina(this.value)'"
	end if
	
else
	strOnChangeDisciplinaQuadro = "onChange='return reload()'"
end if

if intCodTurma = "" then intCodTurma = "0"

if strTipoPeriodo = "D" then

	SQL = "SELECT     SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
	SQL = SQL & " FROM         SCA_TURMA INNER JOIN"
	SQL = SQL & "                       SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN"
	SQL = SQL & "                       SCA_GRADECURRICULARDISCIPLINA ON "
	SQL = SQL & "                       SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular INNER JOIN"
	SQL = SQL & "                       SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
	SQL = SQL & " WHERE 1=1"
	SQL = SQL & " AND (SCA_TURMA.Cod_Turma = " & intCodTurma & ")"
	RS.OPEN SQL, CNN
	%>
	<select name="cmbDisciplinaTurma" id="cmbDisciplinaTurma" class="form-control"  <%=strDesabilitaDisciplinaQuadro%> <%=" " & strOnChangeDisciplinaQuadro%>>
		<option value="0">Selecione...</option>
	<%
	strCodGradeCurricularDisciplina = ""
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if cstr(intCodDisciplinaTurma) = cstr(rs("Cod_Disciplina")) then
				strSelecionado = "selected"
				strCodGradeCurricularDisciplina = RS("Cod_GradeCurricularDisciplina")
				
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Disciplina") & " " & strSelecionado & ">" & rs("Desc_Disciplina") & "</option>" & vbcrlf
			rs.movenext
		wend
	END IF
	
	rs.close
	%>
	</select>
	   <%
else
   %>
   <select name="cmbDisciplinaTurma" id="cmbDisciplinaTurma" class="form-control"   <%=strDesabilitaDisciplinaQuadro%> <%=" " & strOnChangeDisciplinaQuadro%>>
		<option value="0">Interdisciplinar...</option>
   </select>
   <%
end if
%>
<input type="hidden" value="<%=strCodGradeCurricularDisciplina%>" name="txtCodGradeCurricularDisciplina" />
