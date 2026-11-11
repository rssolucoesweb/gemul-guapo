<%
	sql = "SELECT codigo, titulo"
	sql = sql & " FROM AEE_DOCUMENTO"
	SQL = SQL & " WHERE situacao ='A' "
	sql = sql & " Order by titulo"
	RS.OPEN SQL, CNN
%>
<select name="cmbModeloDocumento" id="cmbModeloDocumento" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodModeloDocumento) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("titulo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>