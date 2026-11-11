<%	
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SCA_FORMAINGRESSO"
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbFormaIngresso" id="cmbFormaIngresso" class="form-control"  <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFormaIngresso) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>