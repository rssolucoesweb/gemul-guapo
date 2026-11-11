<%	
	sql = "SELECT Cod_NecEspecial, DESC_NecEspecial, DESC_NecEspecialNova, situacao"
	sql = sql & " FROM SCA_NECESSIDADEESPECIAL where Cod_NecEspecial<>12 "
	sql = sql & " Order by DESC_NecEspecial"
	RS.OPEN SQL, CNN
%>
<select name="cmbNecessidadeEspecial" id="cmbNecessidadeEspecial" class="form-control">
	<option value="0">Selecione...</option>
	<option <%if trim(intCodNecessidadeEspecial) = "12" then response.write "selected"%> value="12">Nenhuma</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodNecessidadeEspecial) = trim(rs("Cod_NecEspecial")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			
			situacao = ""
			bloq = ""
			if rs("situacao") = "I" then 
				situacao = " (INATIVA)"
				bloq = "disabled"
			end if
			
			response.write "<option " & bloq & " value=" & rs("Cod_NecEspecial")& " " & strSelecionado &">"&  rs("DESC_NecEspecialNova") & situacao & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>