<%	
	if strExecutarSubmitPeriodo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if trim(intCodCurso) = "" then intCodCurso = "0"
	
	sql = "SELECT Cod_Periodo, Cod_Curso, Descricao, Sequencia"
	sql = sql & " FROM SCA_PERIODO"
	sql = sql & " where cod_curso = " & intCodCursoRenovacao
	sql = sql & " Order by Sequencia"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo<%=strCodigoAluno%>" id="cmbPeriodo<%=strCodigoAluno%>" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPeriodo) = trim(rs("Cod_Periodo")) then
				strSelecionado = " selected"
				strSerie = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Periodo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>