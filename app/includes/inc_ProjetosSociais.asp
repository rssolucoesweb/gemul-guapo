
<%	
	sql = "SELECT COD_PROJETOSOCIAIS, DESC_PROJETOSOCIAIS"
	sql = sql & " FROM SCA_PROJETOSOCIAIS"
	sql = sql & " Order by DESC_PROJETOSOCIAIS"
	RS.OPEN SQL, CNN
%>
<select name="cmbProjetoSociais" id="cmbProjetoSociais" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProjetoSociais) = trim(rs("COD_PROJETOSOCIAIS")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_PROJETOSOCIAIS")& " " & strSelecionado &">" & rs("DESC_PROJETOSOCIAIS") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>