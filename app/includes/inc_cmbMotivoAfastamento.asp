<%
	sql = "SELECT COD_EMPRESA, COD_MOTIVO, DESC_MOTIVO"
	sql = sql & " FROM SCA_MOTIVO"
	sql = sql & " Order by DESC_MOTIVO"
	RS.OPEN SQL, CNN
%>
<select name="cmbMotivoAfastamento" id="cmbMotivoAfastamento" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodMotivo) = trim(rs("COD_MOTIVO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_MOTIVO")& " " & strSelecionado &">" & rs("DESC_MOTIVO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>