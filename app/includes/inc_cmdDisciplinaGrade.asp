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
	'IF strCursoSigla = "EF" and strPaginaTitulo = "HorarioAulaExtra_cad.asp" then
	'	sql = "SELECT COD_DISCIPLINA, 0 as Cod_GradeCurricularDisciplina, DESC_DISCIPLINA "
	'	sql = sql & " from SCA_DISCIPLINA where DESC_DISCIPLINA = 'PLANEJAMENTO' AND COD_EMPRESA = " & Session("CodEmpresa")	
	'	sql = sql & " UNION "
	'ELSE
		sql = ""
	'END IF
	
	sql = sql & " SELECT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
	sql = sql & " SCA_DISCIPLINA.DESC_Disciplina"
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA INNER JOIN SCA_DISCIPLINA "
	sql = sql & " ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	SQL = SQL & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodGrade
	sql = sql & " Order by DESC_Disciplina "
	RS.OPEN SQL, CNN
	%>
	<select name="cmbDisciplinaGrade" id="cmbDisciplinaGrade" class="form-control" <%=strDisciplina_Disabled%> <%=strFuncao%> >
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplinaGrade) = trim(rs("COD_Disciplina")) then
				strSelecionado = " selected"
				strCodGradeCurricularDisciplina = rs("Cod_GradeCurricularDisciplina")
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