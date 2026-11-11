<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina da grade
-->
<%	
	if intCodPeriodo = "" then intCodPeriodo = 0
	sql = " SELECT DISTINCT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
	sql = sql & " SCA_DISCIPLINA.DESC_Disciplina "
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA  "
	sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular "
	sql = sql & " AND	SCA_GRADECURRICULAR.Cod_Empresa = SCA_DISCIPLINA.Cod_Empresa "
	sql = sql & " WHERE SCA_DISCIPLINA.cod_empresa=" &  Session("CodEmpresa")
	sql = sql & " AND 	SCA_GRADECURRICULAR.COD_PERIODO = " & intCodPeriodo
	sql = sql & " Order by DESC_Disciplina"
	RS.OPEN SQL, CNN
	%>
	<select name="cmbDisciplinaGradeHistorico" id="cmbDisciplinaGradeHistorico" style="width:400pt" class="combo" <%=strDisciplina_Disabled%>>
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplinaGradeHistorico) = trim(rs("COD_Disciplina")) then
				strSelecionado = " selected"
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