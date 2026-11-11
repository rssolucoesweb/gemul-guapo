<%	
	if strReloadDisciplinaRem = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if intCodGradeRemanejamento = "" then intCodGradeRemanejamento = 0

	sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
	sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual "
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA INNER JOIN SCA_DISCIPLINA "
	sql = sql & " ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	SQL = SQL & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodGradeRemanejamento
	sql = sql & " Order by DESC_Disciplina "
	RS.OPEN SQL, CNN
	
	%>
    <select name="cmbDisciplinaRemanejamento" id="cmbDisciplinaRemanejamento" class="form-control"  <%=strFuncao%>>
	<option value="0">Selecione...</option>
	<%
    strCodGradeCurricularDisciplina = ""
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if cstr(trim(intCodDisciplinaRemanejamento)) = cstr(trim(rs("Cod_Disciplina"))) then
                strSelecionado = "selected"
                strCodGradeCurricularDisciplinaRemanejamento = RS("Cod_GradeCurricularDisciplina")
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("Cod_Disciplina") & " " & strSelecionado & ">" & ucase(rs("Desc_Disciplina")) & "</option>" & vbcrlf
            rs.movenext
        wend
    END IF
	rs.close
%>
</select>
