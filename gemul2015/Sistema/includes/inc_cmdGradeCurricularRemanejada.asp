<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Grade Curricular 
-->
<%	
	if strExecutarSubmitGradeCurricular = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodCursoRemanejamento = "" then intCodCursoRemanejamento = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intSemestre = "" then intSemestre = "0"
	
	sql = "SELECT    SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_CURSO.Desc_Abreviada AS curso, SCA_PERIODO.Descricao AS periodo, SCA_GRADECURRICULAR.SemestreReferencia, SCA_GRADECURRICULAR.AnoReferencia"
	sql = sql & " FROM      SCA_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso"
	sql = sql & " WHERE     1=1"
	if intCodGradeRemanejamento <> "0" then
		''sql = sql & " AND     	(SCA_GRADECURRICULAR.Cod_GradeCurricular = " & intCodGradeRemanejamento & ")"
	end if
	if intCodCursoRemanejamento <> "0" then
		sql = sql & " AND     	(SCA_PERIODO.Cod_Curso = " & intCodCursoRemanejamento & ")"
	end if
	sql = sql & " AND     	(SCA_GRADECURRICULAR.Situacao = 'A')"

'	if intSemestre <> "0" then
'		sql = sql & " AND     	(SCA_GRADECURRICULAR.SemestreReferencia = " & intSemestre & ")"
'	end if
	RS.OPEN SQL, CNN
%>
<select name="cmbGradeRemanejada" id="cmbGradeRemanejada" style="width:320pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodGradeRemanejamento) = trim(rs("Cod_GradeCurricular")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			
			response.write "<option value=" & rs("Cod_GradeCurricular")& " " & strSelecionado &">" & rs("curso") & " - " &  rs("periodo") & " - " &  rs("AnoReferencia") & "/" & rs("SemestreReferencia") & " - " & zeroleft(CodAgrupamento,3) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>