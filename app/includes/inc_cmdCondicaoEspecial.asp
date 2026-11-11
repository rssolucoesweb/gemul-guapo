<%	
	sql = "SELECT COD_CONDICAO_ESPECIAL, DESCRICAO"
	sql = sql & " FROM SCA_CONDICAO_ESPECIAL "
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbCondicaoEspecial" id="cmbCondicaoEspecial" class="form-control" onchange="verificaCondicaoEspecial()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCondicaoEspecial) = trim(rs("COD_CONDICAO_ESPECIAL")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_CONDICAO_ESPECIAL")& " " & strSelecionado &">"&  rs("DESCRICAO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>