<%	
	if strReloadDisciplinaRem = "N" then 'Verifica se é para dar o reload na página
		strFuncao = ""
	else
		strFuncao = "onChange='return reload()'"
	end if

	sql = "SELECT Cod_Turma, SCA_TURMA.cod_empresa_extensao, SCA_TURMA.NomeTurma, SCA_TURMA.turmaAluno, SCA_PERIODO.descricao as periodo, Cod_Gradecurricular "
	SQL = SQL & " FROM SCA_TURMA"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_TURMA.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " AND AnoLetivo = " & strAnoLetivoRenovacao
	'Destino da renovação: o MESMO período (aluno retido) ou o período SEGUINTE.
	'O seguinte vem do de/para (MAT_TIP_DE_PARA, o mesmo da TIP), que permite trocar de curso
	'(ex.: INFANTIL V -> 1º ANO do Fundamental). Período sem de/para: segue a regra antiga
	'(mesmo curso, período + 1).
	if intCodCurso = "" or not isnumeric(intCodCurso) then intCodCurso = "0"
	if intCodPeriodo = "" or not isnumeric(intCodPeriodo) then intCodPeriodo = "0"
	vetDeParaRen = renDePara(intCodPeriodo)
	sql = sql & " AND ((SCA_PERIODO.Cod_curso = " & clng(intCodCurso) & " AND SCA_TURMA.Cod_Periodo = " & clng(intCodPeriodo) & ")"
	if isArray(vetDeParaRen) then
		sql = sql & " OR (SCA_PERIODO.Cod_curso = " & vetDeParaRen(0) & " AND SCA_TURMA.Cod_Periodo = " & vetDeParaRen(1) & "))"
	else
		sql = sql & " OR (SCA_PERIODO.Cod_curso = " & clng(intCodCurso) & " AND SCA_TURMA.Cod_Periodo = " & clng(intCodPeriodo) + 1 & "))"
	end if
	sql = sql & " order by SCA_PERIODO.Cod_Curso, SCA_TURMA.NomeTurma"
	RSAux.OPEN SQL, CNN
%>
<select name="cmbTurmaRenovacao" id="cmbTurmaRenovacao" class="form-control" <%=strFuncao%>>
<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodTurmaRenovacao) = trim(RSAux("cod_turma")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			
			strTurmaExtensao=""
			if not isnull(RSAux("Cod_empresa_extensao")) then
				strTurmaExtensao = " (Extensão)"
			end if
			
			response.write "<option value=" & RSAux("cod_turma")& " " & strSelecionado &">" & RSAux("periodo")  & " - " & Trim(RSAux("TurmaAluno")& " " & RSAux("NomeTurma"))  & strTurmaExtensao & "</option> "  & vbcrlf
			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>