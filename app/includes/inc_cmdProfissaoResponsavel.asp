<%	
	sql = "SELECT COD_PROFISSAO, DESC_PROFISSAO"
	sql = sql & " FROM SCA_PROFISSAO"
	sql = sql & " Order by DESC_PROFISSAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbProfissaoResponsavel" id="cmbProfissaoResponsavel" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfissaoResponsavel) = trim(rs("COD_PROFISSAO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_PROFISSAO")& " " & strSelecionado &">"&  rs("DESC_PROFISSAO") &"</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>