
<%	
	if strExecutarSubmitSemestreAlocacao = "" then

		strFuncao = ""
		if strSubmitTurmaMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaSemestre(this.value)'"
		end if

	else
		strFuncao = "onchange='submit()'"
	end if
	' o padrão aqui e strSemestre, foi alterado para atender o cadastramento da Fanap
	sql = "SELECT CODIGO, SIGLA, DESCRICAO "
	sql = sql & " FROM SCA_SEMESTRE"
	sql = sql & " where codigo in (" & Session("strTodosSemestre") & ")"    
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbSemestreAlocacao" id="cmbSemestreAlocacao" class="form-control"  <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intSemestreAlocacao) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>