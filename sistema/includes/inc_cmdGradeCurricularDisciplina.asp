<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina da grade
-->
<%	
	if strExecutarDisciplinaGrade = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if intCodGrade = "" then intCodGrade = 0

	sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
	sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual "
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA INNER JOIN SCA_DISCIPLINA "
	sql = sql & " ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	SQL = SQL & " WHERE SCA_DISCIPLINA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND 	SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodGrade
	sql = sql & " Order by DESC_Disciplina "
	RS.OPEN SQL, CNN
	%>
	<select name="cmbCodGradeCurricularDisciplina" id="cmbCodGradeCurricularDisciplina" style="width:350pt" class="combo" <%=strDisciplina_Disabled%> <%=strFuncao%> >
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodGradeCurricularDisciplina) = trim(rs("Cod_GradeCurricularDisciplina")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_GradeCurricularDisciplina")& " " & strSelecionado &">" & rs("COD_Disciplina") & " - " & rs("DESC_Disciplina") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>