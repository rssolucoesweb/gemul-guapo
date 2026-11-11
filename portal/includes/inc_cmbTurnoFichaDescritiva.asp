<%	
	strFuncao = "onchange='submit()'"

	SQL = " select DISTINCT T.COD_TURNOFUNCAO AS COD_TURNO, TUR.DESC_TURNO "
	SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO T"
	SQL = SQL & " INNER JOIN SCA_TURNO TUR ON TUR.COD_TURNO = T.COD_TURNOFUNCAO "
	SQL = SQL & " where T.Cod_Turma = "& Session("CodTurma_GemulEad")	
	SQL = SQL & " UNION"
	SQL = SQL & " select DISTINCT DT.COD_TURNOFUNCAO AS COD_TURNO, TUR.DESC_TURNO "
	SQL = SQL & " from SCA_TURMA T "
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA D ON D.Cod_GradeCurricular = G.Cod_GradeCurricular "
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO DT ON D.Cod_GradeCurricularDisciplina = DT.Cod_GradeCurricularDisciplina "
	SQL = SQL & " INNER JOIN SCA_TURNO TUR ON TUR.COD_TURNO = DT.COD_TURNOFUNCAO "
	SQL = SQL & "  where T.Cod_Turma = " & Session("CodTurma_GemulEad")	
	SQL = SQL & "  ORDER BY TUR.DESC_TURNO" 
	RS.OPEN SQL, CNN

	%>
	<select name="cmbTurnoFichaDescritiva" id="cmbTurnoFichaDescritiva" class="form-control" <%=strFuncao%>>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurno) = trim(rs("COD_TURNO")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("DESC_TURNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
rs.close
%>
</select>
