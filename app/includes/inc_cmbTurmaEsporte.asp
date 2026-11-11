<%	
	if strAnoLetivo = "" then strAnoLetivo 			= session("strAnoLetivo")

	if strExecutarSubmitTurma <> "" then
		strFuncao = "onchange='submit()'"
	end if
	
	sql = "SELECT T.COD_TURMA, T.NOME + ' - ' + M.DESCRICAO + ' - ' + C.DESCRICAO  + ' (' + IIF (SEXO='M','MASCULINO','FEMININO') + ')' as nome"
	sql = sql & " FROM ESP_TURMA T"
	sql = sql & " INNER JOIN ESP_MODALIDADE M ON M.COD_MODALIDADE = T.COD_MODALIDADE"
	sql = sql & " INNER JOIN ESP_CATEGORIA C ON C.COD_CATEGORIA = T.COD_CATEGORIA"
	sql = sql & " WHERE T.ANO_LETIVO = " & strAnoLetivo
	sql = sql & " AND T.SITUACAO = 'A'" 
	sql = sql & " ORDER BY M.DESCRICAO, C.DESCRICAO, T.NOME"
	RS.OPEN SQL, CNN
	%>
	<select name="cmbTurma" id="cmbTurma" class="form-control" <%=strFuncao%>>
		<option value="0">Selecione...</option>
		<%
		IF RS.EOF = FALSE THEN
			while not rs.eof
				if trim(intCodTurma) = trim(rs("cod_turma")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
				response.write "<option value=" & rs("cod_turma") & " " & strSelecionado &">" & Trim(rs("NOME")) & "</option> "  & vbcrlf
				rs.movenext
			wend
		END IF
		rs.close
		%>
	</select>