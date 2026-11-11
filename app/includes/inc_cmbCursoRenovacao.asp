<%	
	sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, Cod_Grau"
	sql = sql & " FROM SCA_CURSO"
	SQL = SQL & " WHERE Situacao = 'A' "
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbCurso<%=strCodigoAluno%>" id="cmbCurso<%=strCodigoAluno%>" class="form-control" onchange="carregaPeriodo(this.value,<%=strCodigoAluno%>)">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCursoRenovacao) = trim(rs("Cod_curso")) then
				strSelecionado = " selected"
				strCurso = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_curso")& " " & strSelecionado &">" & rs("Sigla") & "-" &  rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>