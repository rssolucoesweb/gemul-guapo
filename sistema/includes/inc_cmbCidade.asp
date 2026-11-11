<%	
	if cod_estado = "" then cod_estado = "0"
	if strExecutarSubmitCidade = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, NOME"
	sql = sql & " FROM PES_CIDADE"
	sql = sql & " where cod_estado = " & cod_estado
	sql = sql & " Order by NOME"
	RS.OPEN SQL, CNN
%>
<select name="cmbCidade" id="cmbCidade" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_cidade) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>