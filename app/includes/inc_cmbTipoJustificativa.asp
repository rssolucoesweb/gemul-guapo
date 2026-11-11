<%	
	
	if strExecutarSubmitTipoJustificativa = "S" then
		strExecutarSubmitTipoJustificativa = "onchange='submit()'"
	else
		strExecutarSubmitTipoJustificativa = ""
	end if
	
	sql = "SELECT codigo, descricao"
	sql = sql & " FROM SCA_TIPO_JUSTIFICATIVA_FALTAS "
	sql = sql & " order by descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoJustificativa" id="cmbTipoJustificativa" class="form-control" <%=strExecutarSubmitTipoJustificativa%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoJustificativa) = trim(rs("codigo")) then
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