<%	
	if strExecutarSubmitModalidade = "" then
		strExecutarSubmitModalidade = ""
	else
		strExecutarSubmitModalidade = "onchange='submit()'"
	end if

	sql = "SELECT cod_modalidade as codigo, descricao "
	sql = sql & " FROM ESP_modalidade"
	sql = sql & " WHERE situacao = 'A'"
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbModalidade" id="cmbModalidade" class="form-control" <%=strExecutarSubmitModalidade%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_modalidade) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>