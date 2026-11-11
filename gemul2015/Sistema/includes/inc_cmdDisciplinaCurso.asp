<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina da grade
-->
<%	

	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = " SELECT DISTINCT  D.COD_DISCIPLINA, D.DESC_DISCIPLINA "
	sql = sql & " FROM  SCA_GRADECURRICULARDISCIPLINA GCD "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = GCD.COD_GRADECURRICULAR "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=GC.COD_PERIODO "
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = GCD.COD_DISCIPLINA "
	sql = sql & " WHERE P.COD_CURSO = " & intCodCurso 
	sql = sql & " AND GC.SITUACAO='A' "
	sql = sql & " ORDER BY D.DESC_DISCIPLINA " 
	RS.OPEN SQL, CNN
	%>
	<select name="cmbDisciplinaCurso" id="cmbDisciplinaCurso" style="width:150pt" class="combo" <%=strFuncao%>>
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplinaCurso) = trim(rs("COD_Disciplina")) then
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