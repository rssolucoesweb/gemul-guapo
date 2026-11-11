<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso 
-->
<%	
	if intSemestreHistorico = "" then intSemestreHistorico 			= session("strSemestre")
	if strAnoHistorico = "" then strAnoHistorico 			= session("strAnoLetivo")

	if strExecutarSubmitTurma = "" then

		if strSubmitTurmaMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaTurma(this.value)'"
		end if
	
	else
		strFuncao = "onchange='submit()'"
		
	end if
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intSemestre = "" then intSemestre = "0"
	
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_PERIODO.tipo, SCA_TURMA.AnoLetivo, SCA_TURMA.TurmaAluno "
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Situacao = 'A' " 
	if 	intCodCurso <> "0" then
		sql = sql & " AND SCA_PERIODO.Cod_Curso = " & intCodCurso
	end if
	sql = sql & " order by SCA_TURMA.NomeTurma"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurmaHistorico" id="cmbTurmaHistorico" class="combo" <%=strFuncao%>>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurmaHistorico) = trim(rs("cod_turma")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">" & Trim(rs("TurmaAluno")& " " & rs("NomeTurma")) & " - " & rs("AnoLetivo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>