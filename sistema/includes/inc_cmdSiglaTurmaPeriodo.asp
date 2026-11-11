<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2009
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Turma Professor
-->
<%	

	if strExecutarSubmitSiglaTurmaPeriodo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intSemestre = "" then intSemestre 	= session("strSemestre")
	if strAnoLetivo = "" then strAnoLetivo 	= session("strAnoLetivo")

	sql = " SELECT DISTINCT SUBSTRING(SCA_TURMA.NomeTurma,1,3) AS SIGLA"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	sql = sql & " WHERE SCA_TURMA.COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND SCA_PERIODO.Cod_Curso = " & intCodCurso
	sql = sql & " AND SCA_TURMA.cod_Semestre in (" & intSemestre & ")"
	sql = sql & " AND SCA_TURMA.AnoLetivo = " & strAnoLetivo
	sql = sql & " order by SUBSTRING(SCA_TURMA.NomeTurma,1,3) " 
	RS.OPEN SQL, CNN
%>
<select name="cmbSiglaTurmaPeriodo" id="cmbSiglaTurmaPeriodo" style="width:80pt" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strSiglaTurmaPeriodo) = trim(rs("sigla")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("sigla")& " " & strSelecionado &">" & rs("sigla") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>