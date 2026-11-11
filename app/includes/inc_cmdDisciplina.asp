<%	

	if strExecutarSubmitDisciplina = "" then
		
		if strSubmitDisciplinaMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaDisciplina(this.value)'"
		end if
	
	else
		strFuncao = "onchange='submit()'"
		
	end if
	
	sql = "SELECT COD_Disciplina, DESC_Disciplina, Desc_Abreviada"
	sql = sql & " FROM SCA_DISCIPLINA"
	sql = sql & " Order by DESC_Disciplina"
	RS.OPEN SQL, CNN
%>
<select name="cmbDisciplina" id="cmbDisciplina" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplina) = trim(rs("COD_Disciplina")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & rs("DESC_Disciplina") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>