<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2009
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Turma Professor
-->
<%	
	if intSemestre = "" then intSemestre 			= session("strSemestre")
	if strAnoLetivo = "" then strAnoLetivo 			= session("strAnoLetivo")
	if intCodTurma = "" then intCodTurma = "0"

	if strExecutarSubmitProfessorTurma = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT distinct T.cod_turma, HA.cod_colaborador, C.nome "
	sql = sql & " FROM SCA_TURMA T "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO P ON G.Cod_Periodo = P.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_HORARIO_AULA HA ON HA.cod_turma = T.cod_turma"
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = HA.cod_colaborador"
	sql = sql & " and HA.semestre = T.cod_Semestre and HA.anoLetivo = T.AnoLetivo "
	sql = sql & " where T.cod_turma = " & intCodTurma 
	sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and HA.anoletivo = " & strAnoLetivo
	sql = sql & " and HA.semestre in (" & intSemestre & ")"
	rs.open sql, cnn
%>
<select name="cmbProfessorTurma" id="cmbProfessorTurma" style="width:250pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("cod_colaborador")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_colaborador")& " " & strSelecionado &">" & rs("nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>