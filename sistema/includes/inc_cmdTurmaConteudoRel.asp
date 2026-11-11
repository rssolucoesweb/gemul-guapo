<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2009
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Turma Professor
-->
<%	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"

	sql = " select DISTINCT t.cod_turma, t.cod_Semestre , p.Cod_Curso, p.Cod_Periodo, t.cod_turno, t.Sala, t.NomeTurma , t.Cod_empresa, p.tipo, t.SITUACAO, t.TurmaAluno, p.Descricao, p.Sequencia from SCA_CONTEUDO CON "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = CON.COD_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
	sql = sql & " WHERE CON.Cod_Empresa = " & Session("CodEmpresa")
	if strAnoLetivo <> "" then
		sql = sql & " AND CON.AnoLetivo = " & strAnoLetivo
	end if
	sql = sql & " AND CON.Semestre = " & intSemestre
	sql = sql & " AND CON.Cod_Colaborador = " & intCodProfessor
	sql = sql & " AND C.Cod_Curso = " & trim(intCodCurso)
	sql = sql & " AND p.Cod_Periodo = " & trim(intCodPeriodo)
	sql = sql & " and CON.Fechamento = 'S' "
	sql = sql & " order by p.Sequencia"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurmaProfessor" id="cmbTurmaProfessor" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof 
			if trim(intCodTurmaProfessor) = trim(rs("cod_turma")) then
				strSelecionado = " selected"
				intCodComp 	= rs("cod_curso")
				intCodSerie = rs("cod_periodo")
				intCodTurno = rs("cod_turno")
				intCodSemestre = rs("cod_Semestre")
				strTipoPeriodo = rs("tipo")
				strSituacaoTurmaCad = rs("Situacao")
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