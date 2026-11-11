<%
	sql = "SELECT CODIGO, DESCRICAO, RESUMO, TIPO"
	sql = sql & " FROM SCA_TAMANHO_ROUPA"
	SQL = SQL & " Order by ordem"
	RS.OPEN SQL, CNN
%>
<select name="cmbTamanhoRoupa" id="cmbTamanhoRoupa" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTamanhoRoupa) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("TIPO") & " - " & rs("DESCRICAO") & " (" & rs("resumo") & ")</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>