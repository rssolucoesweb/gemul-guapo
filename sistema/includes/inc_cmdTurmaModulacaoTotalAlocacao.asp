<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso 
-->
<%	
	'if intSemestre = "" then intSemestre 			= session("strSemestre")
	'if strAnoLetivo = "" then strAnoLetivo 			= session("strAnoLetivo")

	if strExecutarSubmitTurmaAlocacao = "" then

		if strSubmitTurmaMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaTurma(this.value)'"
		end if
	
	else
		strFuncao = "onchange='submit()'"
		
	end if
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodGrade = "" then intCodGrade = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intSemestre = "" then intSemestre = "0"
	if intCodTurno = "" then intCodTurno = "0"
	
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_PERIODO.tipo, SCA_TURMA.SITUACAO, SCA_TURMA.TurmaAluno, SCA_PERIODO.Descricao  "
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	
	if 	intCodCurso <> "0" and intCodCurso <> "" then
		sql = sql & " AND SCA_PERIODO.Cod_Curso = " & intCodCurso
	end if
	
	if 	intCodPeriodo <> "0" and intCodPeriodo <> "" then
		sql = sql & " AND SCA_PERIODO.Cod_Periodo = " & intCodPeriodo
	end if
	
	if 	intSemestre <> "0" then
		sql = sql & " AND SCA_TURMA.cod_Semestre in (" & session("strSemestre") & ")"
	end if
	
	if 	strAnoLetivo <> "0" then
		sql = sql & " AND SCA_TURMA.AnoLetivo = " & session("strAnoLetivo")
	end if	
	
	'if 	intCodTurno <> "0" then
	'	sql = sql & " AND SCA_TURMA.Cod_Turno = " & intCodTurno
	'end if
	
	if 	intCodGrade <> "0" then
		sql = sql & " AND SCA_TURMA.Cod_GradeCurricular = " & intCodGrade
	end if
	
	sql = sql & " AND ( SCA_TURMA.Situacao = 'A' or  SCA_TURMA.Situacao = 'S') " 
	sql = sql & " and ISNULL(cod_turma_grupo,'0') = 0 "
	sql = sql & " order by SCA_PERIODO.Sequencia"
	
	RS.OPEN SQL, CNN 
%>
<select name="cmbTurmaAlocacao" id="cmbTurmaAlocacao" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurmaAlocacao) = trim(rs("cod_turma")) then
				strSelecionado = " selected"
			else
				strSelecionado = "" 
			end if
			response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">" & "(  " & rs("NomeTurma") & "  ) - " & rs("Descricao") & " " & trim(rs("TurmaAluno")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>