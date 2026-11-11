<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Objetivo Pagina...: Consulta de turma  
-->
<%	
	
	IF intCodGrade = "" THEN intCodGrade = 0
	
	sql = "SELECT Cod_Turma, NomeTurma, AnoLetivo, Cod_Semestre, SCA_TURMA.TurmaAluno FROM SCA_TURMA"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " AND Cod_GradeCurricular = " & intCodGrade
	sql = sql & " AND Situacao = 'A' " 
	sql = sql & " order by SCA_TURMA.nometurma "
	RS.OPEN SQL, CNN
%>
<select name="cmbTurmaGradeRemanejamento" id="cmbTurmaGradeRemanejamento" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurmaGradeRemanejamento) = trim(rs("cod_turma")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Turma") & " " & strSelecionado & ">" & Trim(rs("TurmaAluno")& " " & rs("NomeTurma")) & " - " &rs("AnoLetivo") &"/" &rs("Cod_Semestre") & "</option>" & vbcrlf

			rs.movenext

		wend
	END IF
	rs.close
%>
</select>