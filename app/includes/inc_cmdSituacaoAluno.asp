
<%	
	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = "SELECT COD_SITUACAOALUNO, DESC_SITUACAOALUNO"
	sql = sql & " FROM SCA_SITUACAOALUNO"
	sql = sql & " WHERE STATUS = 'A' "
	IF strRetiraAtivo = "S" then
		sql = sql & " AND DESC_SITUACAOALUNO not in ('ATIVO','PRÉ-MATRÍCULA')"
	end if
	IF strRetiraPre = "S" then
		sql = sql & " AND DESC_SITUACAOALUNO not in ('PRÉ-MATRÍCULA')"
	end if
	sql = sql & " Order by DESC_SITUACAOALUNO"
	rs.open sql, cnn
%>
<select name="cmbSituacaoAluno" id="cmbSituacaoAluno" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodSituacaoAluno) = trim(rs("COD_SITUACAOALUNO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_SITUACAOALUNO")& " " & strSelecionado &">" & rs("DESC_SITUACAOALUNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>