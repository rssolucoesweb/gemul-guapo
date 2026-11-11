<%	
	if strExecutarSubmitcategoria = "" then
		strExecutarSubmitcategoria = ""
	else
		strExecutarSubmitcategoria = "onchange='submit()'"
	end if

	sql = "SELECT cod_categoria as codigo, descricao, iif (sexo='M','MASCULINO','FEMININO') as sexo "
	sql = sql & " FROM ESP_categoria"
	sql = sql & " WHERE situacao = 'A'"
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbCategoria" id="cmbCategoria" class="form-control" <%=strExecutarSubmitcategoria%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_categoria) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("Descricao") & " - " & rs("sexo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>