<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina da grade
-->
<%	

	if strExecutarSubmitDisciplinaEquivalencia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodGradeEquivalente = "" then intCodGradeEquivalente = 0
	
	sql = " SELECT  SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
	sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual "
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA INNER JOIN SCA_DISCIPLINA "
	sql = sql & " ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	SQL = SQL & " WHERE 	SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodGradeEquivalente
	sql = sql & " Order by SCA_DISCIPLINA.DESC_Disciplina"
	rsaux.OPEN SQL, CNN
	%>
	<select name="cmbDisciplinaGradeEquivalente" id="cmbDisciplinaGradeEquivalente" style="width:350pt" class="combo" <%=strFuncao%>>
		<option value="0">Selecione...</option>
	<%
	IF rsaux.EOF = FALSE THEN
		while not rsaux.eof
			if trim(intCodDisciplinaGradeEquivalente) = trim(rsaux("Cod_GradeCurricularDisciplina")) then
				strSelecionado = " selected"
			
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rsaux("Cod_GradeCurricularDisciplina")& " " & strSelecionado &">" & rsaux("DESC_Disciplina") & "</option> "  & vbcrlf
			rsaux.movenext
		wend
	END IF
	rsaux.close
%>
</select>