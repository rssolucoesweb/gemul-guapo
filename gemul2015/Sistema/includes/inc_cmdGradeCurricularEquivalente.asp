<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Grade Curricular 
-->
<%	
	if strExecutarSubmitGradeCurricularEquivalencia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if intCodPeriodo = "" then intCodPeriodo = 0
	if intCodCurso = "" then intCodCurso = 0
	
	sql = "SELECT SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_CURSO.Descricao AS curso, "
	sql = sql & " SCA_PERIODO.Descricao AS periodo, "
	sql = sql & " SCA_GRADECURRICULAR.SemestreReferencia, SCA_GRADECURRICULAR.AnoReferencia"
	sql = sql & " FROM  SCA_GRADECURRICULAR "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso"
	sql = sql & " WHERE SCA_GRADECURRICULAR.Situacao = 'A' "
	sql = sql & " AND SCA_CURSO.Cod_curso = " & intCodCurso
	'sql = sql & " AND SCA_PERIODO.Cod_Periodo = " & intCodPeriodo 
	rsaux.OPEN SQL, CNN
%>
<select name="cmbGradeEquivalente" id="cmbGradeEquivalente" style="width:350pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
	<%
	IF rsaux.EOF = FALSE THEN
		while not rsaux.eof
			
			if trim(rsaux("SemestreReferencia")) = "1" then
				strDescSemestre = "1º Semestre"
			elseif trim(rsaux("SemestreReferencia")) = "2" then
				strDescSemestre = "2º Semestre"
			elseif trim(rsaux("SemestreReferencia")) = "3" then
				strDescSemestre = "Anual"
			end if	

			
					
			if trim(intCodGradeEquivalente) = trim(rsaux("Cod_GradeCurricular")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rsaux("Cod_GradeCurricular")& " " & strSelecionado &">" & rsaux("curso") & " - " &  rsaux("periodo") & " - " &  rsaux("AnoReferencia") & "/" & strDescSemestre & " - " & zeroleft(CodAgrupamento,3) & "</option> "  & vbcrlf
			rsaux.movenext
		wend
	END IF
	rsaux.close
%>
</select>