<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Consulta de Turna com plano de pagamento 
-->
<%	
	if strExecutarSubmitTurma = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodGrade = "" then intCodGrade = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intSemestre = "" then intSemestre = "0"
	if intCodTurno = "" then intCodTurno = "0"
	
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.TurmaAluno "
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " AND SCA_TURMA.COD_PLANOPAGAMENTO IS NOT NULL"
	if 	intCodCurso <> "0" then
		sql = sql & " AND SCA_PERIODO.Cod_Curso = " & intCodCurso
	end if
	if 	intCodPeriodo <> "0" then
		sql = sql & " AND SCA_PERIODO.Cod_Periodo = " & intCodPeriodo
	end if
	if 	intSemestre <> "0" then
		sql = sql & " AND SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
	end if
	if 	strAnoLetivo <> "0" then
		sql = sql & " AND SCA_TURMA.AnoLetivo = " & strAnoLetivo
	end if	
	if 	intCodTurno <> "0" then
		sql = sql & " AND SCA_TURMA.Cod_Turno = " & intCodTurno
	end if
	if 	intCodGrade <> "0" then
		sql = sql & " AND SCA_TURMA.Cod_GradeCurricular = " & intCodGrade
	end if
	sql = sql & " AND SCA_TURMA.Situacao = 'A' " 
	RS.OPEN SQL, CNN
%>
<select name="cmbTurma" id="cmbTurma" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurma) = trim(rs("cod_turma")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">" & Trim(rs("TurmaAluno")& " " & rs("NomeTurma")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>