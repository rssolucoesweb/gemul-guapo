<%	
	if strExecutarSubmitRota = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT cod_rota, descricao from ste_rota where situacao = 'A' order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbRota" id="cmbRota" class="form-control"  <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRota) = trim(rs("cod_rota")) then
				strSelecionado = " selected"
				strSerie = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_rota")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>