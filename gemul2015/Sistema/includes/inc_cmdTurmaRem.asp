<%	
	if strReloadDisciplinaRem = "N" then 'Verifica se é para dar o reload na página
		strFuncao = ""
	else
		strFuncao = "onChange='return reload()'"
	end if

	sql = "SELECT Cod_Turma, NomeTurma, Cod_Gradecurricular, TurmaAluno "
	SQL = SQL & " FROM SCA_TURMA"
	SQL = SQL & " WHERE cod_empresa = " & Session("CodEmpresa")
	'sql = sql & " AND cod_Semestre in (" & session("strSemestre") & ")"
	'sql = sql & " AND AnoLetivo = " & session("strAnoLetivo")
	sql = sql & " order by SCA_TURMA.NomeTurma"
	RSAux.OPEN SQL, CNN
%>
<select name="cmbTurmaRem" id="cmbTurmaRem" class="combo" <%=strFuncao%>>
<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodTurmaRemejamento) = trim(RSAux("cod_turma")) then
				strSelecionado = " selected"
				intCodGradeRemanejamento = RSAux("Cod_Gradecurricular")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSAux("cod_turma")& " " & strSelecionado &">" & Trim(RSAux("TurmaAluno")& " " & RSAux("NomeTurma")) & "</option> "  & vbcrlf
			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>