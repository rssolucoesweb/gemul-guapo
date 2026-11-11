<%	
	if trim(intCodCursoCombo) = "" then intCodCursoCombo = "0"
	
	sql = "EXEC SP_MostraDisponibilidadeCurso " & intCodEmpresaGrupo & "," & strAnoLetivo & "," & intSemestre & ",'" & strTipoModulacao & "','" &strTipoLancamento& "'," &intCodTurnoColaborador
	RS.OPEN SQL, CNN
%>
<select name="cmbCursoCombo" id="cmbCursoCombo" style="width:250pt" class="combo"  <%=strSubmitFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCursoCombo) = trim(rs("Cod_Curso")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Curso")& " " & strSelecionado &">" & rs("curso") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>